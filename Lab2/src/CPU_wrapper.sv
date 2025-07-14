
`include "../include/AXI_define.svh"
`include "CPU.sv"
`include "M_READ.sv"
`include "M_WRITE.sv"

module CPU_wrapper(ACLK, ARESETn, //IM_DO, DM_DO, IM_CEB, DM_CEB, IM_WEB, DM_WEB, IM_BWEB, DM_BWEB, IM_A, DM_A, IM_DI, DM_DI,
AWID_M1, AWADDR_M1, AWLEN_M1, AWSIZE_M1, AWBURST_M1, AWVALID_M1, AWREADY_M1,
WDATA_M1, WSTRB_M1, WLAST_M1, WVALID_M1, WREADY_M1,
BID_M1, BRESP_M1, BVALID_M1, BREADY_M1,
ARID_M0, ARADDR_M0, ARLEN_M0, ARSIZE_M0, ARBURST_M0, ARVALID_M0, ARREADY_M0,
RID_M0, RDATA_M0, RRESP_M0, RLAST_M0, RVALID_M0, RREADY_M0,
ARID_M1, ARADDR_M1, ARLEN_M1, ARSIZE_M1, ARBURST_M1, ARVALID_M1, ARREADY_M1,
RID_M1, RDATA_M1, RRESP_M1, RLAST_M1, RVALID_M1, RREADY_M1);

//input logic clk, rst;
input logic ACLK, ARESETn;
 logic IM_CEB, DM_CEB;
 logic IM_WEB, DM_WEB;
 logic [31:0] IM_BWEB, DM_BWEB;
 logic [31:0] IM_A, DM_A;
 logic [31:0] IM_DI, DM_DI;
 logic [31:0] IM_DO, DM_DO;   
 
 logic w_en; 
 logic r_en_IM;
 logic r_en_DM;
 logic stall_MW, stall_MR0, stall_MR1;
 logic rvalid_out0, rvalid_out1;
 //logic AXI_stall;
 
 
//****************************************************WRITE*******************************************//
//WRITE ADDRESS channel M1
output logic [`AXI_ID_BITS-1:0] AWID_M1;
output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;            //DM_A
output logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
output logic [1:0] AWBURST_M1;
output logic AWVALID_M1;
input logic AWREADY_M1;

//WRITE DATA channel M1
output logic [`AXI_DATA_BITS-1:0] WDATA_M1;             //DM_DI
output logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
output logic WLAST_M1;
output logic WVALID_M1;
input logic WREADY_M1;

//WRITE RESPONSE
input logic [`AXI_ID_BITS-1:0] BID_M1;
input logic [1:0] BRESP_M1;
input logic BVALID_M1;
output logic BREADY_M1; 

//****************************************************************READ**************************************//
//READ ADDRESS0     
output logic [`AXI_ID_BITS-1:0] ARID_M0;
output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;            //IM_A
output logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
output logic [1:0] ARBURST_M0;
output logic ARVALID_M0;
input logic ARREADY_M0;

//READ DATA0  
input logic [`AXI_ID_BITS-1:0] RID_M0;
input logic [`AXI_DATA_BITS-1:0] RDATA_M0;              //IM_DO
input logic [1:0] RRESP_M0;
input logic RLAST_M0;
input logic RVALID_M0;
output logic RREADY_M0; 

//READ ADDRESS1
output logic [`AXI_ID_BITS-1:0] ARID_M1;
output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;            //DM_A
output logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
output logic [1:0] ARBURST_M1;
output logic ARVALID_M1;
input logic ARREADY_M1;
	
//READ DATA1
input logic [`AXI_ID_BITS-1:0] RID_M1;
input logic [`AXI_DATA_BITS-1:0] RDATA_M1;              //DM_DO
input logic [1:0] RRESP_M1;
input logic RLAST_M1;
input logic RVALID_M1;
output logic RREADY_M1;


    
CPU CPU(
.clk(ACLK),
.rst(~ARESETn),

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
.DM_DO(DM_DO),
.w_en(w_en), 
.r_en_IM(r_en_IM), 
.r_en_DM(r_en_DM),
//.AXI_stall(AXI_stall)
.stall_MW(stall_MW), 
.stall_MR0(stall_MR0), 
.stall_MR1(stall_MR1),
.rvalid_out1(rvalid_out1)
//.ARVALID_M0(ARVALID_M0), 
//.ARREADY_M0(ARREADY_M0)
);

/***************************************************************************************************************/
//DM WRITE

M_WRITE MW(
.ACLK(ACLK), 
.ARESETn(ARESETn), 
.AWID(AWID_M1), 
.AWADDR(AWADDR_M1),
.AWLEN(AWLEN_M1), 
.AWSIZE(AWSIZE_M1), 
.AWBURST(AWBURST_M1), 
.AWVALID(AWVALID_M1), 
.AWREADY(AWREADY_M1),
.WDATA(WDATA_M1), 
.WSTRB(WSTRB_M1), 
.WLAST(WLAST_M1), 
.WVALID(WVALID_M1), 
.WREADY(WREADY_M1),
.BID(BID_M1), 
.BRESP(BRESP_M1), 
.BVALID(BVALID_M1), 
.BREADY(BREADY_M1),

.w_en(w_en), 
.w_addr({18'b0,DM_A[15:2]}), 
.w_data_in(DM_DI), 
.BWEB(DM_BWEB), 
.w_id(4'd0),
.stall(stall_MW)
);

/********************************************************************************************************************/

//IM READ
M_READ MR0(
.ACLK(ACLK), 
.ARESETn(ARESETn), 
.ARID(ARID_M0), 
.ARADDR(ARADDR_M0), 
.ARLEN(ARLEN_M0), 
.ARSIZE(ARSIZE_M0), 
.ARBURST(ARBURST_M0), 
.ARVALID(ARVALID_M0), 
.ARREADY(ARREADY_M0),
.RID(RID_M0), 
.RDATA(RDATA_M0), 
.RRESP(RRESP_M0), 
.RLAST(RLAST_M0), 
.RVALID(RVALID_M0), 
.RREADY(RREADY_M0), 

.r_en(r_en_IM), 
.r_addr({18'b0,IM_A[15:2]}), 
.r_id(4'd1), 
.r_data_out(IM_DO), 
.stall(stall_MR0),
.rvalid_out(rvalid_out0)
);

//DM READ
M_READ MR1(
.ACLK(ACLK), 
.ARESETn(ARESETn), 
.ARID(ARID_M1), 
.ARADDR(ARADDR_M1), 
.ARLEN(ARLEN_M1), 
.ARSIZE(ARSIZE_M1), 
.ARBURST(ARBURST_M1), 
.ARVALID(ARVALID_M1), 
.ARREADY(ARREADY_M1),
.RID(RID_M1), 
.RDATA(RDATA_M1), 
.RRESP(RRESP_M1), 
.RLAST(RLAST_M1), 
.RVALID(RVALID_M1), 
.RREADY(RREADY_M1), 

.r_en(r_en_DM), 
.r_addr({17'b0,DM_A[16:2]}), 
.r_id(4'd2), 
.r_data_out(DM_DO), 
.stall(stall_MR1),
.rvalid_out(rvalid_out1)
);

endmodule
