module Foo (
    input [3:0] I,
    output [3:0] O
);
assign O = {I[3],I[2],I[1],I[2]};
endmodule

