//v2 add AXI stall
`include "../../include/CPU_core.svh"

module CPU(clk, rst, stall_CPU,DM_READ_DONE, DM_READ, DM_WRITE,DM_BWEB ,DM_A, DM_DI, DM_DO, IM_READ, IM_BWEB , IM_A,  IM_DI, IM_DO,
            inter_DMA, inter_WDT, WFI_pc_en
            );
    
input logic clk, rst;
input logic stall_CPU;
output logic WFI_pc_en;
//interrupt
input logic inter_DMA, inter_WDT;
// output logic IM_CEB, DM_CEB;
// output logic IM_WEB, DM_WEB;
logic DM_WEB;

output logic [3:0] DM_BWEB;
output logic [31:0] DM_A;
output logic [31:0] DM_DI;
input logic [31:0] DM_DO;
output logic DM_READ;
output logic DM_WRITE;

output logic IM_READ;
output logic [3:0] IM_BWEB;
output logic [31:0] IM_A;
output logic [31:0] IM_DI;
input logic [31:0] IM_DO;
input logic DM_READ_DONE;

    //-Mux_PC_Branch
    logic [31:0] pc_next;

    //-Reg PC
    logic [31:0] pc;

    //-Reg IF/ID
    logic [31:0] IF_ID_pc, IF_ID_inst;
    logic [31:0] ID_EX_inst;
    //-Decoder
    logic [6:0] dc_out_opcode;
    logic [4:0] dc_out_rs1_index, dc_out_rs2_index, dc_out_rd_index;
    logic [2:0] dc_out_func3;
    logic dc_out_func7_AL, dc_out_func7_mul, dc_out_func5_sub, dc_out_CSR_rdinst;

    //-Imm_Ext
    logic [31:0] imm_ext_out;

    //-Hazard_Detection_unit
    logic stall_hazard;

    //-BJ_unit
    logic [31:0] pc_branch_jump;
    logic branch_taken ,jump_taken;

    //-RegFile_Int
    logic [31:0] rs1_int_data_out, rs2_int_data_out;

    //-RegFile_FP
    logic [31:0] rs1_fp_data_out, rs2_fp_data_out;

    //-Mux_rs1_data_fp_int
    logic [31:0] rs1_data;

    //-Mux_rs2_data_fp_int
    logic [31:0] rs2_data;

    //-Controller
        ////ID
    logic Controller_fprs1, Controller_fprs2, Controller_fpu_on;

        ////EX
    logic [1:0] Controller_alu_csr_bujrd;
    logic Controller_alusrc1, Controller_alusrc2, Controller_instr_executed, Controller_bj;

        ////MEM
    logic [2:0] Controller_memread, Controller_memwrite;

        ////WB
    logic Controller_int_regwrite, Controller_fp_regwrite, Controller_memtoreg;

    //-Reg_ID_EX
    logic [6:0] ID_EX_opcode;
    logic [2:0] ID_EX_func3;
    logic ID_EX_func7_AL, ID_EX_func7_mul, ID_EX_func5_sub, ID_EX_CSR_rdinst, ID_EX_fprs1, ID_EX_fprs2, ID_EX_fpu_on;
    logic [31:0] ID_EX_rs1_data, ID_EX_rs2_data, ID_EX_imm, ID_EX_pc;

        ////forwarding
    logic [4:0] ID_EX_rs, ID_EX_rt, ID_EX_rd;

        ////EX
    logic [1:0] ID_EX_alu_csr_bujrd;
    logic ID_EX_alusrc1, ID_EX_alusrc2, ID_EX_bj;

        ////MEM
    logic [2:0] ID_EX_memread, ID_EX_memwrite;
    logic  ID_EX_memread_1bit, ID_EX_memwrite_1bit;

        ////WB
    logic ID_EX_int_regwrite, ID_EX_fp_regwrite, ID_EX_memtoreg;

    //-Forwarding_unit
    logic [31:0] rs1_forward_data, rs2_forward_data;
    logic [1:0] forwardA, forwardB, forwardA2fpu, forwardB2fpu;
    logic forwardC, forwardD;

    //-Mux_ForwadingA
    logic [31:0] operand1, rs1orpc;

    //-Mux_ForwadingA2FPU
    logic [31:0] rs1_fpu;

    //-Mux_ForwadingB
    logic [31:0] rs2orimm, j_operand, b_operand;

    //-Mux_ForwadingB2FPU
    logic [31:0] rs2_fpu;

    //-Mux_rs2_imm
    logic [31:0] operand2;

    //-ALU
    logic [31:0] alu_out, fp_out;

    //-CSR
    logic [31:0] csr_out;

    //-Mux_alu_csr_bujrd_data
    logic [31:0] alu_csr_bujrd_data;

    //-Reg_EX_MEM
    logic [31:0] EX_MEM_alu_csr_bujrd_data, EX_MEM_write_data;
    logic [4:0] EX_MEM_rd;
    logic EX_MEM_fprs1, EX_MEM_fprs2;

        ////MEM signals
    logic [2:0] EX_MEM_memread, EX_MEM_memwrite;

        ////WB signals
    logic EX_MEM_int_regwrite, EX_MEM_fp_regwrite, EX_MEM_memtoreg;

    logic [31:0] read_data;
    //-Reg_MEM_WB
    logic [31:0] MEM_WB_alu_csr_bujrd_data, MEM_WB_read_data;
    logic [4:0] MEM_WB_rd;
    logic [2:0] MEM_WB_memread;
    logic MEM_WB_fprs1, MEM_WB_fprs2;
    logic MEM_WB_int_regwrite, MEM_WB_fp_regwrite, MEM_WB_memtoreg;

    //-Mux_MEM_WB_MEM2Reg
    logic [31:0] Mux_WB_memtoreg_data;

    logic [31:0] load_data_r;		//for load data reg
    logic [31:0] read_data_reg;


    //CSR & INTERRUPT
    logic [31:0] pc_CSR;
    logic mie, mtie, meie;
    logic MEIP_en, MEIP_end;      //external interrupt (DMA) begin/end
    logic MTIP_en, MTIP_end;      //time interrupt (WDT) begin/end
    logic WFI_out;//,WFI_pc_en;
	
	//BPU
    logic branch_pred,IF_ID_branch_pred , ID_EX_branch_pred;
	// logic [31:0] pc_Pred;
    logic t_pnt, nt_pt;

/**************************************************************************************************/
//FOR timeout and branch happen simultaneously
// logic [31:0] BPU_inst , BPU_pc;
logic inter_WDT_r;
always_ff @(posedge clk or posedge rst)
begin
    if (rst) begin
        inter_WDT_r <=1'b0;
    end
    else if(stall_CPU)begin
        inter_WDT_r <= inter_WDT_r;
        end
    else 
        inter_WDT_r <= inter_WDT;
end 
// always_ff @(posedge clk or posedge rst)
// begin
//     if (rst) begin
//         BPU_inst <= 32'b0;
//         BPU_pc <= 32'b0;
//         inter_WDT_r <=1'b0;
//     end
//     else if(stall_CPU)begin
//         BPU_inst <= BPU_inst;
//         BPU_pc <= BPU_pc;
//         inter_WDT_r <= inter_WDT_r;
//         end
//     else begin
//             if (stall_hazard) begin
//                 BPU_inst <= BPU_inst;
//                 BPU_pc <= BPU_pc;
//                 // inter_WDT_r <= inter_WDT_r;
//             end
//             else if (jump_taken ||t_pnt || nt_pt || WFI_pc_en || MEIP_en || MEIP_end || MTIP_en) begin
//                 BPU_inst <= 32'b0;
//                 BPU_pc <= 32'b0;
//                 // inter_WDT_r <=1'b0;
//             end
//             else begin
//                 BPU_inst <= IM_DO;
//                 BPU_pc <= pc;
//                 inter_WDT_r <= inter_WDT;
//             end
//         end
// end            

/**************************************************************************************************/
/*************************************** IF stage *************************************************/
/*************************************** >>>>>>>> *************************************************/
// BPU BPU(
//     .clk(clk),
//     .rst(rst),
// 	.stall_CPU(stall_CPU),
// 	.stall_hazard(stall_hazard),
// 	.branch_RealTaken(branch_taken),
// 	.ID_EX_opcode(ID_EX_opcode),
//     .ID_EX_branch_pred(ID_EX_branch_pred),
//     // .inst(BPU_inst/*IM_DO*/),
//     // .pc(BPU_pc/*pc*/),
//     .inst(IM_DO),
//     .pc(pc),
// //output
//     .branch_pred(branch_pred),
//     .pc_Pred(pc_Pred),
// 	.t_pnt(t_pnt),
// 	.nt_pt(nt_pt)
// );

Mux2_1 Mux_PC_Branch (
    .a(pc_branch_jump), 
    .b(pc + 32'd4), 
    .en((jump_taken || t_pnt || branch_taken)&& ~inter_WDT_r), 
    .out(pc_next)
);

Reg_PC Reg_PC (
    .clk(clk), 
    .rst(rst), 
    .stall_hazard(stall_hazard), 
    .pc_next(pc_next), 
    .pc(pc),
    .stall_CPU(stall_CPU),
    .pc_CSR(pc_CSR),
    .WFI_out(WFI_out),
    .WFI_pc_en(WFI_pc_en),
    .MEIP_en(MEIP_en), 
    .MEIP_end(MEIP_end), 
    .MTIP_en(MTIP_en), 
    .MTIP_end(MTIP_end),

    .pc_Pred(/*pc_Pred*/),
	.branch_pred(branch_pred),
	.t_pnt(t_pnt),
	.nt_pt(nt_pt)
);


Reg_IF_ID Reg_IF_ID (
    .clk(clk), 
    .rst(rst), 
    .stall_hazard(stall_hazard),
    .jump_taken(jump_taken || branch_taken),  
    .pc(pc),
    .inst(IM_DO), 
    .branch_pred(branch_pred),
    .IF_ID_pc(IF_ID_pc), 
    .IF_ID_inst(IF_ID_inst),
    .IF_ID_branch_pred(IF_ID_branch_pred),
    .stall_CPU(stall_CPU),
    .WFI_pc_en(WFI_pc_en),
    .MEIP_en(MEIP_en), 
    .MEIP_end(MEIP_end),
    .t_pnt(t_pnt),
	.nt_pt(nt_pt)

);

/*************************************** <<<<<<<< *************************************************/
/*************************************** ID stage *************************************************/
/*************************************** >>>>>>>> *************************************************/


Decoder Decoder (
    .inst(IF_ID_inst), 
    .dc_out_opcode(dc_out_opcode), 
    .dc_out_func3(dc_out_func3), 
    .dc_out_func7_AL(dc_out_func7_AL), 
    .dc_out_func7_mul(dc_out_func7_mul), 
    .dc_out_func5_sub(dc_out_func5_sub), 
    .dc_out_CSR_rdinst(dc_out_CSR_rdinst), 
    .dc_out_rs1_index(dc_out_rs1_index), 
    .dc_out_rs2_index(dc_out_rs2_index),
    .dc_out_rd_index(dc_out_rd_index)
);

Imm_Ext Imm_Ext (
    .inst(IF_ID_inst), 
    .imm_ext_out(imm_ext_out)
);

HDU HDU (
    .IF_ID_rs(dc_out_rs1_index), 
    .IF_ID_rt(dc_out_rs2_index), 
    .ID_EX_rd(ID_EX_rd), 
    .ID_EX_memread(ID_EX_memread_1bit), 
    .stall_hazard(stall_hazard)
);

Controller Controller (
    .dc_out_opcode(dc_out_opcode), 
    .dc_out_func3(dc_out_func3), 
    .dc_out_func7_AL(dc_out_func7_AL),
    .dc_out_func7_mul(dc_out_func7_mul), 
    .dc_out_func5_sub(dc_out_func5_sub), 
    .dc_out_CSR_rdinst(dc_out_CSR_rdinst),
    .Controller_alusrc1(Controller_alusrc1),
    .Controller_alusrc2(Controller_alusrc2),
    .Controller_bj(Controller_bj),          
    .Controller_alu_csr_bujrd(Controller_alu_csr_bujrd),
    .Controller_memread(Controller_memread),        
    .Controller_memwrite(Controller_memwrite),
    .Controller_int_regwrite(Controller_int_regwrite),    
    .Controller_fp_regwrite(Controller_fp_regwrite),        
    .Controller_memtoreg(Controller_memtoreg),
    .Controller_fprs1(Controller_fprs1), 
    .Controller_fprs2(Controller_fprs2),
    .Controller_fpu_on(Controller_fpu_on)
);

RegFile_Int RegFile_Int (
    .clk(clk), 
    .rst(rst), 
    .wb_en_int(MEM_WB_int_regwrite), 
    .wb_data(Mux_WB_memtoreg_data), 
    .rd_index(MEM_WB_rd), 
    .rs1_index(dc_out_rs1_index), 
    .rs2_index(dc_out_rs2_index), 
    .rs1_int_data_out(rs1_int_data_out), 
    .rs2_int_data_out(rs2_int_data_out),
    .stall_CPU(stall_CPU)
);

RegFile_FP RegFile_FP (
    .clk(clk), 
    .rst(rst), 
    .wb_en_fp(MEM_WB_fp_regwrite), 
    .wb_data(Mux_WB_memtoreg_data), 
    .rd_index(MEM_WB_rd), 
    .rs1_index(dc_out_rs1_index), 
    .rs2_index(dc_out_rs2_index), 
    .rs1_fp_data_out(rs1_fp_data_out), 
    .rs2_fp_data_out(rs2_fp_data_out),
    .stall_CPU(stall_CPU)
);

Mux2_1 Mux_rs1_data_fp_int (
    .a(rs1_fp_data_out), 
    .b(rs1_int_data_out), 
    .en(Controller_fprs1), 
    .out(rs1_data)
);

Mux2_1 Mux_rs2_data_fp_int (
    .a(rs2_fp_data_out), 
    .b(rs2_int_data_out), 
    .en(Controller_fprs2), 
    .out(rs2_data)
);

Mux2_1 Mux_ForwadingC (
    .a(Mux_WB_memtoreg_data), 
    .b(rs1_data), 
    .en(forwardC), 
    .out(rs1_forward_data)
);

Mux2_1 Mux_ForwadingD (
    .a(Mux_WB_memtoreg_data), 
    .b(rs2_data), 
    .en(forwardD), 
    .out(rs2_forward_data)
);


Reg_ID_EX Reg_ID_EX (
    .clk(clk), 
    .rst(rst), 
    .stall_hazard(stall_hazard), 
    .jump_taken(jump_taken || branch_taken),
    .IF_ID_branch_pred(IF_ID_branch_pred),
    .IF_ID_rs(dc_out_rs1_index), 
    .IF_ID_rt(dc_out_rs2_index),
    .IF_ID_rd(dc_out_rd_index), 
    .IF_ID_pc(IF_ID_pc),
    .IF_ID_inst(IF_ID_inst),
    .rs1_data(rs1_forward_data), 
    .rs2_data(rs2_forward_data), 
    .imm_ext_out(imm_ext_out),
    .dc_out_opcode(dc_out_opcode), 
    .dc_out_func3(dc_out_func3),
    .dc_out_func7_AL(dc_out_func7_AL), 
    .dc_out_func7_mul(dc_out_func7_mul),
    .dc_out_func5_sub(dc_out_func5_sub), 
    .dc_out_CSR_rdinst(dc_out_CSR_rdinst),
    .Controller_alusrc1(Controller_alusrc1), 
    .Controller_alusrc2(Controller_alusrc2),
    .Controller_bj(Controller_bj),
    .Controller_alu_csr_bujrd(Controller_alu_csr_bujrd),
    .Controller_memread(Controller_memread), 
    .Controller_memwrite(Controller_memwrite),
    .Controller_int_regwrite(Controller_int_regwrite), 
    .Controller_fp_regwrite(Controller_fp_regwrite),
    .Controller_memtoreg(Controller_memtoreg),
    .Controller_fprs1(Controller_fprs1), 
    .Controller_fprs2(Controller_fprs2),
    .Controller_fpu_on(Controller_fpu_on),
    .ID_EX_rs(ID_EX_rs), 
    .ID_EX_rt(ID_EX_rt), 
    .ID_EX_rd(ID_EX_rd), 
    .ID_EX_opcode(ID_EX_opcode), 
    .ID_EX_func3(ID_EX_func3),
    .ID_EX_func7_AL(ID_EX_func7_AL), 
    .ID_EX_func7_mul(ID_EX_func7_mul), 
    .ID_EX_func5_sub(ID_EX_func5_sub),
    .ID_EX_CSR_rdinst(ID_EX_CSR_rdinst), 
    .ID_EX_alusrc1(ID_EX_alusrc1), 
    .ID_EX_alusrc2(ID_EX_alusrc2),
    .ID_EX_bj(ID_EX_bj),
    .ID_EX_alu_csr_bujrd(ID_EX_alu_csr_bujrd),
    .ID_EX_memread(ID_EX_memread), 
    .ID_EX_memwrite(ID_EX_memwrite),
    .ID_EX_memread_1bit(ID_EX_memread_1bit), 
    .ID_EX_memwrite_1bit(ID_EX_memwrite_1bit),
    .ID_EX_int_regwrite(ID_EX_int_regwrite), 
    .ID_EX_fp_regwrite(ID_EX_fp_regwrite), 
    .ID_EX_memtoreg(ID_EX_memtoreg),
    .ID_EX_rs1_data(ID_EX_rs1_data), 
    .ID_EX_rs2_data(ID_EX_rs2_data), 
    .ID_EX_imm(ID_EX_imm), 
    .ID_EX_pc(ID_EX_pc),
    .ID_EX_inst(ID_EX_inst),
    .ID_EX_fprs1(ID_EX_fprs1), 
    .ID_EX_fprs2(ID_EX_fprs2), 
    .ID_EX_fpu_on(ID_EX_fpu_on),
    .stall_CPU(stall_CPU),
    .MEIP_en(MEIP_en), 
    .MEIP_end(MEIP_end),
    .WFI_pc_en(WFI_pc_en),
    .ID_EX_branch_pred(ID_EX_branch_pred),
    .t_pnt(t_pnt),
	.nt_pt(nt_pt)
);

/*************************************** <<<<<<<< *************************************************/
/*************************************** EX stage *************************************************/
/*************************************** >>>>>>>> *************************************************/

Forwarding_unit Forwarding_unit (
    .IF_ID_rs(dc_out_rs1_index), 
    .IF_ID_rt(dc_out_rs2_index), 
    .ID_EX_rs(ID_EX_rs), 
    .ID_EX_rt(ID_EX_rt), 
    .EX_MEM_rd(EX_MEM_rd), 
    .MEM_WB_rd(MEM_WB_rd),
    .ID_EX_fprs1(ID_EX_fprs1), 
    .ID_EX_fprs2(ID_EX_fprs2),
    .EX_MEM_fp_regwrite(EX_MEM_fp_regwrite), 
    .EX_MEM_int_regwrite(EX_MEM_int_regwrite),
    .MEM_WB_fp_regwrite(MEM_WB_fp_regwrite), 
    .MEM_WB_int_regwrite(MEM_WB_int_regwrite),
    .forwardA(forwardA), 
    .forwardB(forwardB), 
    .forwardC(forwardC), 
    .forwardD(forwardD),
    .forwardA2fpu(forwardA2fpu),
    .forwardB2fpu(forwardB2fpu)
);

Mux3_1 Mux_ForwadingA (
    .a(ID_EX_rs1_data), 
    .b(EX_MEM_alu_csr_bujrd_data), 
    .c(Mux_WB_memtoreg_data), 
    .en(forwardA), 
    .out(rs1orpc)
);

Mux3_1 Mux_ForwadingB (
    .a(ID_EX_rs2_data), 
    .b(EX_MEM_alu_csr_bujrd_data), 
    .c(Mux_WB_memtoreg_data), 
    .en(forwardB), 
    .out(rs2orimm)
);

Mux2_1 Mux_rs1_pc (
    .a(rs1orpc), 
    .b(ID_EX_pc), 
    .en(ID_EX_alusrc1), 
    .out(operand1)
);

Mux2_1 Mux_rs2_imm (
    .a(rs2orimm), 
    .b(ID_EX_imm), 
    .en(ID_EX_alusrc2), 
    .out(operand2)
);

ALU ALU (
    .ID_EX_fpu_on(ID_EX_fpu_on), 
    .opcode(ID_EX_opcode), 
    .func3(ID_EX_func3), 
    .func7_AL(ID_EX_func7_AL), 
    .func7_mul(ID_EX_func7_mul), 
    .operand1(operand1), 
    .operand2(operand2), 
    .alu_out(alu_out)
);

Mux3_1 Mux_ForwadingA2fpu (
    .a(ID_EX_rs1_data), 
    .b(EX_MEM_alu_csr_bujrd_data), 
    .c(read_data_reg), 
    .en(forwardA2fpu), 
    .out(rs1_fpu)
);

Mux3_1 Mux_ForwadingB2fpu (
    .a(ID_EX_rs2_data), 
    .b(EX_MEM_alu_csr_bujrd_data), 
    .c(read_data_reg), 
    .en(forwardB2fpu), 
    .out(rs2_fpu)
);


FPU FPU (
    .ID_EX_fpu_on(ID_EX_fpu_on), 
    .func5_sub(ID_EX_func5_sub), 
    .operand1(rs1_fpu), 
    .operand2(rs2_fpu), 
    .fp_out(fp_out)
);



// FP_ALU FPU(
//     .FP_inA(rs1_fpu), 
//     .FP_inB(rs2_fpu), 
//     .FPU_en(ID_EX_fpu_on), 
//     .FPU_op({1'b0,ID_EX_func5_sub}), 
//     .FPU_result(fp_out)
// );


Mux2_1 Mux_BJ (
    .a(ID_EX_pc), 
    .b(rs1orpc), 
    .en(ID_EX_bj), 
    .out(j_operand)
);

BJ_unit BJ_unit (
    .opcode(ID_EX_opcode), 
    .func3(ID_EX_func3), 
    .rs1(rs1orpc), 
    .rs2(rs2orimm), 
    .j_operand(j_operand), 
    .ID_EX_imm(ID_EX_imm), 
    .pc_branch_jump(pc_branch_jump), 
    .branch_taken(branch_taken),
    .jump_taken(jump_taken)
);

//****************** Lab2 NO INTERRUPT *************************//
// CSR CSR (
//     .clk(clk), 
//     .rst(rst), 
//     .func5_sub(ID_EX_func5_sub), 
//     .ID_EX_pc(ID_EX_pc), 
//     .CSR_rdinst(ID_EX_CSR_rdinst), 
//     .csr_out(csr_out),
//     .stall_CPU(stall_CPU),
//     .stall_hazard(stall_hazard),
//     .branch_taken(branch_taken)
// );
//**************************************************************//
//=================== Lab3 INTERRUPT CONTROLLER ========================//

CSR CSR(
    .clk(clk), 
    .rst(rst), 
    .pc_c(pc), 
    .pc_E(ID_EX_pc), 
    .rs1_data(rs1orpc),          //forwarding rs1_data
    .inst(ID_EX_inst), 
    .stall(), 
    .AXI_stall(stall_CPU), 
    .MEIP_en(MEIP_en), 
    .MTIP_en(MTIP_en), 
    .MEIP_end(MEIP_end), 
    .MTIP_end(MTIP_end), 
    .WFI_in(WFI_out),
    .csr_data(csr_out), 
    .pc_CSR(pc_CSR),
    .mie_out(mie), 
    .mtie_out(mtie), 
    .meie_out(meie)
);

//interrupt CU
INTERRUPT_CU INTERRUPT_CU(
    .clk(clk), 
    .rst(rst), 
    .inst(ID_EX_inst), 
    .inter_DMA(inter_DMA), 
    .inter_WDT(inter_WDT), 
    .mie_in(mie), 
    .mtie_in(mtie), 
    .meie_in(meie), 
    .AXI_stall(stall_CPU),
    .MEIP_en(MEIP_en), 
    .MEIP_end(MEIP_end), 
    .MTIP_en(MTIP_en), 
    .MTIP_end(MTIP_end), 
    .WFI_out(WFI_out),
    .WFI_pc_en(WFI_pc_en) 
);

//======================================================================//
Mux3_1 Mux_alu_csr_bujrd_data (
    .a(alu_out), 
    .b(csr_out), 
    .c(fp_out), 
    .en(ID_EX_alu_csr_bujrd), 
    .out(alu_csr_bujrd_data)
);  // 00: alu, 01: csr, 10: fpu, default: alu  

Reg_EX_MEM Reg_EX_MEM (
    .clk(clk), 
    .rst(rst), 
    .ID_EX_rd(ID_EX_rd), 
    .alu_csr_bujrd_data(alu_csr_bujrd_data), 
    .write_data(rs2orimm),
    .ID_EX_memread(ID_EX_memread),        
    .ID_EX_memwrite(ID_EX_memwrite),    
    .ID_EX_int_regwrite(ID_EX_int_regwrite),        
    .ID_EX_fp_regwrite(ID_EX_fp_regwrite),
    .ID_EX_memtoreg(ID_EX_memtoreg),
    .EX_MEM_memread(EX_MEM_memread),         
    .EX_MEM_memwrite(EX_MEM_memwrite),
    .EX_MEM_int_regwrite(EX_MEM_int_regwrite),        
    .EX_MEM_fp_regwrite(EX_MEM_fp_regwrite),
    .EX_MEM_memtoreg(EX_MEM_memtoreg),
    .EX_MEM_alu_csr_bujrd_data(EX_MEM_alu_csr_bujrd_data),
    .EX_MEM_write_data(EX_MEM_write_data),
    .EX_MEM_rd(EX_MEM_rd),
    .stall_CPU(stall_CPU)
);

/*************************************** <<<<<<<< *************************************************/
/*************************************** MEM stage*************************************************/
/*************************************** >>>>>>>> *************************************************/

SD SD (
    .EX_MEM_memwrite(EX_MEM_memwrite), 
    .last2(EX_MEM_alu_csr_bujrd_data[1:0]),
    .EX_MEM_write_data(EX_MEM_write_data), 
    .DM_WEB(DM_WEB),
    .DM_BWEB(DM_BWEB), 
    .DM_DI(DM_DI)
);


Reg_MEM_WB Reg_MEM_WB (
    .clk(clk), 
    .rst(rst),
    .EX_MEM_rd(EX_MEM_rd), 
    .EX_MEM_alu_csr_bujrd_data(EX_MEM_alu_csr_bujrd_data), 
    .EX_MEM_memread(EX_MEM_memread), 
    .read_data(read_data_reg),
    .EX_MEM_int_regwrite(EX_MEM_int_regwrite), 
    .EX_MEM_fp_regwrite(EX_MEM_fp_regwrite), 
    .EX_MEM_memtoreg(EX_MEM_memtoreg),
    .MEM_WB_int_regwrite(MEM_WB_int_regwrite), 
    .MEM_WB_fp_regwrite(MEM_WB_fp_regwrite), 
    .MEM_WB_memtoreg(MEM_WB_memtoreg),
    .MEM_WB_alu_csr_bujrd_data(MEM_WB_alu_csr_bujrd_data), 
    .MEM_WB_read_data(MEM_WB_read_data), 
    .MEM_WB_rd(MEM_WB_rd),
    .MEM_WB_memread(MEM_WB_memread),
    .stall_CPU(stall_CPU)
);

/*************************************** <<<<<<<< *************************************************/
/*************************************** WB stage *************************************************/
/*************************************** >>>>>>>> *************************************************/

LD LD (
    .MEM_WB_memread(EX_MEM_memread), 
    .DM_DO(DM_DO), 
    .read_data(read_data),
    .last2(EX_MEM_alu_csr_bujrd_data[1:0])
);

//for load data
always_ff @(posedge clk or posedge rst)
begin
	if(rst) begin
		load_data_r <= 32'b0;
		read_data_reg <= 32'b0;

	end	
	else begin
		if (stall_CPU) begin
			if (DM_READ_DONE) begin
			load_data_r <= read_data;
			read_data_reg <= read_data_reg;
			end
			else begin
			load_data_r <= load_data_r;
			read_data_reg <= read_data_reg;
			end
		end
		else begin
			load_data_r <= load_data_r;		
			read_data_reg <= load_data_r;
		end
	end			
end	

Mux2_1 Mux_MEM_WB_MEM2Reg (
    .a(read_data_reg), 
    .b(MEM_WB_alu_csr_bujrd_data), 
    .en(MEM_WB_memtoreg), 
    .out(Mux_WB_memtoreg_data)
);

/*************************************** <<<<<<<< *************************************************/
/************************************* Pipeline End ***********************************************/
/**************************************************************************************************/


assign IM_A = pc; 
assign DM_A = EX_MEM_alu_csr_bujrd_data;
 
always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            DM_WRITE   <= 1'd0; 
        end
        else 
            // DM_WRITE <= ID_EX_memwrite_1bit;
            DM_WRITE <= |ID_EX_memwrite;
    end
// assign DM_WRITE = |EX_MEM_memwrite;

always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            DM_READ   <= 1'd0; 
        end
        else 
        if (stall_CPU) begin
            if (DM_READ_DONE) begin
                DM_READ <= 1'd0;
            end
            else begin
                DM_READ <= DM_READ;
            end
        end 
        else 
        begin
            // DM_READ <= ID_EX_memread_1bit;
            DM_READ <= |ID_EX_memread;
        end
    end
// assign DM_READ = |EX_MEM_memread;

always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            IM_READ <= 1'b0; 
        end
        else 
            IM_READ <= 1'b1;
    end
// assign IM_READ = 1'b1;
assign IM_BWEB = 4'b0000;
assign IM_DI = {32{1'b0}};

endmodule

