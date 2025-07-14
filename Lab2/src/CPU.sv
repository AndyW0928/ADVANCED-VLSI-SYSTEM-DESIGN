`include "IF_CYCLE.sv"
`include "ID_CYCLE.sv"
`include "EXE_CYCLE.sv"
`include "MEM_CYCLE.sv"
`include "WB_CYCLE.sv"
`include "HU.sv"

module CPU(clk, rst, IM_DO, DM_DO, IM_CEB, DM_CEB, IM_WEB, DM_WEB, IM_BWEB, DM_BWEB, IM_A, DM_A, IM_DI, DM_DI, 
w_en, r_en_IM, r_en_DM, stall_MW, stall_MR0, stall_MR1, rvalid_out1/*, ARVALID_M0, */);
    
input logic clk, rst;

input logic [31:0] IM_DO, DM_DO;
output logic IM_CEB, DM_CEB;
output logic IM_WEB, DM_WEB;
output logic [31:0] IM_BWEB, DM_BWEB;
output logic [31:0] IM_A, DM_A;
output logic [31:0] IM_DI, DM_DI;

output logic w_en;
output logic r_en_IM;
output logic r_en_DM;

input logic  stall_MW, stall_MR0, stall_MR1;
logic AXI_stall;  //*****************************//
input logic rvalid_out1;

//AXI
//input logic ARVALID_M0, ARREADY_M0;

assign AXI_stall = (stall_MR0 & stall_MW);

 logic IF_stall;
 logic ID_stall;
 logic [1:0] forwardA;
 logic [1:0] forwardB;
 logic [1:0] forwardC;
 logic [1:0] FP_forwardA;
 logic [1:0] FP_forwardB;
 logic [1:0] FP_forwardC;

/***********************************************///
 logic [31:0] pc_D, pc_plus_D;
 logic [31:0] pc_IM; 
 logic [31:0] inst_D;
 logic [1:0] PC_contr_E;
 logic IF_flush, ID_flush, EXE_flush;
 logic [31:0] pc_JALR_E, pc_BRA_E;
 
 

IF_CYCLE IF_CYCLE(
.clk(clk), 
.rst(rst), 
.PC_contr(PC_contr_E), 
.pc_JALR(pc_JALR_E), 
.pc_BRA(pc_BRA_E), 
.IF_stall(IF_stall),
.AXI_stall(AXI_stall),
.IF_flush(IF_flush),
//.ARVALID_M0(ARVALID_M0), 
//.ARREADY_M0(ARREADY_M0), 
.pc_D(pc_D), 
.pc_plus_D(pc_plus_D), 
//.pc_IM(IM_A),
.pc_c(IM_A),
.inst(IM_DO),
.inst_D(inst_D)
);

//*************************************************//
 logic [4:0] ALU_op_E;
 logic ALU_en_E;
 logic FPU_en_E;
 logic IMM_Src_E;
 logic B_Src_E;
 logic J_Src_E;
 logic RF_write_E;
 logic FPRF_write_E;
 logic [2:0] MEM_data_Src_E;
 logic [2:0] WB_Src_E;
 logic MEM_read_E;
 logic [2:0] MEM_read_Src_E;
 logic MEM_write_E;
 logic [2:0] MEM_write_Src_E;
 logic [1:0] CSR_Src_E;
 logic F_Src_E;
 logic [4:0]  rd_W;
 logic [4:0]  frd_W; 
 logic		RF_write_W;
 logic		FPRF_write_W; 
 logic [31:0] WB_data;
 logic [31:0] pc_E, pc_plus_E;
 logic [4:0] rs1_E, rs2_E, frs1_E, frs2_E;
 logic [31:0] rs1_data_E, rs2_data_E, frs1_data_E, frs2_data_E; 
 logic [31:0] imm_ext_E, CSR_ins_E;
 logic [4:0] rd_E, frd_E;

 logic [4:0] rd_D, frd_D;
 logic [4:0] rs1_D, rs2_D, frs1_D, frs2_D;


