//ALU 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Computation Instructions:
// - Register-Register: add, sub, slt, sltu, sll, srl, sra, xor, or, and, mul, mulh, mulhsu, mulhu, fadd.s, fsub.s
// - Register-Immediate: addi, slti, sltiu, slli, srli, srai, xori, ori, andi
// - Long Immediate: lui, auipc

// Arithmetic Operations:
// - Addition: add, addi
// - Subtraction/Comparison: sub, slt, sltu, slti, sltiu

// Shift Operations:
// - Logical Left Shift: sll, slli
// - Logical Right Shift: srl, srli
// - Arithmetic Right Shift: sra, srai

// Logical Operations:
// - XOR: xor, xori
// - OR: or, ori
// - AND: and, andi

// Load and Store Instructions:
// - Load: lb, lh, lw, lbu, lhu, flw
// - Store: sb, sh, sw, fsw

// Control Transfer Instructions:
// - Unconditional Jump: jal, jalr
// - Conditional Branch: beq, bne, blt, bge, bltu, bgeu

///////////// CSR /////////////////
// CSR Operation:
// - Instruction count : RDINSTRET, RDINSTRETH
// - Clock count : RDCYCLE, RDCYCLEH

///////////// M type /////////////////
// Multiply–accumulate Operation:
// - Unsigned: mul, mulhu
// - signed: mulh, mulhsu

///////////// F type /////////////////
// Floating-point Operation:
// - Addition: fadd.s
// - Subtraction: fsub.s
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ALU (
    input [6:0] opcode,            // Instruction opcode
    input [2:0] func3,             // Function field (func3) of the instruction
    input func7_AL,                // Distinguishes ALU operations (e.g., subtraction from addition)
    input func7_mul,               // Distinguishes multiplication instructions
    input [31:0] operand1,         // First operand
    input [31:0] operand2,         // Second operand
    input ID_EX_fpu_on,            // Flag indicating if the FPU (floating point unit) is active
    output logic [31:0] alu_out    // ALU output result
);
`define OPCODE_LOAD   		 7'b000_0011
`define OPCODE_I_type 		 7'b001_0011
`define OPCODE_JALR   		 7'b110_0111
`define OPCODE_S_type 		 7'b010_0011
`define OPCODE_B_type 		 7'b110_0011
`define OPCODE_U_type_AUIPC  7'b001_0111
`define OPCODE_U_type_LUI    7'b011_0111
`define OPCODE_J_type    	 7'b110_1111
`define OPCODE_R_type 		 7'b011_0011
`define OPCODE_CSR		 7'b111_0011
`define OPCODE_FPU 		 7'b101_0011
`define OPCODE_FSW 		 7'b010_0111
`define OPCODE_FLW 		 7'b000_0111
    logic [63:0] Mulout;  // Intermediate storage for multiplication result

    // ALU operations based on the opcode and func3
    always_comb begin : ALU
        if (!ID_EX_fpu_on) begin   // If FPU is not active, perform integer ALU operations
            Mulout = 64'b0;        // Initialize Mulout to zero
            case (opcode)
                // Arithmetic and logic operations (R-type and I-type)
                `OPCODE_R_type, `OPCODE_I_type: begin
                    if (opcode == `OPCODE_R_type && func7_mul) begin
                        // Handling multiplication instructions
                        case (func3)
                            3'b000: begin // Lower 32 bits of multiplication (unsigned)
                                Mulout = (operand1) * (operand2);
                                alu_out = Mulout[31:0];
                            end
                            3'b011: begin // Upper 32 bits of multiplication (unsigned)
                                Mulout = (operand1) * (operand2);
                                alu_out = Mulout[63:32];
                            end
                            3'b010: begin // Upper 32 bits of signed * unsigned multiplication
                                Mulout = $signed({{32{operand1[31]}},operand1}) * (operand2);
                                alu_out = Mulout[63:32];
                            end
                            3'b001: begin // Upper 32 bits of signed multiplication
                                alu_out = $signed(operand1) * $signed(operand2); // Mulout[63:32] is not used
                            end
                            default: begin
                                alu_out = 32'b0; // Default case for unsupported multiplication operations
                            end
                        endcase
                    end else begin
                        // Handling arithmetic and logic instructions
                        case (func3)
                            3'b000: begin
                                if (opcode == `OPCODE_I_type) begin // addi instruction
                                    alu_out = operand1 + operand2;
                                end else begin // add or sub
                                    if (func7_AL) begin // sub
                                        alu_out = operand1 - operand2;
                                    end else begin // add
                                        alu_out = operand1 + operand2;
                                    end
                                end
                            end
                            3'b010: alu_out = ($signed(operand1) < $signed(operand2)) ? 1 : 0; // slt, slti
                            3'b011: alu_out = ((operand1) < (operand2)) ? 1 : 0; // sltu, sltiu
                            3'b001: alu_out = operand1 << (operand2 & 32'b11111); // sll, slli
                            3'b101: begin
                                if (func7_AL) alu_out = $signed(operand1) >>> (operand2 & 32'b11111); // sra, srai
                                else alu_out = operand1 >> (operand2 & 32'b11111); // srl, srli
                            end
                            3'b110: alu_out = operand1 | operand2; // or, ori
                            3'b100: alu_out = operand1 ^ operand2; // xor, xori
                            3'b111: alu_out = operand1 & operand2; // and, andi
                        endcase
                    end
                end

                // U-type instructions
                `OPCODE_U_type_LUI: alu_out = operand2;                // lui
                `OPCODE_U_type_AUIPC: alu_out = operand1 + operand2;     // auipc

                // Load and store instructions (lb, lbu, lh, lhu, lw, sb, sh, sw)
                `OPCODE_LOAD, `OPCODE_S_type: alu_out = operand1 + operand2;

                // Jump instructions (jal, jalr)
                `OPCODE_J_type, `OPCODE_JALR: alu_out = operand1 + 32'd4;

                // Floating-point load and store instructions (flw, fsw)
                `OPCODE_FLW, `OPCODE_FSW: alu_out = operand1 + operand2;

                default: alu_out = 32'b0; // Default case for unsupported instructions
            endcase
        end else begin
            alu_out = 32'b0;   // Set output to zero if FPU is active
            Mulout = 64'b0;    // Reset multiplication result
        end
    end

endmodule


