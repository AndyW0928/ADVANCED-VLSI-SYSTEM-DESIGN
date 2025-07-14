//IF_CYCLE
`include "PC.sv"
`include "ADD.sv"
`include "PC_MUX.sv"

module IF_CYCLE(clk, rst, PC_contr, pc_JALR, pc_BRA, IF_stall, IF_flush, pc_D, pc_plus_D, pc_IM);
    
input logic clk, rst;
//CU
input logic [1:0] PC_contr;
//EXE
input logic [31:0] pc_JALR, pc_BRA;
//HU
input logic IF_stall;
input logic IF_flush;

output logic [31:0] pc_D, pc_plus_D;
output logic [31:0] pc_IM; 

logic [31:0] pc_c, pc_n, pc_plus;


assign pc_IM = (IF_stall)? pc_D : pc_c;
//***************************************// 
//pc chooses

PC_MUX PC_MUX(
.PC_contr(PC_contr), 
.pc_BRA(pc_BRA), 
.pc_JALR(pc_JALR), 
.pc_plus(pc_plus), 
.IF_flush(IF_flush), 
.pc_n(pc_n)
);

//***************************************//
PC PC(
.clk(clk), 
.rst(rst), 
.PC_stall(IF_stall), 
.pc_n(pc_n), 
.pc_c(pc_c)
);
//***************************************//
ADD PC_ADD (
.add_a(pc_c), 
.add_b(32'd4), 
.add_out(pc_plus)
);
//***************************************//
//IFID_reg
always_ff @(posedge clk or posedge rst)
begin
    if (rst) begin
        pc_D <= 32'b0;
        pc_plus_D <= 32'b0;
        end
    else if (!IF_stall) begin
        pc_D <= pc_c;
        pc_plus_D <= pc_plus;
        end
end
    
endmodule
