`include "CSR_CYCLE.sv"
`include "WB_Src.sv"

module WB_CYCLE(clk, rst, rd_W, frd_W, RF_write_W, FPRF_write_W, WB_data_src_W, CSR_src_W, MEM_load_W,
MEM_back_W, WB_data);

input logic clk, rst;
input logic [4:0] rd_W, frd_W;
input logic RF_write_W;
input logic FPRF_write_W;
input logic [2:0] WB_data_src_W;
input logic [1:0] CSR_src_W;
input logic [31:0] MEM_load_W, MEM_back_W;
output logic [31:0] WB_data;

logic [31:0] CSR_cyc;

CSR_CYCLE CSR_CYCLE(
.clk(clk), 
.rst(rst), 
.CSR_type(CSR_src_W), 
.CSR_cyc(CSR_cyc)
);
    
WB_Src WB_Src(
.WB_data_src_W(WB_data_src_W), 
.MEM_back_W(MEM_back_W),
.MEM_load_W(MEM_load_W),  
.CSR_cyc(CSR_cyc), 
.WB_data(WB_data)
);  
    
endmodule
