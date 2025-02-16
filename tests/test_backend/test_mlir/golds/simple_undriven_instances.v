// Generated by CIRCT circtorg-0.0.0-658-g0d82b4bb2
module simple_comb(	// <stdin>:1:1
  input  [15:0] a,
                b,
                c,
  output [15:0] y,
                z);

  assign y = 16'hFFFF;	// <stdin>:2:10, :6:5
  assign z = 16'hFFFF;	// <stdin>:2:10, :6:5
endmodule

module simple_undriven_instances();	// <stdin>:8:1
  wire [15:0] _simple_comb_inst1_y;	// <stdin>:22:16
  wire [15:0] _simple_comb_inst1_z;	// <stdin>:22:16
  wire [15:0] _simple_comb_inst0_y;	// <stdin>:15:14
  wire [15:0] _simple_comb_inst0_z;	// <stdin>:15:14
  wire [15:0] _GEN;	// <stdin>:9:10
  wire [15:0] _GEN_0;	// <stdin>:11:10
  wire [15:0] _GEN_1;	// <stdin>:13:10
  wire [15:0] _GEN_2;	// <stdin>:16:10
  wire [15:0] _GEN_3;	// <stdin>:18:11
  wire [15:0] _GEN_4;	// <stdin>:20:11
  simple_comb simple_comb_inst0 (	// <stdin>:15:14
    .a (_GEN),	// <stdin>:10:10
    .b (_GEN_0),	// <stdin>:12:10
    .c (_GEN_1),	// <stdin>:14:10
    .y (_simple_comb_inst0_y),
    .z (_simple_comb_inst0_z)
  );
  simple_comb simple_comb_inst1 (	// <stdin>:22:16
    .a (_GEN_2),	// <stdin>:17:10
    .b (_GEN_3),	// <stdin>:19:11
    .c (_GEN_4),	// <stdin>:21:11
    .y (_simple_comb_inst1_y),
    .z (_simple_comb_inst1_z)
  );
endmodule

