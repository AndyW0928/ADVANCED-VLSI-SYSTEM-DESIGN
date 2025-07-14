module RegFile_Int (
    input clk,
    input rst,
    input wb_en_int,
    input [31:0] wb_data,
    input [4:0] rd_index,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    output logic [31:0] rs1_int_data_out,
    output logic [31:0] rs2_int_data_out,
    input stall_CPU
);
    // logic [31:0]data_rs1_reg;
    // logic [31:0]data_rs2_reg;
    integer i;
    reg [31:0] Int_registers [0:31]; // 32 registers each 32-bit wide

    assign rs1_int_data_out = Int_registers[rs1_index];
    assign rs2_int_data_out = Int_registers[rs2_index];

    always_ff @(posedge clk or posedge rst ) begin : Int_RegisterFile
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                Int_registers[i] <= 32'h0;
            end
        end 
        else if (stall_CPU) begin
            Int_registers[rd_index] <= Int_registers[rd_index];
        end
        else if (wb_en_int && rd_index != 5'd0) begin
            // Write-back operation: Update the register 
            // if write enable is active and rd_index is not x0
            Int_registers[rd_index] <= wb_data;
        end
    end

endmodule
