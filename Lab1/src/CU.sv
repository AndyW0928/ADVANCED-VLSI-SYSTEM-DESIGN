//control unit
module CU(op, func7, func5, func3, CSR_func, 
ID_stall, pc_D, 
ALU_op, ALU_en, FPU_en, IMM_Src, B_Src, J_Src, RF_write, FPRF_write, MEM_data_Src, WB_Src, MEM_read, MEM_read_Src, MEM_write,  MEM_write_Src, PC_contr, CSR_Src, F_Src);
    
input logic [6:0] op;
input logic [1:0] func7;
input logic func5;
input logic [2:0] func3;
input logic [1:0] CSR_func;

input logic ID_stall;
input logic [31:0] pc_D;

output logic [4:0] ALU_op;
output logic ALU_en;
output logic FPU_en;
output logic IMM_Src;
output logic B_Src;
output logic J_Src;
output logic RF_write;
output logic FPRF_write;
output logic [2:0] MEM_data_Src;
output logic [2:0] WB_Src;
output logic MEM_read;
output logic [2:0] MEM_read_Src;
output logic MEM_write;
output logic [2:0] MEM_write_Src;
output logic [1:0] PC_contr;
output logic [1:0] CSR_Src;
output logic F_Src;
    
always_comb
begin
ALU_op = 5'b0;
ALU_en = 1'b0;
FPU_en = 1'b0;
IMM_Src = 1'b0;
B_Src = 1'b0;
J_Src = 1'b0;
RF_write = 1'b0;
FPRF_write = 1'b0;
MEM_data_Src = 3'b000;
WB_Src = 3'b0;
MEM_read = 1'b0;
MEM_read_Src = 3'b0;
MEM_write = 1'b0; 
MEM_write_Src = 3'b111;
PC_contr = 2'b0;
CSR_Src = 2'b00;
F_Src = 1'b0;
    if (ID_stall || (pc_D == 32'b0))begin
         ALU_op = 5'b0;
         ALU_en = 1'b0;
         FPU_en = 1'b0;
         IMM_Src = 1'b0;
         B_Src = 1'b0;
         J_Src = 1'b0;
         RF_write = 1'b0;
         FPRF_write = 1'b0;
         MEM_data_Src = 3'b000;
         WB_Src = 3'b0;
         MEM_read = 1'b0;
         MEM_read_Src = 3'b0;
         MEM_write = 1'b0; 
         MEM_write_Src = 3'b111;
         PC_contr = 2'b0;
         CSR_Src = 2'b00;
         F_Src = 1'b0;
    end
    else begin
        case (op)
        7'b0110011 : begin //R
                     case (func3)
                     3'b000 :begin
                             if (func7 == 2'b01)
                             ALU_op = 5'b10000;                 //MUL
                             else if (func7 == 2'b10)
                             ALU_op = 5'b00001;                 //SUB
                             else
                             ALU_op = 5'b00000;                 //ADD
                             end
                     3'b001 :begin
                             if (func7 == 2'b01)
                             ALU_op = 5'b10001;                 //MULH
                             else
                             ALU_op = 5'b00010;                 //SLL
                             end
                     3'b010 :begin
                             if (func7 == 2'b00)
                             ALU_op = 5'b00011;                 //SLT
                             else
                             ALU_op = 5'b10010;                 //MULSU
                             end
                     3'b011 :begin
                             if (func7 == 2'b00)
                             ALU_op = 5'b00100;                 //SLTU
                             else
                             ALU_op = 5'b10011;                 //MULHU
                             end
                     3'b100 :ALU_op = 5'b00101;                 //XOR
                     3'b101 :begin
                             if (func7 == 2'b00)
                             ALU_op = 5'b00110;                 //SRL
                             else
                             ALU_op = 5'b00111;                 //SRA
                             end
                     3'b110 :ALU_op = 5'b01000;                 //OR
                     3'b111 :ALU_op = 5'b01001;                 //AND
                     endcase
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
                     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b0000011 : begin //I-LOAD
                     ALU_op = 5'b0;
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b1;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
                     WB_Src = 3'b110;
                     MEM_read = 1'b1;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     case(func3)
                     3'b000: MEM_read_Src = 3'b001;             //LB 
                     3'b001: MEM_read_Src = 3'b010;             //LH
                     3'b010: MEM_read_Src = 3'b000;             //LW
                     3'b100: MEM_read_Src = 3'b011;             //LBU
                     3'b101: MEM_read_Src = 3'b100;             //LHU
                     default: MEM_read_Src = 3'b000;
                     endcase
                     end 
        7'b0010011 : begin //I
                     case(func3)
                     3'b000: ALU_op = 5'b00000;                     //ADDI
                     3'b001: ALU_op = 5'b00010;                     //SLLI
                     3'b010: ALU_op = 5'b00011;                     //SLTI
                     3'b011: ALU_op = 5'b00100;                     //SLTIU
                     3'b100: ALU_op = 5'b00101;                     //XORI
                     3'b101:  begin
                              if (func7[1])
                              ALU_op = 5'b00111;                    //SRAI
                              else
                              ALU_op = 5'b00110;                    //SRLI
                              end
                     3'b110: ALU_op = 5'b01000;                     //ORI
                     3'b111: ALU_op = 5'b01001;                     //ANDI
                     endcase
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b1;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
                     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b0100011 : begin //S
                     ALU_op = 5'b00000;
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b1;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b0;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
		     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b1; 
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     case (func3)
                     3'b000: MEM_write_Src = 3'b001;        //SB
                     3'b001: MEM_write_Src = 3'b010;        //SH
                     3'b010: MEM_write_Src = 3'b000;        //SW
                     default: MEM_write_Src = 3'b000;
                     endcase
                     end
        7'b1100011 : begin //B
                     case (func3)
                     3'b000: ALU_op = 5'b01010;             //BEG
                     3'b001: ALU_op = 5'b01011;             //BNE
                     3'b100: ALU_op = 5'b01100;             //BLT
                     3'b101: ALU_op = 5'b01101;             //BGE
                     3'b110: ALU_op = 5'b01110;             //BLTU
                     3'b111: ALU_op = 5'b01111;             //BGEU
                     endcase
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b1;
                     J_Src = 1'b0;
                     RF_write = 1'b0;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
					 WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b01;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b0010111 : begin //AUIPC
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b010;
		     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b0110111 : begin //LUI
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b0;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b011;
		     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b1101111 : begin //J
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b1;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b001;
		     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b01;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b1100111 : begin //JALR
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b1;
                     B_Src = 1'b0;
                     J_Src = 1'b1;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b001;
		     WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b10;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     end
        7'b1110011 : begin //CSR
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b1;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b100;                 
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b01;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                     case (CSR_func)
                     2'b00:begin                        //RDC
                           WB_Src = 3'b111;
                           CSR_Src = 2'b00;
                           end
                     2'b01:begin                        //RDI
						   WB_Src = 3'b000;
                           CSR_Src = 2'b01;
                           end
                     2'b10:begin                        //RDCH
                           WB_Src = 3'b111;
                           CSR_Src = 2'b10;
                           end
                     2'b11:begin                        //RDIH
						   WB_Src = 3'b000;
                           CSR_Src = 2'b11;
                           end
                     endcase
                     end
        7'b0000111 : begin //FLW
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b1;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b0;
                     FPRF_write = 1'b1;
                     MEM_data_Src = 3'b000;
                     WB_Src = 3'b110;
                     MEM_read = 1'b1;
                     MEM_read_Src = 3'b101;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b1;
                     end
        7'b0100111 : begin //FSW
                     ALU_op = 5'b00000; 
                     ALU_en = 1'b1;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b1;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b0;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
					 WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b000;
                     MEM_write = 1'b1; 
                     MEM_write_Src = 3'b011;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b1;
                     end
        7'b1010011 : begin //FADD FSUB
                     case(func5)
                     1'b0: ALU_op = 5'b00000;       //FADD
                     1'b1: ALU_op = 5'b00001;       //FSUB
                     endcase                     
                     ALU_en = 1'b0;
                     FPU_en = 1'b1;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b0;
                     FPRF_write = 1'b1;
                     MEM_data_Src = 3'b101;
					 WB_Src = 3'b000;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b000;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b00;
                     CSR_Src = 2'b00;
                     F_Src = 1'b1;
                     end
        default : begin
                     ALU_op = 5'b0;
                     ALU_en = 1'b0;
                     FPU_en = 1'b0;
                     IMM_Src = 1'b0;
                     B_Src = 1'b0;
                     J_Src = 1'b0;
                     RF_write = 1'b0;
                     FPRF_write = 1'b0;
                     MEM_data_Src = 3'b000;
                     WB_Src = 3'b0;
                     MEM_read = 1'b0;
                     MEM_read_Src = 3'b0;
                     MEM_write = 1'b0; 
                     MEM_write_Src = 3'b111;
                     PC_contr = 2'b0;
                     CSR_Src = 2'b00;
                     F_Src = 1'b0;
                    end
         endcase
    end         
end
                    
endmodule
