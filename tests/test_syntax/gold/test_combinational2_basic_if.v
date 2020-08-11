module coreir_mux #(
    parameter width = 1
) (
    input [width-1:0] in0,
    input [width-1:0] in1,
    input sel,
    output [width-1:0] out
);
  assign out = sel ? in1 : in0;
endmodule

module commonlib_muxn__N2__width1 (
    input [0:0] in_data [1:0],
    input [0:0] in_sel,
    output [0:0] out
);
wire [0:0] _join_out;
coreir_mux #(
    .width(1)
) _join (
    .in0(in_data[0]),
    .in1(in_data[1]),
    .sel(in_sel[0]),
    .out(_join_out)
);
assign out = _join_out;
endmodule

module Mux2xOutBit (
    input I0,
    input I1,
    input S,
    output O
);
wire [0:0] coreir_commonlib_mux2x1_inst0_out;
wire [0:0] coreir_commonlib_mux2x1_inst0_in_data [1:0];
assign coreir_commonlib_mux2x1_inst0_in_data[1] = I1;
assign coreir_commonlib_mux2x1_inst0_in_data[0] = I0;
wire [0:0] coreir_commonlib_mux2x1_inst0_in_sel;
assign coreir_commonlib_mux2x1_inst0_in_sel[0] = S;
commonlib_muxn__N2__width1 coreir_commonlib_mux2x1_inst0 (
    .in_data(coreir_commonlib_mux2x1_inst0_in_data),
    .in_sel(coreir_commonlib_mux2x1_inst0_in_sel),
    .out(coreir_commonlib_mux2x1_inst0_out)
);
assign O = coreir_commonlib_mux2x1_inst0_out[0];
endmodule

module basic_if (
    input [1:0] I,
    input S,
    output O
);
wire Mux2xOutBit_inst0_O;
Mux2xOutBit Mux2xOutBit_inst0 (
    .I0(I[1]),
    .I1(I[0]),
    .S(S),
    .O(Mux2xOutBit_inst0_O)
);
assign O = Mux2xOutBit_inst0_O;
endmodule

module Main (
    input [1:0] I,
    input S,
    output O
);
wire basic_if_inst0_O;
basic_if basic_if_inst0 (
    .I(I),
    .S(S),
    .O(basic_if_inst0_O)
);
assign O = basic_if_inst0_O;
endmodule

