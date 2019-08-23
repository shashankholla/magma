module execute_alu
(
  output [16-1:0] O,
  input [16-1:0] a,
  input [16-1:0] b,
  input [2-1:0] config_
);

  reg [16-1:0] c;

  always @(*) begin
    if(config_ == 0) begin
      c = a + b;
    end else if(config_ == 1) begin
      c = a - b;
    end else if(config_ == 2) begin
      c = a * b;
    end else begin
      c = 0;
    end
    O = c;
  end


endmodule
module SimpleALU (input [15:0] a, input [15:0] b, output [15:0] c, input [1:0] config_);
wire [15:0] execute_alu_inst0_O;
execute_alu execute_alu_inst0(.O(execute_alu_inst0_O), .a(a), .b(b), .config_(config_));
assign c = execute_alu_inst0_O;
endmodule

