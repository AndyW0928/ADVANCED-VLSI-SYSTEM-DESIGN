module ADD (add_a, add_b, add_out);

input  [31:0] add_a , add_b;
output [31:0] add_out;

assign add_out = add_a + add_b;

endmodule
