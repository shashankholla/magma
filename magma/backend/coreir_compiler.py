import os
import subprocess
from .coreir_ import InsertWrapCasts
from ..compiler import Compiler
from ..frontend import coreir_ as coreir_frontend
from ..passes import InstanceGraphPass
from ..passes.insert_coreir_wires import InsertCoreIRWires
from ..logging import root_logger


_logger = root_logger()


class CoreIRCompiler(Compiler):
    def __init__(self, main, basename, opts):
        super().__init__(main, basename, opts)
        self.namespaces = self.opts.get("namespaces", ["global"])
        self.passes = opts.get("passes", [])
        if "markdirty" not in self.passes:
            self.passes.append("markdirty")
        self.deps = self._deps()
        self.backend = coreir_frontend.GetCoreIRBackend()

    def compile(self):
        InsertCoreIRWires(self.main).run()
        InsertWrapCasts(self.main).run()
        backend = self.backend
        backend.compile(self.main)
        backend.context.run_passes(self.passes, self.namespaces)
        output_json = (self.opts.get("output_intermediate", False) or
                       not self.opts.get("output_verilog", False))
        if output_json:
            filename = f"{self.basename}.json"
            backend.modules[self.main.coreir_name].save_to_file(filename)
        if self.opts.get("output_verilog", False):
            self._compile_verilog()
            return
        has_header_or_footer = (self.opts.get("header_file", "") or
                                self.opts.get("header_str", "") or
                                self.opts.get("footer_str", ""))
        if has_header_or_footer:
            _logger.warning("[coreir-compiler] header/footer only supported "
                            "when output_verilog=True, ignoring")

    def _compile_verilog(self):
        top = self.backend.modules[self.main.coreir_name]
        filename = f"{self.basename}.v"
        opts = dict(
            libs=self.deps,
            split=self.opts.get("split", ""),
            inline=self.opts.get("inline", False),
            verilator_debug=self.opts.get("verilator_debug", False),
        )
        ret = self.backend.context.compile_to_verilog(top, filename, **opts)
        if not ret:
            raise RuntimeError(f"CoreIR compilation to verilog failed")
        self._process_header_footer()

        # TODO(leonardt): We need fresh bind_files for each compile call.
        for name, file in self.backend.sv_bind_files.items():
            filename = os.path.join(os.path.dirname(self.basename), name)
            with open(f"{filename}.sv", "w") as f:
                f.write(file)

        if self.opts.get("sv", False):
            if self.opts.get("split", False):
                _logger.warning("sv not supported with split, ignoring")
            else:
                args = (f"{self.basename}.v", f"{self.basename}.sv")
                subprocess.run(["mv", *args])

    def _deps(self):
        deps = self.opts.get("coreir_libs", set())
        pass_ = InstanceGraphPass(self.main)
        pass_.run()
        for key, _ in pass_.tsortedgraph:
            if key.coreir_lib:
                deps.add(key.coreir_lib)
            elif hasattr(key, "wrappedModule"):
                deps |= key.coreir_wrapped_modules_libs_used
        deps |= set(self.namespaces)
        return deps

    def _process_header_footer(self):
        header = ""
        if self.opts.get("header_file", ""):
            with open(self.opts["header_file"], "r") as header_file:
                header = header_file.read() + "\n"
        if self.opts.get("header_str", ""):
            header += self.opts["header_str"] + "\n"
        footer = self.opts.get("footer_str", "")
        if not header and not footer:
            return
        if self.opts.get("split", ""):
            _logger.warning("header/footer not supported with split, ignoring")
            return
        with open(f"{self.basename}.v", "r") as verilog_file:
            verilog = verilog_file.read()
        with open(f"{self.basename}.v", "w") as verilog_file:
            verilog_file.write(header + verilog + "\n" + footer)
