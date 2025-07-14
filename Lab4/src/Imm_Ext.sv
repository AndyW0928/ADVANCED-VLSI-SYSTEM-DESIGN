// Immediate Extension Unit
// Extends immediate values based on instruction type
module Imm_Ext (
    input [31:0] inst,            // 32-bit instruction input
    output reg [31:0] imm_ext_out // 32-bit extended immediate output
);

    // Define instruction types
    localparam   R_type    = 5'b01100,
                 I_type    = 5'b00100,
                 U_lui     = 5'b01101,
                 U_auipc   = 5'b00101,
                 I_jalr    = 5'b11001,
                 J_jal     = 5'b11011,
                 B_type    = 5'b11000,
                 I_Load    = 5'b00000,
                 Store     = 5'b01000,
                 // Floating-point types
                 FLW       = 5'b00001,
                 FSW       = 5'b01001,
                 F_type    = 5'b10100,
                 // CSR instruction type
                 CSR       = 5'b11100;

    // Extract fields from instruction for different immediate types
    wire [19:0] upper_imm  = inst[31:12];   // Upper 20 bits for U-type
    wire [11:0] i_imm      = inst[31:20];   // Immediate for I-type
    wire [11:0] s_imm      = {inst[31:25], inst[11:7]};  // Store immediate (S-type)
    wire [12:0] b_imm      = {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};  // Branch immediate (B-type)
    wire [20:0] j_imm      = {inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};  // JAL immediate (J-type)

    // Immediate extension based on instruction type
    always_comb begin : Imm_Ext
        case (inst[6:2]) // Instruction opcode field
            I_type, I_Load, I_jalr, CSR, FLW: 
                imm_ext_out = {{20{i_imm[11]}}, i_imm};  // Sign-extend I-type and related instructions
            Store, FSW: 
                imm_ext_out = {{20{s_imm[11]}}, s_imm};  // Sign-extend S-type (Store)
            B_type: 
                imm_ext_out = {{19{b_imm[12]}}, b_imm};  // Sign-extend B-type (Branch)
            U_lui, U_auipc: 
                imm_ext_out = {upper_imm, 12'b0};        // No sign-extension for U-type
            J_jal: 
                imm_ext_out = {{11{j_imm[19]}}, j_imm};  // Sign-extend J-type (JAL)
            default: 
                imm_ext_out = 32'b0;  // Default case for unsupported instruction types
        endcase
    end

endmodule