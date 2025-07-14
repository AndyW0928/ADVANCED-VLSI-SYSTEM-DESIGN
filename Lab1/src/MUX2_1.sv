module MUX2_1(mux_a, mux_b, mux_out, sel);

input  [31:0] mux_a, mux_b;
input  sel;
output [31:0] mux_out;

assign mux_out = (sel)? mux_a : mux_b;

endmodule
