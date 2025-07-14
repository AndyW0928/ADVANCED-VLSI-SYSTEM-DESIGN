module RegFile_FP (
    input clk,
    input rst,
    input wb_en_fp,
    input [31:0] wb_data,
    input [4:0] rd_index,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    output logic [31:0] rs1_fp_data_out,
    output logic [31:0] rs2_fp_data_out,
    input stall_CPU
);
    // logic [31:0]data_rs1fp_reg;
    // logic [31:0]data_rs2fp_reg;
    integer i;
    reg [31:0] FP_registers [0:31]; // 32 registers each 32-bit wide

    // Output the values of the specified registers
    assign rs1_fp_data_out = FP_registers[rs1_index];
    assign rs2_fp_data_out = FP_registers[rs2_index];

    always_ff @(posedge clk or posedge rst ) begin : FP_RegisterFile
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                FP_registers[i] <= 32'h0;
            end
        end else if (stall_CPU) begin
            FP_registers[rd_index] <= FP_registers[rd_index];
        end else if (wb_en_fp) begin
            FP_registers[rd_index] <= wb_data;
        end
    end
endmodule
