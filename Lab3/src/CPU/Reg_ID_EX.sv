// ID/EX Pipeline Register Module
module Reg_ID_EX (
    input clk,                      // Clock signal
    input rst,                      // Reset signal
    input stall_hazard,             // Stall signal to hold pipeline values
    input jump_taken,             // Signal to flush the pipeline when a branch is taken
    input IF_ID_branch_pred,
    // Inputs from IF/ID stage
    input [31:0] IF_ID_inst,
    input [31:0] IF_ID_pc,         // Program counter value from IF/ID register
    input [4:0] IF_ID_rs,          // Register rs from IF/ID (for forwarding)
    input [4:0] IF_ID_rt,          // Register rt from IF/ID
    input [4:0] IF_ID_rd,          // Register rd from IF/ID

    // Data for registers rs1, rs2 and immediate value
    input [31:0] rs1_data,         // Data for rs1 register
    input [31:0] rs2_data,         // Data for rs2 register
    input [31:0] imm_ext_out,      // Immediate value from the instruction

    // Control signals for the ALU and other operations
    input [6:0] dc_out_opcode, // ALU opcode
    input [2:0] dc_out_func3,  // Function code for ALU operations
    input dc_out_func7_AL,     // Control signal for ALU (AL operations)
    input dc_out_func7_mul,    // Control signal for multiplier
    input dc_out_func5_sub,    // Control signal for subtraction
    input dc_out_CSR_rdinst,   // Control signal for CSR read instruction

    input Controller_alusrc1,      // ALU source control signal 1
    input Controller_alusrc2,      // ALU source control signal 2
    input Controller_bj,           // Branch signal

    input [1:0] Controller_alu_csr_bujrd, // ALU/CSR branch control signals

    // Control signals for MEM stage
    input [2:0] Controller_memread,   // Memory read control signal
    input [2:0] Controller_memwrite,  // Memory write control signal

    // Control signals for WB stage
    input Controller_int_regwrite,    // Integer register write signal
    input Controller_fp_regwrite,     // Floating-point register write signal
    input Controller_memtoreg,        // Memory-to-register control signal

    input reg Controller_fprs1,       // Floating-point register read signal for rs1
    input reg Controller_fprs2,       // Floating-point register read signal for rs2
    input reg Controller_fpu_on,      // Floating-point unit on/off signal

    // Outputs for the ID/EX pipeline register
    output reg [4:0] ID_EX_rs,        // Forwarding register rs
    output reg [4:0] ID_EX_rt,        // Forwarding register rt
    output reg [4:0] ID_EX_rd,        // Forwarding register rd

    output reg [6:0] ID_EX_opcode,    // ALU opcode
    output reg [2:0] ID_EX_func3,     // Function code for ALU
    output reg ID_EX_func7_AL,        // ALU AL control signal
    output reg ID_EX_func7_mul,       // Multiplier control signal
    output reg ID_EX_func5_sub,       // Subtraction control signal
    output reg ID_EX_CSR_rdinst,      // CSR read instruction signal

    output reg ID_EX_alusrc1,         // ALU source control signal 1
    output reg ID_EX_alusrc2,         // ALU source control signal 2
    output reg ID_EX_bj,              // Branch control signal
    output reg [1:0] ID_EX_alu_csr_bujrd, // ALU/CSR branch control signals

    // Outputs for the MEM stage
    output reg [2:0] ID_EX_memread,  // Memory read control signal
    output reg [2:0] ID_EX_memwrite, // Memory write control signal
    output logic  ID_EX_memread_1bit, ID_EX_memwrite_1bit,

    // Outputs for the WB stage
    output reg ID_EX_int_regwrite,    // Integer register write control signal
    output reg ID_EX_fp_regwrite,     // Floating-point register write control signal
    output reg ID_EX_memtoreg,        // Memory-to-register control signal

    // Data outputs
    output reg [31:0] ID_EX_inst,
    output reg [31:0] ID_EX_rs1_data,  // Data for rs1
    output reg [31:0] ID_EX_rs2_data,  // Data for rs2
    output reg [31:0] ID_EX_imm,       // Immediate value
    output reg [31:0] ID_EX_pc,        // Program counter value
    output logic ID_EX_branch_pred,
    // Floating-point related outputs
    output reg ID_EX_fprs1,           // Floating-point register read for rs1
    output reg ID_EX_fprs2,           // Floating-point register read for rs2
    output reg ID_EX_fpu_on,           // Floating-point unit control signal
    input stall_CPU,
    input logic MEIP_en, MEIP_end,
    input logic WFI_pc_en,
    input nt_pt,
    input t_pnt
);

    // Always block triggered on the positive edge of clock or reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all the ID/EX register values on reset signal
            ID_EX_rs         <= 5'd0;
            ID_EX_rt         <= 5'd0;
            ID_EX_rd         <= 5'd0;
            ID_EX_opcode     <= 7'd0;
            ID_EX_func3      <= 3'd0;
            ID_EX_func7_AL   <= 1'b0;
            ID_EX_func7_mul  <= 1'b0;
            ID_EX_func5_sub  <= 1'b0;
            ID_EX_CSR_rdinst <= 1'b0;
            ID_EX_alusrc1    <= 1'b0;
            ID_EX_alusrc2    <= 1'b0;
            ID_EX_bj         <= 1'b0;
            ID_EX_alu_csr_bujrd <= 2'd0;
            ID_EX_memread    <= 3'd0;
            ID_EX_memwrite   <= 3'd0;
            ID_EX_memread_1bit <= 1'b0; 
            ID_EX_memwrite_1bit <= 1'b0;
            ID_EX_int_regwrite   <= 1'b0;
            ID_EX_fp_regwrite    <= 1'b0;
            ID_EX_memtoreg   <= 1'b0;
            ID_EX_rs1_data   <= 32'd0;
            ID_EX_rs2_data   <= 32'd0;
            ID_EX_imm        <= 32'd0;
            ID_EX_pc         <= 32'd0;
            ID_EX_inst       <= 32'd0;
            ID_EX_fprs1      <= 1'b0;
            ID_EX_fprs2      <= 1'b0;
            ID_EX_fpu_on     <= 1'b0;
            ID_EX_branch_pred <= 1'b0;
        end
        else if (stall_CPU) begin
            // Reset values during stall or branch taken conditions
            ID_EX_rs         <= ID_EX_rs;
            ID_EX_rt         <= ID_EX_rt;
            ID_EX_rd         <= ID_EX_rd;
            ID_EX_opcode     <= ID_EX_opcode;
            ID_EX_func3      <= ID_EX_func3;
            ID_EX_func7_AL   <= ID_EX_func7_AL;
            ID_EX_func7_mul  <= ID_EX_func7_mul;
            ID_EX_func5_sub  <= ID_EX_func5_sub;
            ID_EX_CSR_rdinst <= ID_EX_CSR_rdinst;
            ID_EX_alusrc1    <= ID_EX_alusrc1;
            ID_EX_alusrc2    <= ID_EX_alusrc2;
            ID_EX_bj         <= ID_EX_bj;
            ID_EX_alu_csr_bujrd <= ID_EX_alu_csr_bujrd;
            ID_EX_memread    <= ID_EX_memread;
            ID_EX_memwrite   <= ID_EX_memwrite;
            ID_EX_memread_1bit <= ID_EX_memread_1bit; 
            ID_EX_memwrite_1bit <= ID_EX_memread_1bit;
            ID_EX_int_regwrite   <= ID_EX_int_regwrite;
            ID_EX_fp_regwrite    <= ID_EX_fp_regwrite;
            ID_EX_memtoreg   <= ID_EX_memtoreg;
            ID_EX_rs1_data   <= ID_EX_rs1_data;
            ID_EX_rs2_data   <= ID_EX_rs2_data;
            ID_EX_imm        <= ID_EX_imm;
            ID_EX_pc         <= ID_EX_pc;
            ID_EX_inst       <= ID_EX_inst;
            ID_EX_fprs1      <= ID_EX_fprs1;
            ID_EX_fprs2      <= ID_EX_fprs2;
            ID_EX_fpu_on     <= ID_EX_fpu_on;
            ID_EX_branch_pred <= ID_EX_branch_pred;
        end
        else begin
            if (stall_hazard ) begin
                // Reset values during stall or branch taken conditions
            ID_EX_rs         <= 5'd0;
            ID_EX_rt         <= 5'd0;
            ID_EX_rd         <= 5'd0;
            ID_EX_opcode     <= 7'd0;
            ID_EX_func3      <= 3'd0;
            ID_EX_func7_AL   <= 1'b0;
            ID_EX_func7_mul  <= 1'b0;
            ID_EX_func5_sub  <= 1'b0;
            ID_EX_CSR_rdinst <= 1'b0;
            ID_EX_alusrc1    <= 1'b0;
            ID_EX_alusrc2    <= 1'b0;
            ID_EX_bj         <= 1'b0;
            ID_EX_alu_csr_bujrd <= 2'd0;
            ID_EX_memread    <= 3'd0;
            ID_EX_memwrite   <= 3'd0;
            ID_EX_memread_1bit <= 1'b0; 
            ID_EX_memwrite_1bit <= 1'b0;
            ID_EX_int_regwrite   <= 1'b0;
            ID_EX_fp_regwrite    <= 1'b0;
            ID_EX_memtoreg   <= 1'b0;
            ID_EX_rs1_data   <= 32'd0;
            ID_EX_rs2_data   <= 32'd0;
            ID_EX_imm        <= 32'd0;
            ID_EX_pc         <= 32'd0;
            ID_EX_inst       <= 32'd0;
            ID_EX_fprs1      <= 1'b0;
            ID_EX_fprs2      <= 1'b0;
            ID_EX_fpu_on     <= 1'b0;
            ID_EX_branch_pred <= 1'b0;
            end 
            else if (jump_taken ||t_pnt || nt_pt || WFI_pc_en || MEIP_en || MEIP_end) begin
                // Reset values during stall or branch taken conditions
                ID_EX_rs         <= 5'd0;
                ID_EX_rt         <= 5'd0;
                ID_EX_rd         <= 5'd0;
                ID_EX_opcode     <= 7'd0;
                ID_EX_func3      <= 3'd0;
                ID_EX_func7_AL   <= 1'b0;
                ID_EX_func7_mul  <= 1'b0;
                ID_EX_func5_sub  <= 1'b0;
                ID_EX_CSR_rdinst <= 1'b0;
                ID_EX_alusrc1    <= 1'b0;
                ID_EX_alusrc2    <= 1'b0;
                ID_EX_bj         <= 1'b0;
                ID_EX_alu_csr_bujrd <= 2'd0;
                ID_EX_memread    <= 3'd0;
                ID_EX_memwrite   <= 3'd0;
                ID_EX_memread_1bit <= 1'b0; 
                ID_EX_memwrite_1bit <= 1'b0;
                ID_EX_int_regwrite   <= 1'b0;
                ID_EX_fp_regwrite    <= 1'b0;
                ID_EX_memtoreg   <= 1'b0;
                ID_EX_rs1_data   <= 32'd0;
                ID_EX_rs2_data   <= 32'd0;
                ID_EX_imm        <= 32'd0;
                ID_EX_pc         <= 32'd0;
                ID_EX_inst       <= 32'd0;
                ID_EX_fprs1      <= 1'b0;
                ID_EX_fprs2      <= 1'b0;
                ID_EX_fpu_on     <= 1'b0;
                ID_EX_branch_pred <= 1'b0;
            end
            else begin
                // Pass values from IF/ID and control inputs to ID/EX registers
                ID_EX_rs         <= IF_ID_rs;
                ID_EX_rt         <= IF_ID_rt;
                ID_EX_rd         <= IF_ID_rd;
                ID_EX_opcode     <= dc_out_opcode;
                ID_EX_func3      <= dc_out_func3;
                ID_EX_func7_AL   <= dc_out_func7_AL;
                ID_EX_func7_mul  <= dc_out_func7_mul;
                ID_EX_func5_sub  <= dc_out_func5_sub;
                ID_EX_CSR_rdinst <= dc_out_CSR_rdinst;
                ID_EX_alusrc1    <= Controller_alusrc1;
                ID_EX_alusrc2    <= Controller_alusrc2;
                ID_EX_bj         <= Controller_bj;
                ID_EX_alu_csr_bujrd <= Controller_alu_csr_bujrd;
                ID_EX_memread    <= Controller_memread;
                ID_EX_memwrite   <= Controller_memwrite;
                ID_EX_memread_1bit <= |Controller_memread; 
                ID_EX_memwrite_1bit <= |Controller_memwrite;
                ID_EX_int_regwrite <= Controller_int_regwrite;
                ID_EX_fp_regwrite <= Controller_fp_regwrite;
                ID_EX_memtoreg   <= Controller_memtoreg;
                ID_EX_rs1_data   <= rs1_data;
                ID_EX_rs2_data   <= rs2_data;
                ID_EX_imm        <= imm_ext_out;
                ID_EX_pc         <= IF_ID_pc;
                ID_EX_inst       <= IF_ID_inst;
                ID_EX_fprs1      <= Controller_fprs1;
                ID_EX_fprs2      <= Controller_fprs2;
                ID_EX_fpu_on     <= Controller_fpu_on;
                ID_EX_branch_pred <= IF_ID_branch_pred;
            end
        end
    end

endmodule
