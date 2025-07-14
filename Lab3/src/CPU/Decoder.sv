// Instruction Decoder
module Decoder (
    input  [31:0] inst,
    output [6:0] dc_out_opcode,
    output [2:0] dc_out_func3,
    output       dc_out_func7_AL,
    output       dc_out_func7_mul,  
    output       dc_out_func5_sub,
    output       dc_out_CSR_rdinst,
    output [4:0] dc_out_rs1_index,
    output [4:0] dc_out_rs2_index,
    output [4:0] dc_out_rd_index
);

    assign dc_out_opcode       = inst[6:0];   // Extract opcode
    assign dc_out_func3        = inst[14:12]; // Extract func3
    assign dc_out_func7_AL     = inst[30];    // Extract func7 (most commonly used 7th bit function code)
    assign dc_out_func7_mul    = inst[25];    // Extract inst[25] for mul or other instruction determination
    assign dc_out_func5_sub    = inst[27];    // Extract inst[27] for Floating-point fadd or fsub //CSR for upper or lower part
    assign dc_out_CSR_rdinst   = inst[21];    // Extract inst[21] for CSR RDINSTRET or RDCYCLE
    assign dc_out_rs1_index    = inst[19:15]; // Extract rs1 register index
    assign dc_out_rs2_index    = inst[24:20]; // Extract rs2 register index
    assign dc_out_rd_index     = inst[11:7];  // Extract rd register index

endmodule
