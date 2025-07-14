//imm data extend

module imm_extend(inst, op, imm_ext);

input logic [31:0] inst;
input logic [6:0] op;

output logic [31:0] imm_ext;

always_comb
case(op)
7'b0000011: imm_ext = {{20{inst[31]}},inst[31:20]};  
7'b0000111: imm_ext = {{20{inst[31]}},inst[31:20]};  
7'b0010011: imm_ext = {{20{inst[31]}},inst[31:20]};  
7'b1100111: imm_ext = {{20{inst[31]}},inst[31:20]};  
7'b0100011: imm_ext = {{20{inst[31]}},inst[31:25],inst[11:7]};   
7'b0100111: imm_ext = {{20{inst[31]}},inst[31:25],inst[11:7]};     
7'b1100011: imm_ext = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};  
7'b0010111: imm_ext = {inst[31:12],12'b0};  
7'b0110111: imm_ext = {inst[31:12],12'b0};   
7'b1101111: imm_ext = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0}; 
default :imm_ext = 32'h0000_0000;
endcase

endmodule
