//ID_CYCLE
`include "CU.sv"
`include "register_file.sv"
`include "CSR_STRET.sv"
`include "imm_extend.sv"

module ID_CYCLE(clk, rst, inst_D, pc_D, pc_plus_D, RF_write_W, FPRF_write_W, rd_W, frd_W, WB_data, ID_flush, EXE_flush, ID_stall, AXI_stall,
ALU_op_E, ALU_en_E, FPU_en_E, IMM_Src_E, B_Src_E, J_Src_E, RF_write_E, FPRF_write_E, MEM_data_Src_E, WB_Src_E, MEM_read_E, MEM_read_Src_E, MEM_write_E, MEM_write_Src_E, PC_contr_E, CSR_Src_E, F_Src_E,
pc_E, pc_plus_E, rs1_E, rs2_E, frs1_E, frs2_E, rs1_data_E, rs2_data_E, frs1_data_E, frs2_data_E, imm_ext_E, CSR_ins_E, rd_D, frd_D, rd_E, frd_E, rs1_D, rs2_D, frs1_D, frs2_D, pc_BRA_E/*, pc_JALR_E*/);
    
input logic clk, rst;
input logic [31:0] inst_D;
input logic [31:0] pc_D, pc_plus_D;

//WB
input logic RF_write_W, FPRF_write_W;
input logic [4:0] rd_W, frd_W;
input logic [31:0] WB_data;

//HU
input logic ID_flush, EXE_flush;
input logic ID_stall, AXI_stall;
 
//CU
output logic [4:0] ALU_op_E;
output logic ALU_en_E;
output logic FPU_en_E;
output logic IMM_Src_E;
output logic B_Src_E;
output logic J_Src_E;
output logic RF_write_E;
output logic FPRF_write_E;
output logic [2:0] MEM_data_Src_E;
output logic [2:0] WB_Src_E;
output logic MEM_read_E;
output logic [2:0] MEM_read_Src_E;
output logic MEM_write_E;
output logic [2:0] MEM_write_Src_E;
output logic [1:0] PC_contr_E;
output logic [1:0] CSR_Src_E;
output logic F_Src_E;

//
output logic [31:0] pc_E, pc_plus_E;
output logic [4:0] rs1_E, rs2_E, frs1_E, frs2_E;
output logic [31:0] rs1_data_E, rs2_data_E, frs1_data_E, frs2_data_E; 
output logic [31:0] imm_ext_E, CSR_ins_E;
output logic [4:0] rd_E, frd_E;

output logic [4:0] rd_D, frd_D;
output logic [4:0] rs1_D, rs2_D, frs1_D, frs2_D;

output logic [31:0] pc_BRA_E;       //, pc_JALR_E;


assign rs1_D = inst_D[19:15];
assign rs2_D = inst_D[24:20];
assign rd_D = inst_D[11:7];
assign frs1_D = inst_D[19:15];
assign frs2_D = inst_D[24:20];
assign frd_D = inst_D[11:7];

//*************************************************//
//CU
logic [6:0] op;
logic [1:0] func7;
logic func5;
logic [2:0] func3;
logic [1:0] CSR_func;

assign op = inst_D[6:0];
assign func7 = {inst_D[30], inst_D[25]};
assign func5 = inst_D[27]; 
assign func3 = inst_D[14:12];
assign CSR_func = {inst_D[27], inst_D[21]};

 logic [4:0] ALU_op_D;
 logic ALU_en_D;
 logic FPU_en_D;
 logic IMM_Src_D;
 logic B_Src_D;
 logic J_Src_D;
 logic RF_write_D;
 logic FPRF_write_D;
 logic [2:0] MEM_data_Src_D;
 logic [2:0] WB_Src_D;
 logic MEM_read_D;
 logic [2:0] MEM_read_Src_D;
 logic MEM_write_D;
 logic [2:0] MEM_write_Src_D;
 logic [1:0] PC_contr_D;
 logic [1:0] CSR_Src_D;
 logic F_Src_D;


CU control_unit(
.op(op), 
.func7(func7), 
.func5(func5), 
.func3(func3), 
.CSR_func(CSR_func), 
.ID_stall(ID_stall),  
.AXI_stall(AXI_stall),
.pc_D(pc_D), 
.ALU_op(ALU_op_D), 
.ALU_en(ALU_en_D), 
.FPU_en(FPU_en_D), 
.IMM_Src(IMM_Src_D), 
.B_Src(B_Src_D), 
.J_Src(J_Src_D), 
.RF_write(RF_write_D), 
.FPRF_write(FPRF_write_D), 
.MEM_data_Src(MEM_data_Src_D), 
.WB_Src(WB_Src_D), 
.MEM_read(MEM_read_D), 
.MEM_read_Src(MEM_read_Src_D), 
.MEM_write(MEM_write_D),  
.MEM_write_Src(MEM_write_Src_D), 
.PC_contr(PC_contr_D), 
.CSR_Src(CSR_Src_D), 
.F_Src(F_Src_D)
);