ID_CYCLE ID_CYCLE(
.clk(clk), 
.rst(rst), 
.inst_D(inst_D), 
.pc_D(pc_D), 
.pc_plus_D(pc_plus_D), 
.RF_write_W(RF_write_W), 
.FPRF_write_W(FPRF_write_W), 
.rd_W(rd_W), 
.frd_W(frd_W), 
.WB_data(WB_data), 
.ID_flush(ID_flush), 
.EXE_flush(EXE_flush), 
.ID_stall(ID_stall),
.AXI_stall(AXI_stall),
.ALU_op_E(ALU_op_E), 
.ALU_en_E(ALU_en_E), 
.FPU_en_E(FPU_en_E), 
.IMM_Src_E(IMM_Src_E), 
.B_Src_E(B_Src_E), 
.J_Src_E(J_Src_E), 
.RF_write_E(RF_write_E), 
.FPRF_write_E(FPRF_write_E), 
.MEM_data_Src_E(MEM_data_Src_E), 
.WB_Src_E(WB_Src_E),
.MEM_read_E(MEM_read_E), 
.MEM_read_Src_E(MEM_read_Src_E), 
.MEM_write_E(MEM_write_E), 
.MEM_write_Src_E(MEM_write_Src_E), 
.PC_contr_E(PC_contr_E), 
.CSR_Src_E(CSR_Src_E), 
.F_Src_E(F_Src_E),
.pc_E(pc_E), 
.pc_plus_E(pc_plus_E), 
.rs1_E(rs1_E), 
.rs2_E(rs2_E), 
.frs1_E(frs1_E), 
.frs2_E(frs2_E), 
.rs1_data_E(rs1_data_E), 
.rs2_data_E(rs2_data_E), 
.frs1_data_E(frs1_data_E), 
.frs2_data_E(frs2_data_E), 
.imm_ext_E(imm_ext_E), 
.CSR_ins_E(CSR_ins_E), 
.rd_D(rd_D), 
.frd_D(frd_D), 
.rd_E(rd_E), 
.frd_E(frd_E), 
.rs1_D(rs1_D), 
.rs2_D(rs2_D), 
.frs1_D(frs1_D), 
.frs2_D(frs2_D),
.pc_BRA_E(pc_BRA_E)
//.pc_JALR_E(pc_JALR_E)
);

//***************************************************//
 logic [31:0] pc_JALR_M, pc_BRA_M;
 logic RF_write_M;
 logic FPRF_write_M;
 logic [2:0] MEM_data_Src_M;
 logic [2:0] WB_Src_M;
 logic MEM_read_M;
 logic [2:0] MEM_read_Src_M;
 logic MEM_write_M;
 logic [2:0] MEM_write_Src_M;
 logic [1:0] CSR_Src_M;
 logic [31:0] pc_M, pc_plus_M;
 logic [4:0] rs1_M, rs2_M, frs1_M, frs2_M;
 logic [31:0] rs1_data_M, rs2_data_M, frs1_data_M, frs2_data_M; 
 logic [31:0] imm_ext_M, CSR_ins_M;
 logic [4:0] rd_M, frd_M;    
 logic [31:0] ALU_result_M, FPU_result_M;
 logic [31:0] sdata_M, FP_sdata_M;
 logic [31:0] MEM_back;


