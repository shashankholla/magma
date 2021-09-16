import dataclasses
from typing import Any, Iterable, List, Optional

import magma as m

from graph_base import Graph, Node, topological_sort
from graph_utils import NodeVisitor, NodeTransformer
from mlir_wrapper import MlirContext, MlirValue, MlirType, MlirIntegerType
from passes import Net


def _mlir_base_pass_factory(base):

    class MlirPass(base):
        def __init__(self, g: Graph, ctx: MlirContext):
            super().__init__(g)
            self._ctx = ctx

        @property
        def ctx(self) -> MlirContext:
            return self._ctx

    return MlirPass


MlirNodeVisitor = _mlir_base_pass_factory(NodeVisitor)
MlirNodeTransformer = _mlir_base_pass_factory(NodeTransformer)


def lower_type(type: m.Kind) -> MlirType:
    type = type.undirected_t
    if issubclass(type, m.Digital):
        return MlirIntegerType(1)
    if issubclass(type, m.Bits):
        return MlirIntegerType(type.N)
    raise NotImplementedError(type)


class ModuleInputSplitter(MlirNodeTransformer):
    def generic_visit(self, node: Node):
        if not isinstance(node, m.DefineCircuitKind):
            return node
        nodes = [node]
        edges = list(self.graph.in_edges(node, data=True))
        nodes_to_remove = []
        for edge in self.graph.out_edges(node, data=True):
            _, dst, data = edge
            assert isinstance(dst, Net)
            port = data["info"]
            assert dst.ports[0] is port
            t = lower_type(type(port))
            value = self.ctx.new_value(t, port.name, force=True)
            nodes.append(value)
            assert len(list(self.graph.predecessors(dst))) == 1
            for edge in self.graph.out_edges(dst, data=True):
                _, descendant, data = edge
                edges.append((value, descendant, data))
            nodes_to_remove.append(dst)
        for node in nodes_to_remove:
            self.graph.remove_node(node)
        return nodes, edges


def replace_node(g: Graph, orig: Node, new: Node) -> Iterable[Any]:
    for edge in g.in_edges(orig, data=True):
        src, _, data = edge
        yield (src, new, data)
    for edge in g.out_edges(orig, data=True):
        _, dst, data = edge
        yield (new, dst, data)


class NetToValueTransformer(MlirNodeTransformer):
    def visit_Net(self, node: Net):
        assert len(list(self.graph.predecessors(node))) == 1
        t = lower_type(type(node.ports[0]))
        value = self.ctx.new_value(t)
        edges = list(replace_node(self.graph, node, value))
        return [value], edges


class EdgePortToIndexTransformer(MlirNodeTransformer):
    def visit_MlirValue(self, node: MlirValue):
        return node

    def _get_index(value: m.Type, values: List[m.Type]) -> int:
        for i, v in enumerate(values):
            if v is value:
                return i
        raise KeyError()

    def generic_visit(self, node: Node):
        assert isinstance(node, (m.DefineCircuitKind, m.Circuit))
        edges = []
        finder = type(self)._get_index
        for edge in self.graph.in_edges(node, data=True):
            src, dst, data = edge
            port = data["info"]
            data["info"] = finder(port, node.interface.inputs())
            edges.append((src, dst, data))
        for edge in self.graph.out_edges(node, data=True):
            src, dst, data = edge
            port = data["info"]
            data["info"] = finder(port, node.interface.outputs())
            edges.append((src, dst, data))
        return [node], edges


def values_to_string(values: Iterable[MlirValue], mode=0) -> str:
    if mode == 0:
        mapper = lambda v: v.name
    elif mode == 1:
        mapper = lambda v: v.type.emit()
    else:
        mapper = lambda v: f"{v.name}: {v.type.emit()}"
    return ', '.join(map(mapper, values))


@dataclasses.dataclass(frozen=True)
class MlirOp:
    name: str


@dataclasses.dataclass(frozen=True)
class CombOp(MlirOp):
    name: str
    op: str

    def emit(self, inputs, outputs):
        return (f"{values_to_string(outputs)} = comb.{self.op} {values_to_string(inputs)} : {values_to_string(outputs, 1)}")


@dataclasses.dataclass(frozen=True)
class HwOutputOp(MlirOp):
    name: str

    def emit(self, inputs, outputs):
        return (f"hw.output {values_to_string(inputs)} : {values_to_string(inputs, 1)}")


def lower_module_to_op(module): #: ModuleLike):
    if isinstance(module, m.Circuit):
        return CombOp(module.name, type(module).coreir_name)
    if isinstance(module, m.DefineCircuitKind):
        return HwOutputOp(module.name)
    raise NotImplementedError()


class ModuleToOpTransformer(MlirNodeTransformer):
    def visit_MlirValue(self, node: MlirValue):
        return node

    def generic_visit(self, node: Node):
        assert isinstance(node, (m.DefineCircuitKind, m.Circuit))
        new_node = lower_module_to_op(node)
        edges = list(replace_node(self.graph, node, new_node))
        return [new_node], edges


def sort_values(g: Graph, node: MlirOp):
    inputs = {}
    outputs = {}
    for edge in g.in_edges(node, data=True):
        src, _, data = edge
        idx = data["info"]
        assert idx not in inputs
        inputs[idx] = src
    for edge in g.out_edges(node, data=True):
        _, dst, data = edge
        idx = data["info"]
        assert idx not in outputs
        outputs[idx] = dst
    inputs = [inputs[i] for i in range(len(inputs))]
    outputs = [outputs[i] for i in range(len(outputs))]
    return inputs, outputs


class Emitter:
    def __init__(self):
        self._indent = 0

    def push(self):
        self._indent += 1

    def pop(self):
        self._indent -= 1

    def emit(self, line: str):
        tab = f"{'    '*self._indent}"
        print (f"{tab}{line}")


class EmitMlirVisitor(NodeVisitor):
    def __init__(self, g: Graph, emitter: Optional[Emitter] = None):
        super().__init__(g)
        if emitter is None:
            emitter = Emitter()
        self._emitter = emitter

    def visit_MlirValue(self, node: MlirValue):
        pass

    def generic_visit(self, node: MlirOp):
        assert isinstance(node, MlirOp)
        inputs, outputs = sort_values(self.graph, node)
        self._emitter.emit(node.emit(inputs, outputs))


def emit_module(ckt, g):
    emitter = Emitter()
    inputs = [MlirValue(f"%{port.name}", lower_type(type(port)))
              for port in ckt.interface.outputs()]
    outputs = [MlirValue(f"%{port.name}", lower_type(type(port)))
               for port in ckt.interface.inputs()]
    emitter.emit(f"hw.module @{ckt.name}({values_to_string(inputs, 2)}) -> ({values_to_string(outputs, 2)}) {{")
    emitter.push()
    EmitMlirVisitor(g, emitter).run(topological_sort)
    emitter.pop()
    emitter.emit("}")
