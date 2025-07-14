`include "MUX3_1.sv"
`include "MUX2_1.sv"
`include "ALU.sv"
`include "FP_ALU.sv"


module EXE_CYCLE(clk, rst, ALU_op_E, ALU_en_E, FPU_en_E, IMM_Src_E, B_Src_E, J_Src_E, RF_write_E, FPRF_write_E, MEM_data_Src_E, WB_Src_E, MEM_read_E, MEM_read_Src_E, MEM_write_E, MEM_write_Src_E, PC_contr_E, CSR_Src_E, F_Src_E,
pc_E, pc_plus_E, rs1_E, rs2_E, frs1_E, frs2_E, rs1_data_E, rs2_data_E, frs1_data_E, frs2_data_E, imm_ext_E, CSR_ins_E, rd_E, frd_E, WB_data,
forwardA, forwardB, forwardC, FP_forwardA, FP_forwardB, FP_forwardC, MEM_back, AXI_stall,
pc_JALR_E, pc_BRA_E, pc_JALR_M, pc_BRA_M, IF_flush, ID_flush, EXE_flush, RF_write_M, FPRF_write_M, MEM_data_Src_M, WB_Src_M, MEM_read_M, MEM_read_Src_M, MEM_write_M, MEM_write_Src_M, CSR_Src_M,
pc_M, pc_plus_M, rs1_M, rs2_M, frs1_M, frs2_M, rs1_data_M, rs2_data_M, frs1_data_M, frs2_data_M, imm_ext_M, CSR_ins_M, rd_M, frd_M, ALU_result_M, FPU_result_M, sdata_M, FP_sdata_M
);

input logic clk, rst;
input logic [4:0] ALU_op_E;
input logic ALU_en_E;
input logic FPU_en_E;
input logic IMM_Src_E;
input logic B_Src_E;
input logic J_Src_E;
input logic RF_write_E;
input logic FPRF_write_E;
input logic [2:0] MEM_data_Src_E;
input logic [2:0] WB_Src_E;
input logic MEM_read_E;
input logic [2:0] MEM_read_Src_E;
input logic MEM_write_E;
input logic [2:0] MEM_write_Src_E;
input logic [1:0] PC_contr_E;
input logic [1:0] CSR_Src_E;
input logic F_Src_E;
input logic [31:0] WB_data;

//
input logic [31:0] pc_E, pc_plus_E;
input logic [4:0] rs1_E, rs2_E, frs1_E, frs2_E;
input logic [31:0] rs1_data_E, rs2_data_E, frs1_data_E, frs2_data_E; 
input logic [31:0] imm_ext_E, CSR_ins_E;
input logic [4:0] rd_E, frd_E;    

input logic [1:0] forwardA, forwardB, forwardC;
input logic [1:0] FP_forwardA, FP_forwardB, FP_forwardC;
input logic [31:0] MEM_back;
input logic AXI_stall;
input logic [31:0] pc_BRA_E;  //, pc_JALR_E;

output logic [31:0] pc_JALR_E;      //, pc_BRA_E;
output logic [31:0] pc_JALR_M, pc_BRA_M;
output logic IF_flush, ID_flush, EXE_flush;
output logic RF_write_M;
output logic FPRF_write_M;
output logic [2:0] MEM_data_Src_M;
output logic [2:0] WB_Src_M;
output logic MEM_read_M;
output logic [2:0] MEM_read_Src_M;
output logic MEM_write_M;
output logic [2:0] MEM_write_Src_M;
output logic [1:0] CSR_Src_M;
output logic [31:0] pc_M, pc_plus_M;
output logic [4:0] rs1_M, rs2_M, frs1_M, frs2_M;
output logic [31:0] rs1_data_M, rs2_data_M, frs1_data_M, frs2_data_M; 
output logic [31:0] imm_ext_M, CSR_ins_M;
output logic [4:0] rd_M, frd_M;    
output logic [31:0] ALU_result_M, FPU_result_M;
output logic [31:0] sdata_M, FP_sdata_M;


//******************************************//
//ALU data select
logic [31:0] in_A, in_B, data_B;

//in_A mux
MUX3_1 forwardA_MUX(
.mux_a(rs1_data_E), 
.mux_b(MEM_back), 
.mux_c(WB_data),
.mux_out(in_A), 
.sel(forwardA)
);

//imm rs2 mux
MUX2_1 imm_MUX(
.mux_a(imm_ext_E), 
.mux_b(rs2_data_E), 
.mux_out(data_B), 
.sel(IMM_Src_E)
);

//in_2 mux
MUX3_1 forwardB_MUX(
.mux_a(data_B), 
.mux_b(MEM_back), 
.mux_c(WB_data),
.mux_out(in_B), 
.sel(forwardB)
);
//*****************************************//
logic ZERO;
logic [31:0] ALU_result_E;
//ALU
ALU ALU(
.in_A(in_A), 
.in_B(in_B), 
.ALU_op(ALU_op_E),
.ALU_en(ALU_en_E), 
.ZERO(ZERO), 
.ALU_result(ALU_result_E)
);

//***********************************//
//FPU data choose
logic [31:0] FP_in_A, FP_in_B, FP_data_B;

