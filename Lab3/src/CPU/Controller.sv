module Controller (
    input [6:0] dc_out_opcode,        // Opcode from instruction
    input [2:0] dc_out_func3,         // func3 field from instruction
    input       dc_out_func7_AL,      // ALU function selector
    input       dc_out_func7_mul,     // Multiply function selector  
    input       dc_out_func5_sub,     // Subtract function selector
    input       dc_out_CSR_rdinst,    // CSR instruction indicator
    output reg  Controller_alusrc1,   // EX stage: ALU source 1 select
    output reg  Controller_alusrc2,   // EX stage: ALU source 2 select
    output reg  Controller_bj,        // Branch/Jump control signal
    output reg  [1:0] Controller_alu_csr_bujrd, // Select between ALU, CSR, FPU for the result (01: ALU, 00: CSR, 10: FPU)
    output reg  [2:0] Controller_memread,      // MEM stage: memory read control signal
    output reg  [2:0] Controller_memwrite,     // MEM stage: memory write control signal
    output reg  Controller_int_regwrite,       // WB stage: write to integer register
    output reg  Controller_fp_regwrite,        // WB stage: write to floating-point register
    output reg  Controller_memtoreg,           // WB stage: select memory-to-register operation
    output reg  Controller_fprs1,              // Select FP register source 1
    output reg  Controller_fprs2,              // Select FP register source 2
    output reg  Controller_fpu_on             // Enable FPU operations

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
always_comb begin : Controller
begin
    case (dc_out_opcode)
        // FLW (Load Floating-Point Word)
        `OPCODE_FLW: begin
            Controller_fp_regwrite = 1'b1;  // Write to FP register
            Controller_int_regwrite = 1'b0;
            Controller_alu_csr_bujrd = 2'b00; // ALU operation
            Controller_memwrite = 3'b000;     // No memory write
            Controller_memread = 3'b111;      // Read 32-bit word from memory
            Controller_memtoreg = 1'b1;       // Load data to register
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b1;
            Controller_fpu_on = 1'b0;         // FPU off
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
        end

        // FSW (Store Floating-Point Word)
        `OPCODE_FSW: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b0;
            Controller_alu_csr_bujrd = 2'b00; // ALU operation
            Controller_memwrite = 3'b111;     // Write 32-bit word to memory
            Controller_memread = 3'b000;      // No memory read
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b1;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
        end

        // Load (Integer Load Instructions)
        `OPCODE_LOAD: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b1; // Write to integer register
            Controller_alu_csr_bujrd = 2'b00; // ALU operation
            Controller_memtoreg = 1'b1;       // Load data to register
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
            case(dc_out_func3) 
                3'b010: begin // LW (Load Word)
                    Controller_memwrite = 3'b000;     // No memory write
                    Controller_memread = 3'b111;      // Read 32-bit word from memory
                end
                3'b001: begin // LH (Load Halfword)
                    Controller_memwrite = 3'b000;     
                    Controller_memread = 3'b011;      // Read 16-bit halfword from memory
                end
                3'b000: begin // LB (Load Byte)
                    Controller_memwrite = 3'b000;     
                    Controller_memread = 3'b001;      // Read 8-bit byte from memory
                end
                3'b101: begin // LHU (Load Halfword Unsigned)
                    Controller_memwrite = 3'b000;     
                    Controller_memread = 3'b100;      // Read 16-bit unsigned halfword
                end
                3'b100: begin // LBU (Load Byte Unsigned)
                    Controller_memwrite = 3'b000;     
                    Controller_memread = 3'b110;      // Read 8-bit unsigned byte
                end
                default: begin
                    Controller_memwrite = 3'b000;     
                    Controller_memread = 3'b000;
                end
            endcase
        end

        // Store (Integer Store Instructions)
        `OPCODE_S_type: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b0;
            Controller_memtoreg = 1'b0;
            Controller_alu_csr_bujrd = 2'b00; // ALU operation
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
            case(dc_out_func3) 
                3'b010: begin // SW (Store Word)
                    Controller_memwrite = 3'b111;     // Write 32-bit word to memory
                    Controller_memread = 3'b000;
                end
                3'b001: begin // SH (Store Halfword)
                    Controller_memwrite = 3'b011;     // Write 16-bit halfword to memory
                    Controller_memread = 3'b000;
                end
                3'b000: begin // SB (Store Byte)
                    Controller_memwrite = 3'b001;     // Write 8-bit byte to memory
                    Controller_memread = 3'b000;
                end
                default: begin
                    Controller_memwrite = 3'b000;
                    Controller_memread = 3'b000;
                end
            endcase
        end

        // UJ-type (Unconditional Jump Instructions)
        `OPCODE_U_type_LUI, `OPCODE_U_type_AUIPC, `OPCODE_JALR: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b1; // Write to integer register
            Controller_alu_csr_bujrd = 2'b00; // ALU operation (BUJrd)
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b0;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
        end

        // JAL (Jump and Link)
        `OPCODE_J_type: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b1; // Write to integer register
            Controller_alu_csr_bujrd = 2'b00; // ALU operation (BUJrd)
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b0;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b1; // Enable branch/jump control
        end

        // Branch (Conditional Branch Instructions)
        `OPCODE_B_type: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b0;
            Controller_alu_csr_bujrd = 2'b00; // ALU operation (BUJrd)
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b1;
            Controller_bj= 1'b1; // Enable branch control
        end

        // ALU operation (I-type instructions)
        `OPCODE_I_type: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b1; // Write to integer register
            Controller_alu_csr_bujrd = 2'b00; // ALU operation
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
        end

        // ALU operation (R-type instructions)
        `OPCODE_R_type: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b1; // Write to integer register
            Controller_alu_csr_bujrd = 2'b00; // ALU operation
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b1;
            Controller_bj= 1'b0;
        end

        // CSR operation
        `OPCODE_CSR: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b1; // Write to integer register
            Controller_alu_csr_bujrd = 2'b01; // CSR operation
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b0;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
        end

        // FPU operation (e.g., FADD, FSUB)
        `OPCODE_FPU: begin
            Controller_fp_regwrite = 1'b1;
            Controller_int_regwrite = 1'b0; // No integer register write
            Controller_alu_csr_bujrd = 2'b10; // FPU operation
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b1;
            Controller_fprs2 = 1'b1;
            Controller_fpu_on = 1'b1;         // Enable FPU
            Controller_alusrc1 = 1'b1;
            Controller_alusrc2= 1'b1;
            Controller_bj= 1'b0;
        end

        // Default case
        default: begin
            Controller_fp_regwrite = 1'b0;
            Controller_int_regwrite = 1'b0;
            Controller_alu_csr_bujrd = 2'b00; // Default to ALU
            Controller_memwrite = 3'd0;
            Controller_memread = 3'd0;
            Controller_memtoreg = 1'b0;
            Controller_fprs1 = 1'b0;
            Controller_fprs2 = 1'b0;
            Controller_fpu_on = 1'b0;
            Controller_alusrc1 = 1'b0;
            Controller_alusrc2= 1'b0;
            Controller_bj= 1'b0;
        end
    endcase
end
end

endmodule
