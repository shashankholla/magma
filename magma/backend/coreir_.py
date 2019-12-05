from collections import OrderedDict
import logging
import os
from .. import singleton
from ..array import ArrayType
from ..circuit import DeclareCircuit
from ..clock import AsyncResetType, AsyncResetNType
from coreir import Context
from .coreir_transformer import DefnOrDeclTransformer
from ..passes import DefinitionPass
from ..t import In, Out
from ..tuple import TupleType
from .util import keydefaultdict
from ..wire import wire

logger = logging.getLogger('magma').getChild('coreir_backend')
level = os.getenv("MAGMA_COREIR_BACKEND_LOG_LEVEL", "WARN")
# TODO: Factor this with magma.logging code for debug level validation
if level in ["DEBUG", "WARN", "INFO"]:
    logger.setLevel(getattr(logging, level))
elif level is not None:
    logger.warning("Unsupported value for MAGMA_COREIR_BACKEND_LOG_LEVEL:"
                   f" {level}")


# Singleton context meant to be used with coreir/magma code
@singleton
class CoreIRContextSingleton:
    __instance = None

    def get_instance(self):
        return self.__instance

    def reset_instance(self):
        self.__instance = Context()

    def __init__(self):
        self.__instance = Context()


CoreIRContextSingleton()

_context_to_modules = {}


class CoreIRBackend:
    def __init__(self, context=None, check_context_is_default=True):
        # TODO(rsetaluri): prove this logic.
        singleton = CoreIRContextSingleton().get_instance()
        if context is None:
            context = singleton
        elif check_context_is_default and context != singleton:
            logger.warn("Creating CoreIRBackend with non-singleton CoreIR "
                        "context. If you're sure you want to do this, set "
                        "check_context_is_default when initializing the "
                        "CoreIRBackend.")
        self.modules = _context_to_modules.setdefault(context, {})
        self.context = context
        self.libs = keydefaultdict(self.context.get_lib)
        self.libs_used = set()
        self.constant_cache = {}

    def compile(self, defn_or_decl):
        logger.debug(f"Compiling: {defn_or_decl.name}")
        transformer = DefnOrDeclTransformer(self, defn_or_decl)
        transformer.run()
        self.modules[defn_or_decl.name] = transformer.coreir_module
        return self.modules


class InsertWrapCasts(DefinitionPass):
    def sim(self, value_store, state_store):
        input_val = value_store.get_value(getattr(self, "in"))
        value_store.set_value(self.out, input_val)

    def define_wrap(self, wrap_type, in_type, out_type):
        name = f"coreir_wrap{wrap_type}".replace("(", "").replace(")", "")
        return DeclareCircuit(name,
                              "in",
                              In(in_type),
                              "out",
                              Out(out_type),
                              coreir_genargs={"type": wrap_type},
                              coreir_name="wrap",
                              coreir_lib="coreir",
                              simulate=self.sim)

    def wrap_if_arst(self, port, definition):
        if isinstance(port, (ArrayType, TupleType)):
            for t in port:
                self.wrap_if_arst(t, definition)
        elif port.isinput():
            if isinstance(port, (AsyncResetType, AsyncResetNType)) or \
                    isinstance(port.value(), (AsyncResetType, AsyncResetNType)):
                value = port.value()
                print(port, value)
                if value is not None and not isinstance(
                        type(value), type(type(port))):
                    port.unwire(value)
                    if isinstance(port, (AsyncResetType, AsyncResetNType)):
                        inst = self.define_wrap(
                            type(port).flip(), type(port), type(value))()
                    else:
                        inst = self.define_wrap(
                            type(value).flip(), type(port), type(value))()
                    definition.place(inst)
                    getattr(inst, "in") <= value
                    wire(inst.out, port)

    def __call__(self, definition):
        # copy, because wrapping might add instances
        instances = definition.instances[:]
        for instance in definition.instances:
            if type(instance).coreir_name == "wrap" or \
                    type(instance).coreir_name == "unwrap":
                continue
            for port in instance.interface.ports.values():
                self.wrap_if_arst(port, definition)
        for port in definition.interface.ports.values():
            self.wrap_if_arst(port, definition)


def compile(main, file_name=None, context=None, check_context_is_default=True):
    InsertWrapCasts(main).run()
    backend = CoreIRBackend(context, check_context_is_default)
    backend.compile(main)
    if file_name is not None:
        return backend.modules[main.coreir_name].save_to_file(file_name)
    else:
        return backend.modules[main.coreir_name]
