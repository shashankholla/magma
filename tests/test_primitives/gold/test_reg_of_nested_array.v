module coreir_reg #(
    parameter width = 1,
    parameter clk_posedge = 1,
    parameter init = 1
) (
    input clk,
    input [width-1:0] in,
    output [width-1:0] out
);
  reg [width-1:0] outReg=init;
  wire real_clk;
  assign real_clk = clk_posedge ? clk : ~clk;
  always @(posedge real_clk) begin
    outReg <= in;
  end
  assign out = outReg;
endmodule

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

module coreir_const #(
    parameter width = 1,
    parameter value = 1
) (
    output [width-1:0] out
);
  assign out = value;
endmodule

module commonlib_muxn__N2__width24 (
    input [23:0] in_data [1:0],
    input [0:0] in_sel,
    output [23:0] out
);
wire [23:0] _join_out;
coreir_mux #(
    .width(24)
) _join (
    .in0(in_data[0]),
    .in1(in_data[1]),
    .sel(in_sel[0]),
    .out(_join_out)
);
assign out = _join_out;
endmodule

module Mux2xArray3_Bits8 (
    input [7:0] I0 [2:0],
    input [7:0] I1 [2:0],
    input S,
    output [7:0] O [2:0]
);
wire [23:0] coreir_commonlib_mux2x24_inst0_out;
wire [23:0] coreir_commonlib_mux2x24_inst0_in_data [1:0];
assign coreir_commonlib_mux2x24_inst0_in_data[1] = {I1[2][7],I1[2][6],I1[2][5],I1[2][4],I1[2][3],I1[2][2],I1[2][1],I1[2][0],I1[1][7],I1[1][6],I1[1][5],I1[1][4],I1[1][3],I1[1][2],I1[1][1],I1[1][0],I1[0][7],I1[0][6],I1[0][5],I1[0][4],I1[0][3],I1[0][2],I1[0][1],I1[0][0]};
assign coreir_commonlib_mux2x24_inst0_in_data[0] = {I0[2][7],I0[2][6],I0[2][5],I0[2][4],I0[2][3],I0[2][2],I0[2][1],I0[2][0],I0[1][7],I0[1][6],I0[1][5],I0[1][4],I0[1][3],I0[1][2],I0[1][1],I0[1][0],I0[0][7],I0[0][6],I0[0][5],I0[0][4],I0[0][3],I0[0][2],I0[0][1],I0[0][0]};
commonlib_muxn__N2__width24 coreir_commonlib_mux2x24_inst0 (
    .in_data(coreir_commonlib_mux2x24_inst0_in_data),
    .in_sel(S),
    .out(coreir_commonlib_mux2x24_inst0_out)
);
assign O[2] = {coreir_commonlib_mux2x24_inst0_out[23],coreir_commonlib_mux2x24_inst0_out[22],coreir_commonlib_mux2x24_inst0_out[21],coreir_commonlib_mux2x24_inst0_out[20],coreir_commonlib_mux2x24_inst0_out[19],coreir_commonlib_mux2x24_inst0_out[18],coreir_commonlib_mux2x24_inst0_out[17],coreir_commonlib_mux2x24_inst0_out[16]};
assign O[1] = {coreir_commonlib_mux2x24_inst0_out[15],coreir_commonlib_mux2x24_inst0_out[14],coreir_commonlib_mux2x24_inst0_out[13],coreir_commonlib_mux2x24_inst0_out[12],coreir_commonlib_mux2x24_inst0_out[11],coreir_commonlib_mux2x24_inst0_out[10],coreir_commonlib_mux2x24_inst0_out[9],coreir_commonlib_mux2x24_inst0_out[8]};
assign O[0] = {coreir_commonlib_mux2x24_inst0_out[7],coreir_commonlib_mux2x24_inst0_out[6],coreir_commonlib_mux2x24_inst0_out[5],coreir_commonlib_mux2x24_inst0_out[4],coreir_commonlib_mux2x24_inst0_out[3],coreir_commonlib_mux2x24_inst0_out[2],coreir_commonlib_mux2x24_inst0_out[1],coreir_commonlib_mux2x24_inst0_out[0]};
endmodule

