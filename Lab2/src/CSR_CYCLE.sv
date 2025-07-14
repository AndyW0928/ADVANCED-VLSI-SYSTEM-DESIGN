

module CSR_CYCLE(clk, rst, CSR_type, CSR_cyc);

input logic clk, rst;
input logic [1:0] CSR_type;
output logic [31:0] CSR_cyc;

logic [63:0] cycle;

    
always_ff @(posedge clk or posedge rst)
begin
    if (rst) begin
    cycle <= 64'b0;
    end
    else begin
    cycle <= cycle + 64'd1;
    end
end

always_comb 
begin
    case(CSR_type)
        2'b00: CSR_cyc = cycle[31:0];  // RDCYCLE
        2'b10: CSR_cyc = cycle[63:32]; // RDCYCLEH
        default: CSR_cyc = 32'b0;
    endcase
end
         
endmodule

