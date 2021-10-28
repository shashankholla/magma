module mantle_slicesArrT__slices4220__tBitIn4 (
    input [3:0] in,
    output [1:0] out0,
    output [1:0] out1
);
assign out0 = {in[3],in[2]};
assign out1 = {in[1],in[0]};
endmodule

module mantle_concatNArrT__Ns22__t_childBitIn (
    input [1:0] in0,
    input [1:0] in1,
    output [3:0] out
);
assign out = {in1[1],in1[0],in0[1],in0[0]};
endmodule

module Foo (
    input [3:0] I,
    output [3:0] O
);
wire [3:0] ConcatN_inst0_out;
wire [1:0] SlicesBuilder_out0;
wire [1:0] SlicesBuilder_out1;
mantle_concatNArrT__Ns22__t_childBitIn ConcatN_inst0 (
    .in0(SlicesBuilder_out0),
    .in1(SlicesBuilder_out1),
    .out(ConcatN_inst0_out)
);
mantle_slicesArrT__slices4220__tBitIn4 SlicesBuilder (
    .in(I),
    .out0(SlicesBuilder_out0),
    .out1(SlicesBuilder_out1)
);
assign O = ConcatN_inst0_out;
endmodule