EXE_CYCLE EXE_CYCLE(
.clk(clk), 
.rst(rst),
.ALU_op_E(ALU_op_E), 
.ALU_en_E(ALU_en_E), 
.FPU_en_E(FPU_en_E), 
.IMM_Src_E(IMM_Src_E), 
.B_Src_E(B_Src_E), 
.J_Src_E(J_Src_E), 
.RF_write_E(RF_write_E), 
.FPRF_write_E(FPRF_write_E), 
.MEM_data_Src_E(MEM_data_Src_E), 
.WB_Src_E(WB_Src_E), 
.MEM_read_E(MEM_read_E), 
.MEM_read_Src_E(MEM_read_Src_E), 
.MEM_write_E(MEM_write_E), 
.MEM_write_Src_E(MEM_write_Src_E), 
.PC_contr_E(PC_contr_E), 
.CSR_Src_E(CSR_Src_E), 
.F_Src_E(F_Src_E),
.pc_E(pc_E), 
.pc_plus_E(pc_plus_E), 
.rs1_E(rs1_E), 
.rs2_E(rs2_E), 
.frs1_E(frs1_E), 
.frs2_E(frs2_E), 
.rs1_data_E(rs1_data_E), 
.rs2_data_E(rs2_data_E), 
.frs1_data_E(frs1_data_E), 
.frs2_data_E(frs2_data_E), 
.imm_ext_E(imm_ext_E), 
.CSR_ins_E(CSR_ins_E), 
.rd_E(rd_E), 
.frd_E(frd_E), 
.WB_data(WB_data),
.forwardA(forwardA), 
.forwardB(forwardB), 
.forwardC(forwardC), 
.FP_forwardA(FP_forwardA), 
.FP_forwardB(FP_forwardB), 
.FP_forwardC(FP_forwardC),
.MEM_back(MEM_back),
//
.AXI_stall(AXI_stall),
//
.pc_JALR_E(pc_JALR_E), 
.pc_BRA_E(pc_BRA_E), 
.pc_JALR_M(pc_JALR_M), 
.pc_BRA_M(pc_BRA_M), 
.IF_flush(IF_flush), 
.ID_flush(ID_flush), 
.EXE_flush(EXE_flush), 
.RF_write_M(RF_write_M), 
.FPRF_write_M(FPRF_write_M), 
.MEM_data_Src_M(MEM_data_Src_M), 
.WB_Src_M(WB_Src_M), 
.MEM_read_M(MEM_read_M), 
.MEM_read_Src_M(MEM_read_Src_M), 
.MEM_write_M(MEM_write_M), 
.MEM_write_Src_M(MEM_write_Src_M), 
.CSR_Src_M(CSR_Src_M),
.pc_M(pc_M), 
.pc_plus_M(pc_plus_M), 
.rs1_M(rs1_M), 
.rs2_M(rs2_M),
.frs1_M(frs1_M), 
.frs2_M(frs2_M), 
.rs1_data_M(rs1_data_M), 
.rs2_data_M(rs2_data_M), 
.frs1_data_M(frs1_data_M), 
.frs2_data_M(frs2_data_M), 
.imm_ext_M(imm_ext_M), 
.CSR_ins_M(CSR_ins_M), 
.rd_M(rd_M), 
.frd_M(frd_M), 
.ALU_result_M(ALU_result_M), 
.FPU_result_M(FPU_result_M), 
.sdata_M(sdata_M), 
.FP_sdata_M(FP_sdata_M)
);
//*************************************************************//
 logic [31:0] pc_plus_W;
 logic [31:0] ALU_result_W;
 logic [31:0] FPU_result_W; 
 logic [31:0] pc_BRA_W;
 logic [31:0] imm_ext_W; 
 logic [2:0]  WB_Src_W;
 logic [2:0]  MEM_read_Src_W;
 logic 		MEM_read_W;
 logic [1:0]  CSR_Src_W;
 logic [31:0] CSR_ins_W;
 logic [31:0] load_data;
 logic [31:0] MEM_back_W;

