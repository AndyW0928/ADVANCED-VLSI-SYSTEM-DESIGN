`include "CPU.sv"
`include "SRAM_wrapper.sv"

module top(clk, rst);
    
input logic clk, rst;
 
logic IM_CEB, DM_CEB;
logic IM_WEB, DM_WEB;
logic [31:0] IM_BWEB, DM_BWEB;
logic [13:0] IM_A, DM_A;
logic [31:0] IM_DI, DM_DI;
logic [31:0] IM_DO, DM_DO;
 
CPU CPU(
.clk(clk),
.rst(rst),

.IM_CEB(IM_CEB),
.IM_WEB(IM_WEB),
.IM_BWEB(IM_BWEB),
.IM_A(IM_A),
.IM_DI(IM_DI),
.IM_DO(IM_DO),

.DM_CEB(DM_CEB),
.DM_WEB(DM_WEB),
.DM_BWEB(DM_BWEB),
.DM_A(DM_A),
.DM_DI(DM_DI),
.DM_DO(DM_DO)
);


SRAM_wrapper IM1(
.CLK(clk),
.RST(rst),
.CEB(IM_CEB),
.WEB(IM_WEB),
.BWEB(IM_BWEB),
.A(IM_A),
.DI(IM_DI),
.DO(IM_DO)
);


SRAM_wrapper DM1(
.CLK(clk),
.RST(rst),
.CEB(DM_CEB),
.WEB(DM_WEB),
.BWEB(DM_BWEB),
.A(DM_A),
.DI(DM_DI),
.DO(DM_DO)
);

    
endmodule
