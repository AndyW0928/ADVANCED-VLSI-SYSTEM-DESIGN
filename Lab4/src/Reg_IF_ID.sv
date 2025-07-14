// IF/ID Pipeline Register Module
module Reg_IF_ID(
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input stall_hazard,         // Stall signal to hold pipeline values
    input jump_taken,         // Signal to flush the pipeline when a branch is taken
    input branch_pred,
    input [31:0] pc,            // Program counter value from IF stage
    input [31:0] inst,          // Instruction fetched in IF stage
    output reg [31:0] IF_ID_pc, // Program counter to be passed to ID stage
    output reg [31:0] IF_ID_inst, // Instruction to be passed to ID stage
    output logic IF_ID_branch_pred,
    input stall_CPU,
    input logic MEIP_en, MEIP_end,MTIP_en,
    input logic WFI_pc_en,
    input nt_pt,
    input t_pnt
);

    // Always block triggered on the positive edge of clock or reset
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset IF/ID register when reset is high
            IF_ID_pc   <= 32'd0;  // Reset program counter to 0
            IF_ID_inst <= 32'd0;  // Reset instruction to 0
            IF_ID_branch_pred <= 1'd0;
        end
        else if (stall_CPU) begin
            // Reset IF/ID register when reset is high
            IF_ID_pc   <= IF_ID_pc;  // Reset program counter to 0
            IF_ID_inst <= IF_ID_inst;  // Reset instruction to 0
            IF_ID_branch_pred <= IF_ID_branch_pred;
        end 
        else begin
            if (stall_hazard) begin
                // Hold previous values when there is a stall
                IF_ID_pc   <= IF_ID_pc; // Keep the previous program counter
                IF_ID_inst <= IF_ID_inst;     // Keep the current instruction
                IF_ID_branch_pred <= IF_ID_branch_pred;
            end
            else if (jump_taken /*||t_pnt || nt_pt */|| WFI_pc_en || MEIP_en || MEIP_end || MTIP_en) begin
                // Flush pipeline when a branch is taken (set to 0)
                IF_ID_pc   <= 32'd0;    // Flush program counter
                IF_ID_inst <= 32'd0;    // Flush instruction
                IF_ID_branch_pred <= 1'd0;
            end
            else begin
                // Update IF/ID register with new values
                IF_ID_pc   <= pc;      // Pass program counter to ID stage
                IF_ID_inst <= inst;    // Pass instruction to ID stage
                IF_ID_branch_pred <= branch_pred;
            end
        end
    end

endmodule
