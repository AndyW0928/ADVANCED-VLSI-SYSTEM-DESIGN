// Branch or Jump unit
module BJ_unit (
    input  [6:0] opcode,              // Instruction opcode
    input  [2:0] func3,               // Function field (func3) of the instruction
    input  [31:0] rs1,                // First source register value
    input  [31:0] rs2,                // Second source register value
    input  [31:0] j_operand,          // Jump operand (PC + immediate)
    input  [31:0] ID_EX_imm,          // Immediate value from the ID/EX stage
    output logic [31:0] pc_branch_jump,     // Calculated branch/jump target address
    output logic branch_taken,         // Indicates if the branch is taken
    output logic jump_taken,
    input logic inter_WDT
);

    // Calculate the branch or jump target address by adding jump operand and immediate
    // and aligning it by masking the least significant bit to zero
    assign pc_branch_jump = (j_operand + ID_EX_imm) ;//& (~32'd1);

    always_comb begin : BJ_unit
        branch_taken = 1'b0; // Default: branch not taken
        jump_taken = 1'b0; 
        // pc_branch_jump = 32'b0;
        // if (inter_WDT)
        // begin
        //     branch_taken = 1'b0;
        //     jump_taken = 1'b0;
        //     pc_branch_jump = 32'b0;
        // end
        // else begin
            // pc_branch_jump = (j_operand + ID_EX_imm) ;
            case (opcode)
                // Jump instructions (JAL and JALR)
                7'b1101111, 7'b1100111: jump_taken = 1'b1; // Always take the jump
                // Conditional branch instructions
                7'b1100011: begin   
                    case (func3)
                        // BEQ: Branch if equal
                        3'b000: branch_taken = (rs1 == rs2) ? 1'b1 : 1'b0; 
                        // BNE: Branch if not equal
                        3'b001: branch_taken = (rs1 != rs2) ? 1'b1 : 1'b0;
                        // BLT: Branch if less than (signed comparison)
                        3'b100: branch_taken = ($signed(rs1) < $signed(rs2)) ? 1'b1 : 1'b0;
                        // BGE: Branch if greater than or equal (signed comparison)
                        3'b101: branch_taken = ($signed(rs1) >= $signed(rs2)) ? 1'b1 : 1'b0;
                        // BLTU: Branch if less than (unsigned comparison)
                        3'b110: branch_taken = ((rs1) < (rs2)) ? 1'b1 : 1'b0;
                        // BGEU: Branch if greater than or equal (unsigned comparison)
                        3'b111: branch_taken = ((rs1) >= (rs2)) ? 1'b1 : 1'b0;
                        default:branch_taken = 1'b0; // Default: no branch taken for unknown func3 values
                    endcase
                end
                default: begin
                    branch_taken = 1'b0; // No branch or jump for unsupported instructions
                    jump_taken = 1'b0; 
                end
            endcase
        // end
    end
endmodule
