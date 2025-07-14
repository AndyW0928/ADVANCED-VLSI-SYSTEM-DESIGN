// MEM/WB Pipeline Register Module
module Reg_MEM_WB (
    input clk,                          // Clock signal
    input rst,                          // Reset signal

    // Inputs from EX/MEM pipeline stage
    input [2:0] EX_MEM_memread,         // Memory read control signal from EX/MEM
    input [4:0] EX_MEM_rd,              // Destination register from EX/MEM stage (rd)
    input [31:0] EX_MEM_alu_csr_bujrd_data, // ALU result / CSR data / BUJ result from EX/MEM
    input [31:0] read_data,             // Data read from memory (MEM stage)

    // Control signals from EX/MEM stage (for write-back operations)
    input EX_MEM_int_regwrite,          // Integer register write control signal
    input EX_MEM_fp_regwrite,           // Floating-point register write control signal
    input EX_MEM_memtoreg,              // Memory-to-register control signal

    // Outputs for the MEM/WB pipeline stage (to the WB stage)
    output reg MEM_WB_int_regwrite,     // Integer register write control signal to WB
    output reg MEM_WB_fp_regwrite,      // Floating-point register write control signal to WB
    output reg MEM_WB_memtoreg,         // Memory-to-register control signal to WB

    // Data to be written back to the register file
    output reg [31:0] MEM_WB_alu_csr_bujrd_data, // Data from ALU/CSR/BUJ
    output reg [31:0] MEM_WB_read_data, // Data from memory to be written back

    // Destination register (rd) for forwarding in the WB stage
    output reg [4:0] MEM_WB_rd,        // Destination register to write back
    output reg [2:0] MEM_WB_memread,    // Memory read control signal to WB
    input stall_CPU
);

    // Always block triggered on positive edge of clock or reset
    always_ff @(posedge clk or posedge rst ) begin
        if (rst) begin
            // Reset all MEM/WB pipeline registers when reset is active
            MEM_WB_int_regwrite      <= 1'b0;
            MEM_WB_fp_regwrite       <= 1'b0;
            MEM_WB_memtoreg          <= 1'b0;
            MEM_WB_alu_csr_bujrd_data <= 32'd0;
            MEM_WB_read_data         <= 32'd0;
            MEM_WB_rd                <= 5'd0;
            MEM_WB_memread           <= 3'd0;
        end
        else if (stall_CPU) begin
            // Reset all MEM/WB pipeline registers when reset is active
            MEM_WB_int_regwrite      <= MEM_WB_int_regwrite;
            MEM_WB_fp_regwrite       <= MEM_WB_fp_regwrite;
            MEM_WB_memtoreg          <= MEM_WB_memtoreg;
            MEM_WB_alu_csr_bujrd_data <= MEM_WB_alu_csr_bujrd_data;
            MEM_WB_read_data         <= MEM_WB_read_data;
            MEM_WB_rd                <= MEM_WB_rd;
            MEM_WB_memread           <= MEM_WB_memread;
        end 
        else begin
            // Update MEM/WB pipeline registers with values from EX/MEM stage
            MEM_WB_int_regwrite      <= EX_MEM_int_regwrite;
            MEM_WB_fp_regwrite       <= EX_MEM_fp_regwrite;
            MEM_WB_memtoreg          <= EX_MEM_memtoreg;
            MEM_WB_alu_csr_bujrd_data <= EX_MEM_alu_csr_bujrd_data;
            MEM_WB_read_data         <= read_data;
            MEM_WB_rd                <= EX_MEM_rd;
            MEM_WB_memread           <= EX_MEM_memread;
        end
    end

endmodule
