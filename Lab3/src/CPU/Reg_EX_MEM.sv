// EX/MEM Pipeline Register Module
module Reg_EX_MEM (
    input clk,                          // Clock signal
    input rst,                          // Reset signal

    // Inputs from ID/EX pipeline stage
    input [4:0] ID_EX_rd,               // Destination register (rd) from ID/EX stage

    // Data signals to be passed to MEM stage
    input [31:0] alu_csr_bujrd_data,   // ALU result / CSR data / BUJ result
    input [31:0] write_data,            // Data to be written back to register file

    // Control signals from ID/EX stage (for memory operations)
    input [2:0] ID_EX_memread,          // Memory read control signal
    input [2:0] ID_EX_memwrite,         // Memory write control signal

    // Control signals from ID/EX stage (for write-back operations)
    input ID_EX_int_regwrite,           // Integer register write control signal
    input ID_EX_fp_regwrite,            // Floating-point register write control signal
    input ID_EX_memtoreg,               // Memory-to-register control signal

    // Outputs for the EX/MEM pipeline stage
    output reg [2:0] EX_MEM_memread,    // Memory read control signal
    output reg [2:0] EX_MEM_memwrite,   // Memory write control signal
    output reg EX_MEM_int_regwrite,     // Integer register write control signal
    output reg EX_MEM_fp_regwrite,      // Floating-point register write control signal
    output reg EX_MEM_memtoreg,         // Memory-to-register control signal

    // Data outputs for the MEM stage
    output reg [31:0] EX_MEM_alu_csr_bujrd_data, // Data from ALU/CSR/BUJ operation
    output reg [31:0] EX_MEM_write_data,         // Data to be written to memory or register file

    // Destination register (rd)
    output reg [4:0] EX_MEM_rd,               // Destination register to write back to
    input stall_CPU
);

    // Always block triggered on positive edge of clock or reset
    always_ff @(posedge clk or posedge rst ) begin
        if (rst) begin
            // Reset all EX/MEM pipeline registers when reset is active
            EX_MEM_memread          <= 3'd0;
            EX_MEM_memwrite         <= 3'd0;
            EX_MEM_int_regwrite     <= 1'b0;
            EX_MEM_fp_regwrite      <= 1'b0;
            EX_MEM_memtoreg         <= 1'b0;
            EX_MEM_alu_csr_bujrd_data <= 32'd0;
            EX_MEM_write_data       <= 32'd0;
            EX_MEM_rd               <= 5'd0;
        end 
        else if (stall_CPU) begin
            // Reset all EX/MEM pipeline registers when reset is active
            EX_MEM_memread          <= EX_MEM_memread;
            EX_MEM_memwrite         <= EX_MEM_memwrite;
            EX_MEM_int_regwrite     <= EX_MEM_int_regwrite;
            EX_MEM_fp_regwrite      <= EX_MEM_fp_regwrite;
            EX_MEM_memtoreg         <= EX_MEM_memtoreg;
            EX_MEM_alu_csr_bujrd_data <= EX_MEM_alu_csr_bujrd_data;
            EX_MEM_write_data       <= EX_MEM_write_data;
            EX_MEM_rd               <= EX_MEM_rd;
        end
        else begin
            // Update EX/MEM pipeline registers with values from the ID/EX stage
            EX_MEM_memread          <= ID_EX_memread;
            EX_MEM_memwrite         <= ID_EX_memwrite;
            EX_MEM_int_regwrite     <= ID_EX_int_regwrite;
            EX_MEM_fp_regwrite      <= ID_EX_fp_regwrite;
            EX_MEM_memtoreg         <= ID_EX_memtoreg;
            EX_MEM_alu_csr_bujrd_data <= alu_csr_bujrd_data;
            EX_MEM_write_data       <= write_data;
            EX_MEM_rd               <= ID_EX_rd;
        end
    end

endmodule