//**************************************************************//
logic [31:0] rs1_data_D, rs2_data_D, frs1_data_D, frs2_data_D;

//RF
 register_file COM_reg(
.clk(clk), 
.rst(rst), 
.A1(rs1_D), 
.A2(rs2_D), 
.A3(rd_W), 
.rf_write(RF_write_W), 
.WB_data(WB_data), 
.A1_data(rs1_data_D), 
.A2_data(rs2_data_D)
); 

register_file FP_reg(
.clk(clk), 
.rst(rst), 
.A1(frs1_D), 
.A2(frs2_D), 
.A3(frd_W), 
.rf_write(FPRF_write_W), 
.WB_data(WB_data), 
.A1_data(frs1_data_D), 
.A2_data(frs2_data_D)
); 		

//**************************************//
//imm extend
logic [31:0] imm_ext_D;

imm_extend imm_extend(
.inst(inst_D), 
.op(op), 
.imm_ext(imm_ext_D)
);                 
//***************************************//
logic [31:0] CSR_ins_D;

CSR_STRET CSR_STRET(
.clk(clk), 
.rst(rst), 
.ID_flush(ID_flush), 
.EXE_flush(EXE_flush), 
.ID_stall(ID_stall), 
.AXI_stall(AXI_stall),
.CSR_src(CSR_Src_D), 
.CSR_ins(CSR_ins_D)
);                  
//***************************************//
//IDEXE reg
logic [31:0] pc_BRA_D, pc_JALR_D;

