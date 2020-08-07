// Module `_Decl` defined externally
module my_namespace_Bar (
    input I_x,
    input I_y,
    output O_x,
    output O_y
);
wire _Decl_inst0_I_x;
wire _Decl_inst0_I_y;
wire _Decl_inst0_O_x;
wire _Decl_inst0_O_y;
assign _Decl_inst0_I_x = I_x;
assign _Decl_inst0_I_y = I_y;
my_namespace__Decl _Decl_inst0 (
    .I_x(_Decl_inst0_I_x),
    .I_y(_Decl_inst0_I_y),
    .O_x(_Decl_inst0_O_x),
    .O_y(_Decl_inst0_O_y)
);
assign O_x = _Decl_inst0_O_x;
assign O_y = _Decl_inst0_O_y;
endmodule

module my_namespace_Foo (
    input I_x,
    input I_y,
    output O_x,
    output O_y
);
wire Bar_inst0_I_x;
wire Bar_inst0_I_y;
wire Bar_inst0_O_x;
wire Bar_inst0_O_y;
assign Bar_inst0_I_x = I_x;
assign Bar_inst0_I_y = I_y;
my_namespace_Bar Bar_inst0 (
    .I_x(Bar_inst0_I_x),
    .I_y(Bar_inst0_I_y),
    .O_x(Bar_inst0_O_x),
    .O_y(Bar_inst0_O_y)
);
assign O_x = Bar_inst0_O_x;
assign O_y = Bar_inst0_O_y;
endmodule