module Register (
    input [7:0] I [2:0],
    output [7:0] O [2:0],
    input CLK,
    input RESET
);
wire [7:0] Mux2xArray3_Bits8_inst0_O [2:0];
wire [7:0] const_173_8_out;
wire [7:0] const_190_8_out;
wire [7:0] const_222_8_out;
wire [23:0] reg_P24_inst0_out;
wire [7:0] Mux2xArray3_Bits8_inst0_I0 [2:0];
assign Mux2xArray3_Bits8_inst0_I0[2] = I[2];
assign Mux2xArray3_Bits8_inst0_I0[1] = I[1];
assign Mux2xArray3_Bits8_inst0_I0[0] = I[0];
wire [7:0] Mux2xArray3_Bits8_inst0_I1 [2:0];
assign Mux2xArray3_Bits8_inst0_I1[2] = const_190_8_out;
assign Mux2xArray3_Bits8_inst0_I1[1] = const_173_8_out;
assign Mux2xArray3_Bits8_inst0_I1[0] = const_222_8_out;
Mux2xArray3_Bits8 Mux2xArray3_Bits8_inst0 (
    .I0(Mux2xArray3_Bits8_inst0_I0),
    .I1(Mux2xArray3_Bits8_inst0_I1),
    .S(RESET),
    .O(Mux2xArray3_Bits8_inst0_O)
);
coreir_const #(
    .value(8'had),
    .width(8)
) const_173_8 (
    .out(const_173_8_out)
);
coreir_const #(
    .value(8'hbe),
    .width(8)
) const_190_8 (
    .out(const_190_8_out)
);
coreir_const #(
    .value(8'hde),
    .width(8)
) const_222_8 (
    .out(const_222_8_out)
);
wire [23:0] reg_P24_inst0_in;
assign reg_P24_inst0_in = {Mux2xArray3_Bits8_inst0_O[2][7],Mux2xArray3_Bits8_inst0_O[2][6],Mux2xArray3_Bits8_inst0_O[2][5],Mux2xArray3_Bits8_inst0_O[2][4],Mux2xArray3_Bits8_inst0_O[2][3],Mux2xArray3_Bits8_inst0_O[2][2],Mux2xArray3_Bits8_inst0_O[2][1],Mux2xArray3_Bits8_inst0_O[2][0],Mux2xArray3_Bits8_inst0_O[1][7],Mux2xArray3_Bits8_inst0_O[1][6],Mux2xArray3_Bits8_inst0_O[1][5],Mux2xArray3_Bits8_inst0_O[1][4],Mux2xArray3_Bits8_inst0_O[1][3],Mux2xArray3_Bits8_inst0_O[1][2],Mux2xArray3_Bits8_inst0_O[1][1],Mux2xArray3_Bits8_inst0_O[1][0],Mux2xArray3_Bits8_inst0_O[0][7],Mux2xArray3_Bits8_inst0_O[0][6],Mux2xArray3_Bits8_inst0_O[0][5],Mux2xArray3_Bits8_inst0_O[0][4],Mux2xArray3_Bits8_inst0_O[0][3],Mux2xArray3_Bits8_inst0_O[0][2],Mux2xArray3_Bits8_inst0_O[0][1],Mux2xArray3_Bits8_inst0_O[0][0]};
coreir_reg #(
    .clk_posedge(1'b1),
    .init(24'hbeadde),
    .width(24)
) reg_P24_inst0 (
    .clk(CLK),
    .in(reg_P24_inst0_in),
    .out(reg_P24_inst0_out)
);
assign O[2] = {reg_P24_inst0_out[23],reg_P24_inst0_out[22],reg_P24_inst0_out[21],reg_P24_inst0_out[20],reg_P24_inst0_out[19],reg_P24_inst0_out[18],reg_P24_inst0_out[17],reg_P24_inst0_out[16]};
assign O[1] = {reg_P24_inst0_out[15],reg_P24_inst0_out[14],reg_P24_inst0_out[13],reg_P24_inst0_out[12],reg_P24_inst0_out[11],reg_P24_inst0_out[10],reg_P24_inst0_out[9],reg_P24_inst0_out[8]};
assign O[0] = {reg_P24_inst0_out[7],reg_P24_inst0_out[6],reg_P24_inst0_out[5],reg_P24_inst0_out[4],reg_P24_inst0_out[3],reg_P24_inst0_out[2],reg_P24_inst0_out[1],reg_P24_inst0_out[0]};
endmodule

module test_reg_of_nested_array (
    input [7:0] I [2:0],
    output [7:0] O [2:0],
    input CLK,
    input RESET
);
wire [7:0] Register_inst0_O [2:0];
wire [7:0] Register_inst0_I [2:0];
assign Register_inst0_I[2] = I[2];
assign Register_inst0_I[1] = I[1];
assign Register_inst0_I[0] = I[0];
Register Register_inst0 (
    .I(Register_inst0_I),
    .O(Register_inst0_O),
    .CLK(CLK),
    .RESET(RESET)
);
assign O[2] = Register_inst0_O[2];
assign O[1] = Register_inst0_O[1];
assign O[0] = Register_inst0_O[0];
endmodule

