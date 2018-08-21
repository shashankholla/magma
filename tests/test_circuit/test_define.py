import os
import magma as m
from magma.testing import check_files_equal


def test_simple_def():
    os.environ["MAGMA_CODEGEN_DEBUG_INFO"] = "1"
    And2 = m.DeclareCircuit('And2', "I0", m.In(m.Bit), "I1", m.In(m.Bit),
                            "O", m.Out(m.Bit))

    main = m.DefineCircuit("main", "I", m.In(m.Bits(2)), "O", m.Out(m.Bit))

    and2 = And2()

    m.wire(main.I[0], and2.I0)
    m.wire(main.I[1], and2.I1)
    m.wire(and2.O, main.O)

    m.EndCircuit()

    m.compile("build/test_simple_def", main)
    del os.environ["MAGMA_CODEGEN_DEBUG_INFO"]
    assert check_files_equal(__file__, f"build/test_simple_def.v",
                             f"gold/test_simple_def.v")


def test_unwired_ports_warnings(caplog):
    And2 = m.DeclareCircuit('And2', "I0", m.In(m.Bit), "I1", m.In(m.Bit),
                            "O", m.Out(m.Bit))

    main = m.DefineCircuit("main", "I", m.In(m.Bits(2)), "O", m.Out(m.Bit))

    and2 = And2()

    m.wire(main.I[1], and2.I1)

    m.EndCircuit()

    m.compile("build/test_unwired_output", main)
    assert check_files_equal(__file__, f"build/test_unwired_output.v",
                             f"gold/test_unwired_output.v")
    assert caplog.records[0].msg == "main.And2_inst0.I0 not connected"
    assert caplog.records[1].msg == "main.O is unwired"
