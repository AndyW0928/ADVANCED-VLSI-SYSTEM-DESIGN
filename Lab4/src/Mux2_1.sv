module Mux2_1 #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] a,    
    input  [WIDTH-1:0] b,    
    input              en,  
    output reg [WIDTH-1:0] out  
);

    always_comb begin : Mux2to1
        case(en)
            1'b1:    out = a;    
            default: out = b;    
        endcase
    end

endmodule
