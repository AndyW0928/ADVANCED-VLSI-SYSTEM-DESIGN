module MUX3_1(mux_a, mux_b, mux_c ,mux_out, sel);
input logic [31:0] mux_a, mux_b, mux_c;
input logic [1:0] sel;
output logic [31:0] mux_out;

always_comb
case (sel)
2'b00: mux_out = mux_a;
2'b01: mux_out = mux_b;
2'b10: mux_out = mux_c;
default : mux_out = 32'b0;
endcase
       
endmodule      