MUX3_1 FP_forwardA_MUX(
.mux_a(frs1_data_E), 
.mux_b(MEM_back), 
.mux_c(WB_data),
.mux_out(FP_in_A), 
.sel(FP_forwardA)
);

MUX2_1 FP_imm_MUX(
.mux_a(imm_ext_E), 
.mux_b(frs2_data_E), 
.mux_out(FP_data_B), 
.sel(IMM_Src_E)
);

MUX3_1 FP_forwardB_MUX(
.mux_a(FP_data_B), 
.mux_b(MEM_back), 
.mux_c(WB_data),
.mux_out(FP_in_B), 
.sel(FP_forwardB)
);
//*******************************************//
logic [31:0] FPU_result_E;
//FPU
FP_ALU FP_ALU(
.FP_inA(FP_in_A),
.FP_inB(FP_in_B),
.FPU_en(FPU_en_E),  
.FPU_op(ALU_op_E[1:0]),       // 00: add, 01: sub
.FPU_result(FPU_result_E)
);

//*******************************************//
//pc_BRA / pc_JALR
assign pc_JALR_E = in_A + in_B;
//assign pc_BRA_E  = pc_E + imm_ext_E;

//logic flush;

always_comb
begin
    if ((ZERO & B_Src_E) | J_Src_E)
    //if (PC_contr_E != 2'b00)
    begin
    IF_flush = 1'b1;
    ID_flush = 1'b1;
    end
    else begin
    IF_flush = 1'b0;
    ID_flush = 1'b0;
    end   
end
/*
always_ff @(posedge clk or posedge rst)
begin
    if(rst)begin
       IF_flush <= 1'b0;
       ID_flush <= 1'b0; 
    end
    else if(AXI_stall)begin
       IF_flush <= IF_flush;
       ID_flush <= ID_flush;
    end
    else begin
       IF_flush <= flush;
       ID_flush <= flush;
    end
end        
*/


//**********************************************//
logic [31:0] sdata_E, FP_sdata_E;

//MEM sdata forward
MUX3_1 forwardC_MUX(
.mux_a(rs2_data_E), 
.mux_b(MEM_back), 
.mux_c(WB_data),
.mux_out(sdata_E), 
.sel(forwardC)
);

//MEM FP_sdata forward
MUX3_1 FP_forwardC_MUX(
.mux_a(frs2_data_E), 
.mux_b(MEM_back), 
.mux_c(WB_data),
.mux_out(FP_sdata_E), 
.sel(FP_forwardC)
);
//**********************************************//
//EXEMEM reg

always_ff@(posedge clk or posedge rst) begin
	if(rst) begin   
        RF_write_M <= 1'b0;
        FPRF_write_M <= 1'b0;
        MEM_data_Src_M <= 3'b0;
        WB_Src_M <= 3'b0; 
        MEM_read_M <= 1'b0;
        MEM_read_Src_M <= 3'b0;
        MEM_write_M <= 1'b0;
        MEM_write_Src_M <= 3'b0;
        CSR_Src_M   <= 2'b0;
        pc_M    <= 32'b0;
        pc_plus_M   <= 32'b0;
        rs1_M   <= 5'b0;
        rs2_M   <= 5'b0;
        frs1_M  <= 5'b0;
        frs2_M  <= 5'b0;
        rs1_data_M <= 32'b0;
        rs2_data_M <= 32'b0;
        frs1_data_M <= 32'b0;
        frs2_data_M <= 32'b0; 
        imm_ext_M <= 32'b0;
        CSR_ins_M <= 32'b0;
        rd_M <= 5'b0;
        frd_M <= 5'b0;
        pc_BRA_M <= 32'b0;
        EXE_flush <= 1'b0;
        ALU_result_M <= 32'b0;
        FPU_result_M <= 32'b0;
        sdata_M <= 32'b0;
        FP_sdata_M <= 32'b0; 
	end
	else if (!AXI_stall) begin
	     RF_write_M <= RF_write_E;
        FPRF_write_M <= FPRF_write_E;
        MEM_data_Src_M <= MEM_data_Src_E;
        WB_Src_M <= WB_Src_E; 
        MEM_read_M <= MEM_read_E;
        MEM_read_Src_M <= MEM_read_Src_E;
        MEM_write_M <= MEM_write_E;
        MEM_write_Src_M <= MEM_write_Src_E;
        CSR_Src_M   <= CSR_Src_E;
        pc_M    <= pc_E;
        pc_plus_M   <= pc_plus_E;
        rs1_M   <=  rs1_E;
        rs2_M   <=  rs2_E;
        frs1_M  <=  frs1_E;
        frs2_M  <=  frs2_E;
        rs1_data_M <= rs1_data_E;
        rs2_data_M <= rs2_data_E;
        frs1_data_M <= frs1_data_E;
        frs2_data_M <= frs2_data_E; 
        imm_ext_M <= imm_ext_E;
        CSR_ins_M <= CSR_ins_E;
        rd_M <= rd_E;
        frd_M <= frd_E;
        pc_BRA_M <= pc_BRA_E;
        EXE_flush <= ID_flush;
        ALU_result_M <= ALU_result_E;
        FPU_result_M <= FPU_result_E;
        sdata_M <= sdata_E;
        FP_sdata_M <= FP_sdata_E; 
	end
end


endmodule
