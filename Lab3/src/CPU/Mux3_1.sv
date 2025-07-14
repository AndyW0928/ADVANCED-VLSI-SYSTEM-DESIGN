module Mux3_1(
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,
    input  [1:0]  en,
    output reg [31:0] out  
);

    always_comb begin : Mux3to1
        case(en)
            2'b00: out = a;    // Select a when en is 00
            2'b01: out = b;    // Select b when en is 01
            2'b10: out = c;    // Select c when en is 10
            default: out = a;  // Default to selecting a
        endcase
    end

endmodule