always_ff @(posedge clk or posedge rst) 
begin
    if (rst) begin
        ALU_op_E    <= 5'b0;
        ALU_en_E    <= 1'b0;    
        FPU_en_E    <= 1'b0;
        IMM_Src_E   <= 1'b0;
        B_Src_E <= 1'b0;
        J_Src_E <= 1'b0;
        RF_write_E <= 1'b0;
        FPRF_write_E <= 1'b0;
        MEM_data_Src_E <= 3'b0;
        WB_Src_E <= 3'b0; 
        MEM_read_E <= 1'b0;
        MEM_read_Src_E <= 3'b0;
        MEM_write_E <= 1'b0;
        MEM_write_Src_E <= 3'b0;
        PC_contr_E  <= 2'b0;
        CSR_Src_E   <= 2'b0;
        F_Src_E <= 1'b0;
        pc_E    <= 32'b0;
        pc_plus_E   <= 32'b0;
        rs1_E   <= 5'b0;
        rs2_E   <= 5'b0;
        frs1_E  <= 5'b0;
        frs2_E  <= 5'b0;
        rs1_data_E <= 32'b0;
        rs2_data_E <= 32'b0;
        frs1_data_E <= 32'b0;
        frs2_data_E <= 32'b0; 
        imm_ext_E <= 32'b0;
        CSR_ins_E <= 32'b0;
        rd_E <= 5'b0;
        frd_E <= 5'b0;
        pc_BRA_E <= 32'b0;
      //  pc_JALR_E <= 32'b0;
    end
    else begin
        if (AXI_stall)begin
            ALU_op_E    <= ALU_op_E;
            ALU_en_E    <= ALU_en_E;    
            FPU_en_E    <= FPU_en_E;
            IMM_Src_E   <= IMM_Src_E;
            B_Src_E <= B_Src_E;
            J_Src_E <= J_Src_E;
            RF_write_E <= RF_write_E;
            FPRF_write_E <= FPRF_write_E;
            MEM_data_Src_E <= MEM_data_Src_E;
            WB_Src_E <= WB_Src_E; 
            MEM_read_E <= MEM_read_E;
            MEM_read_Src_E <= MEM_read_Src_E;
            MEM_write_E <= MEM_write_E;
            MEM_write_Src_E <= MEM_write_Src_E;
            PC_contr_E  <= PC_contr_E;
            CSR_Src_E   <= CSR_Src_E;
            F_Src_E <= F_Src_E;
            pc_E    <= pc_E;
            pc_plus_E   <= pc_plus_E;
            rs1_E   <= rs1_E;
            rs2_E   <= rs2_E;
            frs1_E  <= frs1_E;
            frs2_E  <= frs2_E;
            rs1_data_E <= rs1_data_E;
            rs2_data_E <= rs2_data_E;
            frs1_data_E <= frs1_data_E;
            frs2_data_E <= frs2_data_E; 
            imm_ext_E <= imm_ext_E;
            CSR_ins_E <= CSR_ins_E;
            rd_E <= rd_E;
            frd_E <= frd_E;
            pc_BRA_E <= pc_BRA_E;
           // pc_JALR_E <= pc_JALR_E;
        end
        else if(ID_flush || EXE_flush)begin
            ALU_op_E    <= 5'b0;
            ALU_en_E    <= 1'b0;    
            FPU_en_E    <= 1'b0;
            IMM_Src_E   <= 1'b0;
            B_Src_E <= 1'b0;
            J_Src_E <= 1'b0;
            RF_write_E <= 1'b0;
            FPRF_write_E <= 1'b0;
            MEM_data_Src_E <= 3'b0;
            WB_Src_E <= 3'b0; 
            MEM_read_E <= 1'b0;
            MEM_read_Src_E <= 3'b0;
            MEM_write_E <= 1'b0;
            MEM_write_Src_E <= 3'b0;
           PC_contr_E  <= 2'b0;
            CSR_Src_E   <= 2'b0;
            F_Src_E <= 1'b0;
            pc_E    <= 32'b0;
            pc_plus_E   <= 32'b0;
            rs1_E   <= 5'b0;
            rs2_E   <= 5'b0;
            frs1_E  <= 5'b0;
            frs2_E  <= 5'b0;
            rs1_data_E <= 32'b0;
            rs2_data_E <= 32'b0;
            frs1_data_E <= 32'b0;
            frs2_data_E <= 32'b0; 
            imm_ext_E <= 32'b0;
            CSR_ins_E <= 32'b0;
            rd_E <= 5'b0;
            frd_E <= 5'b0;
        end
		else if (ID_stall) begin
			ALU_op_E    <= ALU_op_D;
            ALU_en_E    <= ALU_en_D;    
            FPU_en_E    <= FPU_en_D;
            IMM_Src_E   <= IMM_Src_D;
            B_Src_E <= B_Src_D;
            J_Src_E <= J_Src_D;
            RF_write_E <= RF_write_D;
            FPRF_write_E <= FPRF_write_D;
            MEM_data_Src_E <= MEM_data_Src_D;
            WB_Src_E <= WB_Src_D; 
            MEM_read_E <= MEM_read_D;
            MEM_read_Src_E <= MEM_read_Src_D;
            MEM_write_E <= MEM_write_D;
            MEM_write_Src_E <= MEM_write_Src_D;
            PC_contr_E  <= PC_contr_D;
            CSR_Src_E   <= CSR_Src_D;
            F_Src_E <= F_Src_D;
            pc_E    <= 32'b0;
            pc_plus_E   <= pc_plus_D;
            rs1_E   <= rs1_D;
            rs2_E   <= rs2_D;
            frs1_E  <= frs1_D;
            frs2_E  <= frs2_D;
            rs1_data_E <= 32'b0;
            rs2_data_E <= 32'b0;
            frs1_data_E <= 32'b0;
            frs2_data_E <= 32'b0; 
            imm_ext_E <= 32'b0;
            CSR_ins_E <= CSR_ins_D;
            rd_E <= rd_D;
            frd_E <= frd_D;
            pc_BRA_E <= pc_BRA_D;
            //pc_JALR_E <= pc_JALR_D;
		end	
        else begin
            ALU_op_E    <= ALU_op_D;
            ALU_en_E    <= ALU_en_D;    
            FPU_en_E    <= FPU_en_D;
            IMM_Src_E   <= IMM_Src_D;
            B_Src_E <= B_Src_D;
            J_Src_E <= J_Src_D;
            RF_write_E <= RF_write_D;
            FPRF_write_E <= FPRF_write_D;
            MEM_data_Src_E <= MEM_data_Src_D;
            WB_Src_E <= WB_Src_D; 
            MEM_read_E <= MEM_read_D;
            MEM_read_Src_E <= MEM_read_Src_D;
            MEM_write_E <= MEM_write_D;
            MEM_write_Src_E <= MEM_write_Src_D;
            PC_contr_E  <= PC_contr_D;
            CSR_Src_E   <= CSR_Src_D;
            F_Src_E <= F_Src_D;
            pc_E    <= pc_D;
            pc_plus_E   <= pc_plus_D;
            rs1_E   <= rs1_D;
            rs2_E   <= rs2_D;
            frs1_E  <= frs1_D;
            frs2_E  <= frs2_D;
            rs1_data_E <= rs1_data_D;
            rs2_data_E <= rs2_data_D;
            frs1_data_E <= frs1_data_D;
            frs2_data_E <= frs2_data_D; 
            imm_ext_E <= imm_ext_D;
            CSR_ins_E <= CSR_ins_D;
            rd_E <= rd_D;
            frd_E <= frd_D;
            pc_BRA_E <= pc_BRA_D;
           // pc_JALR_E <= pc_JALR_D;
        end
    end    
end
/*
logic [31:0] imm_ext_JALR;

always_ff@(posedge clk or posedge rst) 
begin
    if (rst) 
        imm_ext_JALR <= 32'b0;
    else    
        imm_ext_JALR <= imm_ext_D;
end
*/
assign pc_BRA_D =  pc_D + imm_ext_D;
//assign pc_JALR_D = imm_ext_D + rs1_data_D;

endmodule