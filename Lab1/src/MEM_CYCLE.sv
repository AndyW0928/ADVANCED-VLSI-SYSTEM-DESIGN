`include "S_Src.sv"
`include "L_Src.sv"

module MEM_CYCLE(clk, rst, pc_plus_M, ALU_result_M, FPU_result_M, pc_BRA_M, imm_ext_M, rd_M, frd_M, MEM_read_Src_M, MEM_write_Src_M, RF_write_M, FPRF_write_M, WB_Src_M, MEM_read_M, MEM_write_M,
CSR_Src_M, CSR_ins_M, MEM_data_Src_M, sdata_M, FP_sdata_M, DM_DO,
pc_plus_W, ALU_result_W, FPU_result_W, pc_BRA_W, imm_ext_W, rd_W, frd_W, MEM_read_Src_W, RF_write_W, FPRF_write_W, WB_Src_W, MEM_read_W,
CSR_Src_W, CSR_ins_W, DM_BWEB, DM_DI, load_data, MEM_back, MEM_back_W);

input logic clk;
input logic rst;
input logic [31:0] pc_plus_M;
input logic [31:0] ALU_result_M;
input logic [31:0] FPU_result_M; 
input logic [31:0] pc_BRA_M;
input logic [31:0] imm_ext_M;
input logic [4:0]	 rd_M;
input logic [4:0]	 frd_M; 
input logic [2:0]  MEM_read_Src_M;

input logic 		 RF_write_M;
input logic 		 FPRF_write_M; 
input logic [2:0]  WB_Src_M;
input logic 		 MEM_read_M;
input logic [1:0]  CSR_Src_M;
input logic [31:0] CSR_ins_M;	 
input logic        MEM_write_M;
input logic [2:0]  MEM_write_Src_M;
input logic [2:0]  MEM_data_Src_M;
input logic [31:0] sdata_M;
input logic [31:0] FP_sdata_M;
input logic [31:0] DM_DO;

output logic [31:0] pc_plus_W;
output logic [31:0] ALU_result_W;
output logic [31:0] FPU_result_W; 
output logic [31:0] pc_BRA_W;
output logic [31:0] imm_ext_W; 
output logic [4:0]  rd_W;
output logic [4:0]  frd_W; 
output logic		RF_write_W;
output logic		FPRF_write_W; 
output logic [2:0]  WB_Src_W;
output logic [2:0]  MEM_read_Src_W;
output logic 		MEM_read_W;
output logic [1:0]  CSR_Src_W;
output logic [31:0] CSR_ins_W;
output logic [31:0] DM_BWEB;
output logic [31:0] DM_DI;
output logic [31:0] load_data;
output logic [31:0] MEM_back, MEM_back_W;


/**********************************************/
//MEM back
always_comb 
begin
    case(MEM_data_Src_M)   
        3'b000:  MEM_back = ALU_result_M;           
        3'b001:  MEM_back = pc_plus_M;                  
        3'b010:  MEM_back = pc_BRA_M;           
        3'b011:  MEM_back = imm_ext_M;
		3'b100:  MEM_back = CSR_ins_M;
        3'b101:  MEM_back = FPU_result_M;    
        default: MEM_back = 32'b0;
    endcase
end

//******************************************//
//STORE    
S_Src S_Src(
.MEM_write_M(MEM_write_M), 
.MEM_writetype(MEM_write_Src_M), 
.sdata_M(sdata_M), 
.FP_sdata_M(FP_sdata_M),
.writeMEM_place(ALU_result_M[1:0]), 
.DM_BWEB(DM_BWEB), 
.DM_DI(DM_DI)
);

//********************************************//
//LOAD
//logic [31:0] MEM_load_M;

L_Src L_Src(
.MEM_read_M(MEM_read_W), 
.MEM_readtype_M(MEM_read_Src_W), 
.DM_DO(DM_DO), 
.MEM_data_M(load_data)
);    



always_ff@(posedge clk or posedge rst) begin
	if(rst) begin 
	pc_plus_W 	        <= 32'b0;
	ALU_result_W 	        <= 32'b0;
	FPU_result_W 	        <= 32'b0; 
	pc_BRA_W	        <= 32'b0;
	imm_ext_W		        <= 32'b0;
	rd_W		        <= 5'b0;
	frd_W		        <= 5'b0; 
	RF_write_W	        <= 1'b0;
	FPRF_write_W	    <= 1'b0;
	WB_Src_W          <= 3'b0;
	MEM_read_Src_W      <= 3'b0;
	MEM_read_W   	    <= 1'b0;
	CSR_Src_W	        <= 2'b00;
	CSR_ins_W      <= 32'b0;
	MEM_back_W		<= 32'b0;
	end
	else begin 
	pc_plus_W 	     <= pc_plus_M;
	ALU_result_W      <= ALU_result_M;
	FPU_result_W      <= FPU_result_M; 
	pc_BRA_W	      <= pc_BRA_M;
	imm_ext_W      <= imm_ext_M;
	rd_W	      <= rd_M;
	frd_W	      <= frd_M; 
	RF_write_W	     <= RF_write_M;
	FPRF_write_W    <= FPRF_write_M;
	WB_Src_W       <=  WB_Src_M;
	MEM_read_Src_W     <= MEM_read_Src_M;
	MEM_read_W     <= MEM_read_M;
	CSR_Src_W	    <= CSR_Src_M;
	CSR_ins_W      <= CSR_ins_M;
	MEM_back_W		<= MEM_back;
	end
end

endmodule