MEM_CYCLE MEM_CYCLE(
.clk(clk), 
.rst(rst), 
.pc_plus_M(pc_plus_M), 
.ALU_result_M(ALU_result_M), 
.FPU_result_M(FPU_result_M), 
.pc_BRA_M(pc_BRA_M), 
.imm_ext_M(imm_ext_M), 
.rd_M(rd_M), 
.frd_M(frd_M), 
.MEM_read_Src_M(MEM_read_Src_M), 
.MEM_write_Src_M(MEM_write_Src_M), 
.RF_write_M(RF_write_M), 
.FPRF_write_M(FPRF_write_M), 
.WB_Src_M(WB_Src_M), 
.MEM_read_M(MEM_read_M), 
.MEM_write_M(MEM_write_M),
.CSR_Src_M(CSR_Src_M), 
.CSR_ins_M(CSR_ins_M), 
.MEM_data_Src_M(MEM_data_Src_M),
.sdata_M(sdata_M), 
.FP_sdata_M(FP_sdata_M), 
.DM_DO(DM_DO), 
//
.AXI_stall(AXI_stall),
//
.pc_plus_W(pc_plus_W), 
.ALU_result_W(ALU_result_W), 
.FPU_result_W(FPU_result_W), 
.pc_BRA_W(pc_BRA_W), 
.imm_ext_W(imm_ext_W), 
.rd_W(rd_W), 
.frd_W(frd_W), 
.MEM_read_Src_W(MEM_read_Src_W), 
.RF_write_W(RF_write_W), 
.FPRF_write_W(FPRF_write_W), 
.WB_Src_W(WB_Src_W), 
.MEM_read_W(MEM_read_W),
.CSR_Src_W(CSR_Src_W), 
.CSR_ins_W(CSR_ins_W), 
.DM_BWEB(DM_BWEB), 
.DM_DI(DM_DI), 
.load_data(load_data),
.MEM_back(MEM_back),
.MEM_back_W(MEM_back_W),
.rvalid_out1(rvalid_out1)
);

//**************************************************************************//
 logic [31:0] CSR_cyc;


WB_CYCLE WB_CYCLE(
.clk(clk), 
.rst(rst), 
.rd_W(rd_W), 
.frd_W(frd_W), 
.RF_write_W(RF_write_W), 
.FPRF_write_W(FPRF_write_W), 
.WB_data_src_W(WB_Src_W), 
.CSR_src_W(CSR_Src_W), 
.MEM_load_W(load_data),
.MEM_back_W(MEM_back_W),
.WB_data(WB_data)
);

//*****************************************************************//
HU HU(
.rs1_E(rs1_E),
.rs2_E(rs2_E),
.frs1_E(frs1_E), 
.frs2_E(frs2_E), 
.rd_M(rd_M), 
.frd_M(frd_M), 
.rd_W(rd_W),
.frd_W(frd_W), 
.RF_write_M(RF_write_M),
.FPRF_write_M(FPRF_write_M), 
.RF_write_W(RF_write_W),
.FPRF_write_W(FPRF_write_W), 
.MEM_write_E(MEM_write_E),
.IMM_Src(IMM_Src_E),
.rs1_D(rs1_D),           
.rs2_D(rs2_D),           
.frs1_D(frs1_D),      
.frs2_D(frs2_D),      
.rd_E(rd_E),     
.MEM_read_E(MEM_read_E),        
.frd_E(frd_E),         
.IF_stall(IF_stall),
.ID_stall(ID_stall),
.forwardA(forwardA),
.forwardB(forwardB),
.forwardC(forwardC),
.FP_forwardA(FP_forwardA),
.FP_forwardB(FP_forwardB),
.FP_forwardC(FP_forwardC)
);


assign DM_CEB = 1'b0; 
assign IM_CEB = 1'b0; 
assign IM_WEB = 1'b1; 
assign DM_WEB = (MEM_read_M);
assign IM_BWEB= {32{1'd1}}; 
assign IM_DI  =  32'd0;     

//assign IM_A = pc_IM; 
assign DM_A = ALU_result_M;

assign w_en = MEM_write_M;
//assign r_en_DM = MEM_read_M;
//
always_ff @(posedge clk or posedge rst)
begin
    if(rst)
    r_en_DM <= 1'b0;
    else begin
		if (AXI_stall)begin
			if (rvalid_out1)
			r_en_DM <= 1'b0;
			else 
			r_en_DM <= r_en_DM;
		end
		else begin
		r_en_DM <= MEM_read_E;
		end
	end	
end    
     

//rst posedge IM_en
always_ff @(posedge clk or posedge rst)
begin
	if(rst)
    r_en_IM <= 1'b0;
    else
    r_en_IM <= 1'b1;
end     

endmodule
