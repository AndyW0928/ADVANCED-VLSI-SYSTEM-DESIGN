//calculate CSR inst

module CSR_STRET(clk, rst, ID_flush, EXE_flush, ID_stall, CSR_src, CSR_ins);
    
input clk;
input rst;
input ID_flush;
input EXE_flush;
input ID_stall;
input [1:0] CSR_src;

output logic [31:0] CSR_ins;


logic [63:0] CSR_reg;
logic rst_count;  

always_ff @(posedge clk or posedge rst) 
begin
    if (rst) begin 
        CSR_reg <= 64'b0;
        rst_count <= 1'b0;  
    end
    else if (!rst_count) begin
        rst_count <= 1'b1;  
    end
    else if (ID_flush | EXE_flush | ID_stall) begin 
        CSR_reg <= CSR_reg;  
    end    
    else begin
        CSR_reg <= CSR_reg + 64'd1;
    end
end

always_comb 
begin
    case(CSR_src)
        2'b01: CSR_ins = CSR_reg[31:0];  // RDSTRET
        2'b11: CSR_ins = CSR_reg[63:32]; // RDSTRETH
        default: CSR_ins = 32'b0;
    endcase
end

endmodule