
module PC_MUX(PC_contr, pc_BRA, pc_JALR, pc_plus, IF_flush, pc_n);

input logic [1:0] PC_contr;
input logic [31:0] pc_BRA, pc_JALR, pc_plus;
input logic IF_flush;
output logic [31:0] pc_n;

always_comb
begin
    case(PC_contr)
    //normal    pc+4
    2'b00: pc_n = pc_plus;
   //BRA      pc+imm
    2'b01: if (IF_flush)
           pc_n = pc_BRA;
           else
           pc_n = pc_plus;
    //JALR    imm+rs1  
    2'b10: pc_n = pc_JALR;
    default : pc_n = 32'b0;
    endcase
end
endmodule
