
//Hazard unit

module HU(rs1_E, rs2_E, frs1_E, frs2_E, rd_M, frd_M, rd_W, frd_W, RF_write_M, FPRF_write_M, RF_write_W, FPRF_write_W, MEM_write_E, IMM_Src, rs1_D, rs2_D, frs1_D, frs2_D, rd_E, MEM_read_E, frd_E,        
IF_stall, ID_stall, forwardA, forwardB, forwardC, FP_forwardA, FP_forwardB, FP_forwardC);

input logic  [4:0] rs1_E;
input logic  [4:0] rs2_E;
input logic  [4:0] frs1_E; 
input logic  [4:0] frs2_E; 
input logic  [4:0] rd_M; 
input logic  [4:0] frd_M; 
input logic  [4:0] rd_W;
input logic  [4:0] frd_W; 
input logic        RF_write_M;
input logic        FPRF_write_M; 
input logic        RF_write_W;
input logic        FPRF_write_W; 
input logic        MEM_write_E;
input logic        IMM_Src;
input logic [4:0]  rs1_D;           
input logic [4:0]  rs2_D;           
input logic [4:0]  frs1_D;      
input logic [4:0]  frs2_D;      
input logic [4:0]  rd_E;     
input logic        MEM_read_E;        
input logic [4:0]  frd_E;        
output logic IF_stall;
output logic ID_stall;
output logic [1:0] forwardA;
output logic [1:0] forwardB;
output logic [1:0] forwardC;
output logic [1:0] FP_forwardA;
output logic [1:0] FP_forwardB;
output logic [1:0] FP_forwardC;


always_comb 
begin 
    if ((MEM_read_E == 1'b1) && ((rs1_D == rd_E) || (rs2_D == rd_E))) begin
        IF_stall      = 1'b1; 
        ID_stall      = 1'b1;
    end
    else if ((MEM_read_E == 1'b1) && ((frs1_D == frd_E) || (frs2_D == frd_E))) begin
        IF_stall      = 1'b1; 
        ID_stall      = 1'b1; 
    end
    else begin    
        IF_stall      = 1'b0; 
        ID_stall      = 1'b0; 
    end
end    

//***********************//
always_comb 
begin
    if (RF_write_M && (rd_M != 5'd0) && (rd_M == rs1_E))
        forwardA = 2'b01; // MEM back
    else if (RF_write_W && (rd_W != 5'd0) && (rd_W == rs1_E))
        forwardA = 2'b10; // WB 
    else 
        forwardA = 2'b00;
end


always_comb 
begin
    if (RF_write_M && (rd_M != 5'd0) && (rd_M == rs2_E) && !MEM_write_E && !IMM_Src)
        forwardB = 2'b01; // MEM BACK
    else if (RF_write_W && (rd_W != 5'd0) && (rd_W == rs2_E) && !MEM_write_E && !IMM_Src)
        forwardB = 2'b10; // WB 
    else 
        forwardB = 2'b00;
end    

always_comb 
begin
    if (MEM_write_E && RF_write_M && (rd_M != 5'd0) && (rd_M == rs2_E))
        forwardC = 2'b01; 
    else if (MEM_write_E && RF_write_W && (rd_W != 5'd0) && (rd_W == rs2_E))    
        forwardC = 2'b10; 
    else   
        forwardC = 2'b00;
end

always_comb 
begin
    if (FPRF_write_M && (frd_M != 5'd0) && (frd_M == frs1_E))
        FP_forwardA = 2'b01; 
    else if (FPRF_write_W && (frd_W != 5'd0) && (frd_W == frs1_E))
        FP_forwardA = 2'b10; 
    else 
        FP_forwardA = 2'b00;
end

always_comb 
begin
    if (FPRF_write_M && (frd_M != 5'd0) && (frd_M == frs2_E) && !MEM_write_E && !IMM_Src)
        FP_forwardB = 2'b01; 
    else if (FPRF_write_W && (frd_W != 5'd0) && (frd_W == frs2_E) && !MEM_write_E && !IMM_Src)
        FP_forwardB = 2'b10; 
    else 
        FP_forwardB = 2'b00;
end

always_comb 
begin
    if (MEM_write_E && FPRF_write_M && (frd_M != 5'd0) && (frd_M == frs2_E))
        FP_forwardC = 2'b01; // MEM 
    else if (MEM_write_E && FPRF_write_W && (frd_W != 5'd0) && (frd_W == frs2_E))    
        FP_forwardC = 2'b10; // WB 
    else   
        FP_forwardC = 2'b00;
end

endmodule
