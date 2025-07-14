//IF_CYCLE
`include "PC.sv"
`include "ADD.sv"
`include "PC_MUX.sv"

module IF_CYCLE(clk, rst, PC_contr, pc_JALR, pc_BRA, IF_stall, AXI_stall, IF_flush,// ARVALID_M0, ARREADY_M0,
pc_D, pc_plus_D, /*pc_IM,*/ pc_c, inst, inst_D);
    
input logic clk, rst;
//CU
input logic [1:0] PC_contr;
//EXE
input logic [31:0] pc_JALR, pc_BRA;
//HU
input logic IF_stall, AXI_stall;
input logic IF_flush;

//AXI
//input logic ARVALID_M0, ARREADY_M0;

output logic [31:0] pc_D, pc_plus_D;
//output logic [31:0] pc_IM; 
output logic [31:0] pc_c; 

input logic [31:0] inst;
output logic [31:0] inst_D;

logic [31:0] /*pc_c,*/ pc_n, pc_plus;


//assign pc_IM = (IF_stall | AXI_stall)? pc_D : pc_c;
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
.AXI_stall(AXI_stall), 
.pc_n(pc_n),
//.ARVALID_M0(ARVALID_M0),
//.ARREADY_M0(ARREADY_M0), 
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
    else begin
        if (AXI_stall) begin
            pc_D <= pc_D;
            pc_plus_D <= pc_plus_D;
        end
        else begin
            if (IF_stall) begin
                pc_D <= pc_D;
                pc_plus_D <= pc_plus_D;
            end
            else if ( IF_flush ) begin
                pc_D <= 32'b0;
                pc_plus_D <= 32'b0;
            end    
            else begin
            pc_D <= pc_c;
            pc_plus_D <= pc_plus;
            end
        end
    end
end        

//inst_reg
always_ff @(posedge clk or posedge rst)
begin
    if (rst) 
        inst_D <= 32'b0;
    else begin
        if (AXI_stall) 
            inst_D <= inst_D;
        else begin
            if (IF_stall) 
            inst_D <= inst_D; 
            else if ( IF_flush )
            inst_D <= 32'b0; 
            else 
            inst_D <= inst;
        end
    end    
end




endmodule
