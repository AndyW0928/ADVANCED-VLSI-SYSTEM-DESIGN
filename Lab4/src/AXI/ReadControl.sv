
// `include "../include/AXI_define.svh"
// `include "../../src/AXI/ReadChannel/ReadAXI.sv"

module ReadControl(
input logic                       CPU_CLK_i,   //CPU, DMA, SRAM   
input logic                       AXI_CLK_i,   //CPU, DMA, SRAM     
input logic                       ROM_CLK_i,      
input logic                       DRAM_CLK_i,
input logic                       SRAM_CLK_i,
input logic                       DMA_CLK_i,
input logic                       WDT_CLK_i,
input logic                       CPU_RST_i,      
input logic                       AXI_RST_i,        
input logic                       ROM_RST_i,      
input logic                       DRAM_RST_i,
input logic                       SRAM_RST_i,           
input logic                       DMA_RST_i,  
input logic                       WDT_RST_i,         
//MASTER INTERFACE
// M0
// READ
input  logic [`AXI_ID_BITS-1:0]   ARID_M0,
input  logic [`AXI_ADDR_BITS-1:0] ARADDR_M0,
input  logic [`AXI_LEN_BITS-1:0]  ARLEN_M0,
input  logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
input  logic [1:0]                ARBURST_M0,
input  logic                      ARVALID_M0,
output logic                      ARREADY_M0,
output logic [`AXI_ID_BITS-1:0]   RID_M0,
output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
output logic [1:0]                RRESP_M0,
output logic                      RLAST_M0,
output logic                      RVALID_M0,
input  logic                      RREADY_M0,
// M1
// READ
input  logic [`AXI_ID_BITS-1:0]   ARID_M1,
input  logic [`AXI_ADDR_BITS-1:0] ARADDR_M1,
input  logic [`AXI_LEN_BITS-1:0]  ARLEN_M1,
input  logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
input  logic [1:0]                ARBURST_M1,
input  logic                      ARVALID_M1,
output logic                      ARREADY_M1,
output logic [`AXI_ID_BITS-1:0]   RID_M1,
output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
output logic [1:0]                RRESP_M1,
output logic                      RLAST_M1,
output logic                      RVALID_M1,
input  logic                      RREADY_M1,
// M2
// READ
input  logic [`AXI_ID_BITS-1:0]   ARID_M2,
input  logic [`AXI_ADDR_BITS-1:0] ARADDR_M2,
input  logic [`AXI_LEN_BITS-1:0]  ARLEN_M2,
input  logic [`AXI_SIZE_BITS-1:0] ARSIZE_M2,
input  logic [1:0]                ARBURST_M2,
input  logic                      ARVALID_M2,
output logic                      ARREADY_M2,
output logic [`AXI_ID_BITS-1:0]   RID_M2,
output logic [`AXI_DATA_BITS-1:0] RDATA_M2,
output logic [1:0]                RRESP_M2,
output logic                      RLAST_M2,
output logic                      RVALID_M2,
input  logic                      RREADY_M2,
//SLAVE INTERFACE
// S0
// READ
output logic [`AXI_IDS_BITS-1:0]  ARID_S0,
output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S0,
output logic[`AXI_LEN_BITS-1:0]   ARLEN_S0,
output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S0,
output logic[1:0]                 ARBURST_S0,
output logic                      ARVALID_S0,
input  logic                      ARREADY_S0,
input  logic[`AXI_IDS_BITS-1:0]   RID_S0,
input  logic[`AXI_DATA_BITS-1:0]  RDATA_S0,
input  logic[1:0]                 RRESP_S0,
input  logic                      RLAST_S0,
input  logic                      RVALID_S0,
output logic                      RREADY_S0,
// S1
// READ
output logic [`AXI_IDS_BITS-1:0]  ARID_S1,
output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S1,
output logic[`AXI_LEN_BITS-1:0]   ARLEN_S1,
output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S1,
output logic[1:0]                 ARBURST_S1,
output logic                      ARVALID_S1,
input  logic                      ARREADY_S1,
input  logic[`AXI_IDS_BITS-1:0]   RID_S1,
input  logic[`AXI_DATA_BITS-1:0]  RDATA_S1,
input  logic[1:0]                 RRESP_S1,
input  logic                      RLAST_S1,
input  logic                      RVALID_S1,
output logic                      RREADY_S1,
// S2
// READ
output logic [`AXI_IDS_BITS-1:0]  ARID_S2,
output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S2,
output logic[`AXI_LEN_BITS-1:0]   ARLEN_S2,
output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S2,
output logic [1:0]                ARBURST_S2,
output logic                      ARVALID_S2,
input  logic                      ARREADY_S2,
input  logic[`AXI_IDS_BITS-1:0]   RID_S2,
input  logic[`AXI_DATA_BITS-1:0]  RDATA_S2,
input  logic[1:0]                 RRESP_S2,
input  logic                      RLAST_S2,
input  logic                      RVALID_S2,
output logic                      RREADY_S2,
// S3
// READ
output logic [`AXI_IDS_BITS-1:0]  ARID_S3,
output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
output logic [`AXI_LEN_BITS-1:0]  ARLEN_S3,
output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
output logic [1:0]                ARBURST_S3,
output logic                      ARVALID_S3,
input  logic                      ARREADY_S3,
input  logic [`AXI_IDS_BITS-1:0]  RID_S3,
input  logic [`AXI_DATA_BITS-1:0] RDATA_S3,
input  logic [1:0]                RRESP_S3,
input  logic                      RLAST_S3,
input  logic                      RVALID_S3,
output logic                      RREADY_S3,
// S4
// READ
output logic [`AXI_IDS_BITS-1:0]  ARID_S4,
output logic[`AXI_ADDR_BITS-1:0]  ARADDR_S4,
output logic[`AXI_LEN_BITS-1:0]   ARLEN_S4,
output logic[`AXI_SIZE_BITS-1:0]  ARSIZE_S4,
output logic[1:0]                 ARBURST_S4,
output logic                      ARVALID_S4,
input  logic                      ARREADY_S4,
input  logic[`AXI_IDS_BITS-1:0]   RID_S4,
input  logic[`AXI_DATA_BITS-1:0]  RDATA_S4,
input  logic[1:0]                 RRESP_S4,
input  logic                      RLAST_S4,
input  logic                      RVALID_S4,
output logic                      RREADY_S4,
// S5
// READ
output logic [`AXI_IDS_BITS-1:0]  ARID_S5,
output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
output logic [`AXI_LEN_BITS-1:0]  ARLEN_S5,
output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
output logic [1:0]                ARBURST_S5,
output logic                      ARVALID_S5,
input  logic                      ARREADY_S5,
input  logic [`AXI_IDS_BITS-1:0]  RID_S5,
input  logic [`AXI_DATA_BITS-1:0] RDATA_S5,
input  logic [1:0]                RRESP_S5,
input  logic                      RLAST_S5,
input  logic                      RVALID_S5,
output logic                      RREADY_S5
  
);

//

	//READ ADDRESS M0
	logic [`AXI_ID_BITS-1:0] ARID_FIFO_M0;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_M0;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_M0;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_M0;
	logic [1:0] ARBURST_FIFO_M0;
	logic ARVALID_FIFO_M0;
	logic ARREADY_FIFO_M0;
	
	//READ DATA M0
	logic [`AXI_ID_BITS-1:0] RID_FIFO_M0;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_M0;
	logic [1:0] RRESP_FIFO_M0;
	logic RLAST_FIFO_M0;
	logic RVALID_FIFO_M0;
	logic RREADY_FIFO_M0;
	
	//READ ADDRESS M1
	logic [`AXI_ID_BITS-1:0] ARID_FIFO_M1;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_M1;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_M1;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_M1;
	logic [1:0] ARBURST_FIFO_M1;
	logic ARVALID_FIFO_M1;
	logic ARREADY_FIFO_M1;
	
	//READ DATA M1
	logic [`AXI_ID_BITS-1:0] RID_FIFO_M1;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_M1;
	logic [1:0] RRESP_FIFO_M1;
	logic RLAST_FIFO_M1;
	logic RVALID_FIFO_M1;
	logic RREADY_FIFO_M1;

	//READ ADDRESS M2
	logic [`AXI_ID_BITS-1:0] ARID_FIFO_M2;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_M2;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_M2;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_M2;
	logic [1:0] ARBURST_FIFO_M2;
	logic ARVALID_FIFO_M2;
	logic ARREADY_FIFO_M2;
	
	//READ DATA M2
	logic [`AXI_ID_BITS-1:0] RID_FIFO_M2;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_M2;
	logic [1:0] RRESP_FIFO_M2;
	logic RLAST_FIFO_M2;
	logic RVALID_FIFO_M2;
	logic RREADY_FIFO_M2;


	/////READ ADDRESS S0
	logic [`AXI_IDS_BITS-1:0] ARID_FIFO_S0;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_S0;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_S0;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_S0;
	logic [1:0] ARBURST_FIFO_S0;
	logic ARVALID_FIFO_S0;
	logic ARREADY_FIFO_S0;
	
	//READ DATA0
	logic [`AXI_IDS_BITS-1:0] RID_FIFO_S0;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_S0;
	logic [1:0] RRESP_FIFO_S0;
	logic RLAST_FIFO_S0;
	logic RVALID_FIFO_S0;
	logic RREADY_FIFO_S0;
	
	/////READ ADDRESS S1
	logic [`AXI_IDS_BITS-1:0] ARID_FIFO_S1;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_S1;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_S1;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_S1;
	logic [1:0] ARBURST_FIFO_S1;
	logic ARVALID_FIFO_S1;
	logic ARREADY_FIFO_S1;
	
	//READ DATA S1
	logic [`AXI_IDS_BITS-1:0] RID_FIFO_S1;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_S1;
	logic [1:0] RRESP_FIFO_S1;
	logic RLAST_FIFO_S1;
	logic RVALID_FIFO_S1;
	logic RREADY_FIFO_S1;

	/////READ ADDRESS S2
	logic [`AXI_IDS_BITS-1:0] ARID_FIFO_S2;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_S2;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_S2;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_S2;
	logic [1:0] ARBURST_FIFO_S2;
	logic ARVALID_FIFO_S2;
	logic ARREADY_FIFO_S2;
	
	//READ DATA S2
	logic [`AXI_IDS_BITS-1:0] RID_FIFO_S2;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_S2;
	logic [1:0] RRESP_FIFO_S2;
	logic RLAST_FIFO_S2;
	logic RVALID_FIFO_S2;
	logic RREADY_FIFO_S2;

	//READ ADDRESS S3
	logic [`AXI_IDS_BITS-1:0] ARID_FIFO_S3;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_S3;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_S3;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_S3;
	logic [1:0] ARBURST_FIFO_S3;
	logic ARVALID_FIFO_S3;
	logic ARREADY_FIFO_S3;
	
	//READ DATA S3
	logic [`AXI_IDS_BITS-1:0] RID_FIFO_S3;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_S3;
	logic [1:0] RRESP_FIFO_S3;
	logic RLAST_FIFO_S3;
	logic RVALID_FIFO_S3;
	logic RREADY_FIFO_S3;

	//READ ADDRESS S4
	logic [`AXI_IDS_BITS-1:0] ARID_FIFO_S4;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_S4;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_S4;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_S4;
	logic [1:0] ARBURST_FIFO_S4;
	logic ARVALID_FIFO_S4;
	logic ARREADY_FIFO_S4;
	
	//READ DATA S4
	logic [`AXI_IDS_BITS-1:0] RID_FIFO_S4;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_S4;
	logic [1:0] RRESP_FIFO_S4;
	logic RLAST_FIFO_S4;
	logic RVALID_FIFO_S4;
	logic RREADY_FIFO_S4;

	//READ ADDRESS S5
	logic [`AXI_IDS_BITS-1:0] ARID_FIFO_S5;
	logic [`AXI_ADDR_BITS-1:0] ARADDR_FIFO_S5;
	logic [`AXI_LEN_BITS-1:0] ARLEN_FIFO_S5;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE_FIFO_S5;
	logic [1:0] ARBURST_FIFO_S5;
	logic ARVALID_FIFO_S5;
	logic ARREADY_FIFO_S5;
	
	//READ DATA S5
	logic [`AXI_IDS_BITS-1:0] RID_FIFO_S5;
	logic [`AXI_DATA_BITS-1:0] RDATA_FIFO_S5;
	logic [1:0] RRESP_FIFO_S5;
	logic RLAST_FIFO_S5;
	logic RVALID_FIFO_S5;
	logic RREADY_FIFO_S5;

//// FIFO //////////////////////////////////////////////////////////////////////


//////Master/////////////////////////////////
// //====================== M0 AR ======================//
logic   [44:0]  AFIFO_WDATA_AR_M0   , AFIFO_RDATA_AR_M0     , AFIFO_RDATA_T_AR_M0;
logic   [3:0]   R_PTR_GRAY_AR_M0    , R_PTR_Binary_AR_M0    , W_PTR_GRAY_AR_M0;
logic           W_FULL_AR_M0        , R_EMPTY_AR_M0;
assign AFIFO_WDATA_AR_M0 = {ARID_M0, ARADDR_M0, ARLEN_M0, ARSIZE_M0, ARBURST_M0};
assign {ARID_FIFO_M0, ARADDR_FIFO_M0, ARLEN_FIFO_M0, ARSIZE_FIFO_M0, ARBURST_FIFO_M0} = AFIFO_RDATA_T_AR_M0;
assign ARREADY_M0 = ~W_FULL_AR_M0;
assign ARVALID_FIFO_M0 = ~R_EMPTY_AR_M0;
AFIFO_Tx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_M0
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .W_DATA(AFIFO_WDATA_AR_M0),
    .WEN(ARVALID_M0),
    .W_FULL(W_FULL_AR_M0),
    .R_PTR_GRAY(R_PTR_GRAY_AR_M0),
    .R_PTR_Binary(R_PTR_Binary_AR_M0),
    .W_PTR_GRAY(W_PTR_GRAY_AR_M0),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_M0)
);
AFIFO_Rx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_M0
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_AR_M0),
    .REN(ARREADY_FIFO_M0),
    .R_EMPTY(R_EMPTY_AR_M0),
    .W_PTR_GRAY(W_PTR_GRAY_AR_M0),
    .R_PTR_GRAY(R_PTR_GRAY_AR_M0),
    .R_PTR_Binary(R_PTR_Binary_AR_M0),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_M0)
);
//====================== M0 AR ======================//

//====================== M0  R ======================//
logic   [42:0]  AFIFO_WDATA_R_M0    , AFIFO_RDATA_R_M0      , AFIFO_RDATA_T_R_M0;
logic   [3:0]   R_PTR_GRAY_R_M0     , R_PTR_Binary_R_M0     , W_PTR_GRAY_R_M0;
logic           W_FULL_R_M0         , R_EMPTY_R_M0;
assign AFIFO_WDATA_R_M0 =  {RID_FIFO_M0, RDATA_FIFO_M0, RRESP_FIFO_M0, RLAST_FIFO_M0};
assign {RID_M0, RDATA_M0, RRESP_M0, RLAST_M0} = AFIFO_RDATA_T_R_M0;
assign RREADY_FIFO_M0 = ~W_FULL_R_M0;
assign RVALID_M0 = ~R_EMPTY_R_M0;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_M0
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_R_M0),
    .WEN(RVALID_FIFO_M0),
    .W_FULL(W_FULL_R_M0),
    .R_PTR_GRAY(R_PTR_GRAY_R_M0),
    .R_PTR_Binary(R_PTR_Binary_R_M0),
    .W_PTR_GRAY(W_PTR_GRAY_R_M0),
    .R_DATA_Tx(AFIFO_RDATA_T_R_M0)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_M0
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .R_DATA(AFIFO_RDATA_R_M0),
    .REN(RREADY_M0),
    .R_EMPTY(R_EMPTY_R_M0),
    .W_PTR_GRAY(W_PTR_GRAY_R_M0),
    .R_PTR_GRAY(R_PTR_GRAY_R_M0),
    .R_PTR_Binary(R_PTR_Binary_R_M0),
    .R_DATA_Tx(AFIFO_RDATA_T_R_M0)
);
//====================== M0  R ======================//
//====================== M1 AR ======================//
logic   [44:0]  AFIFO_WDATA_AR_M1   , AFIFO_RDATA_AR_M1     , AFIFO_RDATA_T_AR_M1;
logic   [3:0]   R_PTR_GRAY_AR_M1    , R_PTR_Binary_AR_M1    , W_PTR_GRAY_AR_M1;
logic           W_FULL_AR_M1        , R_EMPTY_AR_M1;
assign AFIFO_WDATA_AR_M1 = {ARID_M1, ARADDR_M1, ARLEN_M1, ARSIZE_M1, ARBURST_M1};
assign {ARID_FIFO_M1, ARADDR_FIFO_M1, ARLEN_FIFO_M1, ARSIZE_FIFO_M1, ARBURST_FIFO_M1} = AFIFO_RDATA_T_AR_M1;
assign ARREADY_M1 = ~W_FULL_AR_M1;
assign ARVALID_FIFO_M1 = ~R_EMPTY_AR_M1;
AFIFO_Tx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_M1
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .W_DATA(AFIFO_WDATA_AR_M1),
    .WEN(ARVALID_M1),
    .W_FULL(W_FULL_AR_M1),
    .R_PTR_GRAY(R_PTR_GRAY_AR_M1),
    .R_PTR_Binary(R_PTR_Binary_AR_M1),
    .W_PTR_GRAY(W_PTR_GRAY_AR_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_M1)
);
AFIFO_Rx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_M1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_AR_M1),
    .REN(ARREADY_FIFO_M1),
    .R_EMPTY(R_EMPTY_AR_M1),
    .W_PTR_GRAY(W_PTR_GRAY_AR_M1),
    .R_PTR_GRAY(R_PTR_GRAY_AR_M1),
    .R_PTR_Binary(R_PTR_Binary_AR_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_M1)
);
//====================== M1 AR ======================//
//====================== M1  R ======================//
logic   [38:0]  AFIFO_WDATA_R_M1    , AFIFO_RDATA_R_M1      , AFIFO_RDATA_T_R_M1;
logic   [3:0]   R_PTR_GRAY_R_M1     , R_PTR_Binary_R_M1     , W_PTR_GRAY_R_M1;
logic           W_FULL_R_M1         , R_EMPTY_R_M1;
assign AFIFO_WDATA_R_M1 = {10'd0 ,RID_FIFO_M1, RDATA_FIFO_M1, RRESP_FIFO_M1, RLAST_FIFO_M1};
assign {RID_M1, RDATA_M1, RRESP_M1, RLAST_M1} = AFIFO_RDATA_T_R_M1;
assign RREADY_FIFO_M1 = ~W_FULL_R_M1;
assign RVALID_M1 = ~R_EMPTY_R_M1;
AFIFO_Tx#(
    .DATA_WIDTH(39),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_M1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_R_M1),
    .WEN(RVALID_FIFO_M1),
    .W_FULL(W_FULL_R_M1),
    .R_PTR_GRAY(R_PTR_GRAY_R_M1),
    .R_PTR_Binary(R_PTR_Binary_R_M1),
    .W_PTR_GRAY(W_PTR_GRAY_R_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_R_M1)
);
AFIFO_Rx#(
    .DATA_WIDTH(39),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_M1
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .R_DATA(AFIFO_RDATA_R_M1),
    .REN(RREADY_M1),
    .R_EMPTY(R_EMPTY_R_M1),
    .W_PTR_GRAY(W_PTR_GRAY_R_M1),
    .R_PTR_GRAY(R_PTR_GRAY_R_M1),
    .R_PTR_Binary(R_PTR_Binary_R_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_R_M1)
);
//====================== M1  R ======================//
//====================== M2 AR ======================//
logic   [44:0]  AFIFO_WDATA_AR_M2   , AFIFO_RDATA_AR_M2     , AFIFO_RDATA_T_AR_M2;
logic   [3:0]   R_PTR_GRAY_AR_M2    , R_PTR_Binary_AR_M2    , W_PTR_GRAY_AR_M2;
logic           W_FULL_AR_M2        , R_EMPTY_AR_M2;
assign AFIFO_WDATA_AR_M2 = {ARID_M2, ARADDR_M2, ARLEN_M2, ARSIZE_M2, ARBURST_M2};
assign {ARID_FIFO_M2, ARADDR_FIFO_M2, ARLEN_FIFO_M2, ARSIZE_FIFO_M2, ARBURST_FIFO_M2} = AFIFO_RDATA_T_AR_M2;
assign ARREADY_M2 = ~W_FULL_AR_M2;
assign ARVALID_FIFO_M2 = ~R_EMPTY_AR_M2;
AFIFO_Tx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_M2
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .W_DATA(AFIFO_WDATA_AR_M2),
    .WEN(ARVALID_M2),
    .W_FULL(W_FULL_AR_M2),
    .R_PTR_GRAY(R_PTR_GRAY_AR_M2),
    .R_PTR_Binary(R_PTR_Binary_AR_M2),
    .W_PTR_GRAY(W_PTR_GRAY_AR_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_M2)
);
AFIFO_Rx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_M2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_AR_M2),
    .REN(ARREADY_FIFO_M2),
    .R_EMPTY(R_EMPTY_AR_M2),
    .W_PTR_GRAY(W_PTR_GRAY_AR_M2),
    .R_PTR_GRAY(R_PTR_GRAY_AR_M2),
    .R_PTR_Binary(R_PTR_Binary_AR_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_M2)
);
//====================== M2 AR ======================//
//====================== M2  R ======================//
logic   [38:0]  AFIFO_WDATA_R_M2    , AFIFO_RDATA_R_M2      , AFIFO_RDATA_T_R_M2;
logic   [3:0]   R_PTR_GRAY_R_M2     , R_PTR_Binary_R_M2     , W_PTR_GRAY_R_M2;
logic           W_FULL_R_M2         , R_EMPTY_R_M2;
assign AFIFO_WDATA_R_M2 = {10'd0 ,RID_FIFO_M2, RDATA_FIFO_M2, RRESP_FIFO_M2, RLAST_FIFO_M2};
assign {RID_M2, RDATA_M2, RRESP_M2, RLAST_M2} = AFIFO_RDATA_T_R_M2;
assign RREADY_FIFO_M2 = ~W_FULL_R_M2;
assign RVALID_M2 = ~R_EMPTY_R_M2;
AFIFO_Tx#(
    .DATA_WIDTH(39),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_M2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_R_M2),
    .WEN(RVALID_FIFO_M2),
    .W_FULL(W_FULL_R_M2),
    .R_PTR_GRAY(R_PTR_GRAY_R_M2),
    .R_PTR_Binary(R_PTR_Binary_R_M2),
    .W_PTR_GRAY(W_PTR_GRAY_R_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_R_M2)
);
AFIFO_Rx#(
    .DATA_WIDTH(39),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_M2
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .R_DATA(AFIFO_RDATA_R_M2),
    .REN(RREADY_M2),
    .R_EMPTY(R_EMPTY_R_M2),
    .W_PTR_GRAY(W_PTR_GRAY_R_M2),
    .R_PTR_GRAY(R_PTR_GRAY_R_M2),
    .R_PTR_Binary(R_PTR_Binary_R_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_R_M2)
);
//====================== M2  R ======================//

////////Slave////////////////////////////////////
//     //====================== S0 AR ======================//
logic   [48:0]  AFIFO_WDATA_AR_S0   , AFIFO_RDATA_AR_S0     , AFIFO_RDATA_T_AR_S0;
logic   [3:0]   R_PTR_GRAY_AR_S0    , R_PTR_Binary_AR_S0    , W_PTR_GRAY_AR_S0;
logic           W_FULL_AR_S0        , R_EMPTY_AR_S0;
assign AFIFO_WDATA_AR_S0 = {ARID_FIFO_S0, ARADDR_FIFO_S0, ARLEN_FIFO_S0, ARSIZE_FIFO_S0, ARBURST_FIFO_S0};
assign {ARID_S0, ARADDR_S0, ARLEN_S0, ARSIZE_S0, ARBURST_S0} = AFIFO_RDATA_T_AR_S0;
assign ARREADY_FIFO_S0 = ~W_FULL_AR_S0;
assign ARVALID_S0 = ~R_EMPTY_AR_S0;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_S0
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AR_S0),
    .WEN(ARVALID_FIFO_S0),
    .W_FULL(W_FULL_AR_S0),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S0),
    .R_PTR_Binary(R_PTR_Binary_AR_S0),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S0),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S0)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_S0
(
    .CLK(ROM_CLK_i),
    .RSTn(ROM_RST_i),
    .R_DATA(AFIFO_RDATA_AR_S0),
    .REN(ARREADY_S0),
    .R_EMPTY(R_EMPTY_AR_S0),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S0),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S0),
    .R_PTR_Binary(R_PTR_Binary_AR_S0),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S0)
);
//====================== S0 AR ======================//
//====================== S0  R ======================//
logic   [42:0]  AFIFO_WDATA_R_S0    , AFIFO_RDATA_R_S0      , AFIFO_RDATA_T_R_S0;
logic   [3:0]   R_PTR_GRAY_R_S0     , R_PTR_Binary_R_S0     , W_PTR_GRAY_R_S0;
logic           W_FULL_R_S0         , R_EMPTY_R_S0;
assign AFIFO_WDATA_R_S0 = {RID_S0, RDATA_S0, RRESP_S0, RLAST_S0};
assign {RID_FIFO_S0, RDATA_FIFO_S0, RRESP_FIFO_S0, RLAST_FIFO_S0} = AFIFO_RDATA_T_R_S0;
assign RREADY_S0 = ~W_FULL_R_S0;
assign RVALID_FIFO_S0 = ~R_EMPTY_R_S0;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_S0
(
    .CLK(ROM_CLK_i),
    .RSTn(ROM_RST_i),
    .W_DATA(AFIFO_WDATA_R_S0),
    .WEN(RVALID_S0),
    .W_FULL(W_FULL_R_S0),
    .R_PTR_GRAY(R_PTR_GRAY_R_S0),
    .R_PTR_Binary(R_PTR_Binary_R_S0),
    .W_PTR_GRAY(W_PTR_GRAY_R_S0),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S0)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_S0
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_R_S0),
    .REN(RREADY_FIFO_S0),
    .R_EMPTY(R_EMPTY_R_S0),
    .W_PTR_GRAY(W_PTR_GRAY_R_S0),
    .R_PTR_GRAY(R_PTR_GRAY_R_S0),
    .R_PTR_Binary(R_PTR_Binary_R_S0),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S0)
);
// ====================== S0 R ======================//
//====================== S1 AR ======================//
logic   [48:0]  AFIFO_WDATA_AR_S1   , AFIFO_RDATA_AR_S1     , AFIFO_RDATA_T_AR_S1;
logic   [3:0]   R_PTR_GRAY_AR_S1    , R_PTR_Binary_AR_S1    , W_PTR_GRAY_AR_S1;
logic           W_FULL_AR_S1        , R_EMPTY_AR_S1;
assign AFIFO_WDATA_AR_S1 = {ARID_FIFO_S1, ARADDR_FIFO_S1, ARLEN_FIFO_S1, ARSIZE_FIFO_S1, ARBURST_FIFO_S1};
assign {ARID_S1, ARADDR_S1, ARLEN_S1, ARSIZE_S1, ARBURST_S1} = AFIFO_RDATA_T_AR_S1;
assign ARREADY_FIFO_S1 = ~W_FULL_AR_S1;
assign ARVALID_S1 = ~R_EMPTY_AR_S1;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_S1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AR_S1),
    .WEN(ARVALID_FIFO_S1),
    .W_FULL(W_FULL_AR_S1),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S1),
    .R_PTR_Binary(R_PTR_Binary_AR_S1),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S1)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_S1
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AR_S1),
    .REN(ARREADY_S1),
    .R_EMPTY(R_EMPTY_AR_S1),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S1),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S1),
    .R_PTR_Binary(R_PTR_Binary_AR_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S1)
);
//====================== S1 AR ======================//
//====================== S1  R ======================//
logic   [42:0]  AFIFO_WDATA_R_S1    , AFIFO_RDATA_R_S1      , AFIFO_RDATA_T_R_S1;
logic   [3:0]   R_PTR_GRAY_R_S1     , R_PTR_Binary_R_S1     , W_PTR_GRAY_R_S1;
logic           W_FULL_R_S1         , R_EMPTY_R_S1;
assign AFIFO_WDATA_R_S1 = {RID_S1, RDATA_S1, RRESP_S1, RLAST_S1};
assign {RID_FIFO_S1, RDATA_FIFO_S1, RRESP_FIFO_S1, RLAST_FIFO_S1} = AFIFO_RDATA_T_R_S1;
assign RREADY_S1 = ~W_FULL_R_S1;
assign RVALID_FIFO_S1 = ~R_EMPTY_R_S1;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_S1
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .W_DATA(AFIFO_WDATA_R_S1),
    .WEN(RVALID_S1),
    .W_FULL(W_FULL_R_S1),
    .R_PTR_GRAY(R_PTR_GRAY_R_S1),
    .R_PTR_Binary(R_PTR_Binary_R_S1),
    .W_PTR_GRAY(W_PTR_GRAY_R_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S1)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_S1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_R_S1),
    .REN(RREADY_FIFO_S1),
    .R_EMPTY(R_EMPTY_R_S1),
    .W_PTR_GRAY(W_PTR_GRAY_R_S1),
    .R_PTR_GRAY(R_PTR_GRAY_R_S1),
    .R_PTR_Binary(R_PTR_Binary_R_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S1)
);
//====================== S1  R ======================//
//====================== S2 AR ======================//
logic   [48:0]  AFIFO_WDATA_AR_S2   , AFIFO_RDATA_AR_S2     , AFIFO_RDATA_T_AR_S2;
logic   [3:0]   R_PTR_GRAY_AR_S2    , R_PTR_Binary_AR_S2    , W_PTR_GRAY_AR_S2;
logic           W_FULL_AR_S2        , R_EMPTY_AR_S2;
assign AFIFO_WDATA_AR_S2 = {ARID_FIFO_S2, ARADDR_FIFO_S2, ARLEN_FIFO_S2, ARSIZE_FIFO_S2, ARBURST_FIFO_S2};
assign {ARID_S2, ARADDR_S2, ARLEN_S2, ARSIZE_S2, ARBURST_S2} = AFIFO_RDATA_T_AR_S2;
assign ARREADY_FIFO_S2 = ~W_FULL_AR_S2;
assign ARVALID_S2 = ~R_EMPTY_AR_S2;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_S2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AR_S2),
    .WEN(ARVALID_FIFO_S2),
    .W_FULL(W_FULL_AR_S2),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S2),
    .R_PTR_Binary(R_PTR_Binary_AR_S2),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S2)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_S2
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AR_S2),
    .REN(ARREADY_S2),
    .R_EMPTY(R_EMPTY_AR_S2),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S2),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S2),
    .R_PTR_Binary(R_PTR_Binary_AR_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S2)
);
//====================== S2 AR ======================//
//====================== S2  R ======================//
logic   [42:0]  AFIFO_WDATA_R_S2    , AFIFO_RDATA_R_S2      , AFIFO_RDATA_T_R_S2;
logic   [3:0]   R_PTR_GRAY_R_S2     , R_PTR_Binary_R_S2     , W_PTR_GRAY_R_S2;
logic           W_FULL_R_S2         , R_EMPTY_R_S2;
assign AFIFO_WDATA_R_S2 = {RID_S2, RDATA_S2, RRESP_S2, RLAST_S2};
assign {RID_FIFO_S2, RDATA_FIFO_S2, RRESP_FIFO_S2, RLAST_FIFO_S2} = AFIFO_RDATA_T_R_S2;
assign RREADY_S2 = ~W_FULL_R_S2;
assign RVALID_FIFO_S2 = ~R_EMPTY_R_S2;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_S2
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .W_DATA(AFIFO_WDATA_R_S2),
    .WEN(RVALID_S2),
    .W_FULL(W_FULL_R_S2),
    .R_PTR_GRAY(R_PTR_GRAY_R_S2),
    .R_PTR_Binary(R_PTR_Binary_R_S2),
    .W_PTR_GRAY(W_PTR_GRAY_R_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S2)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_S2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_R_S2),
    .REN(RREADY_FIFO_S2),
    .R_EMPTY(R_EMPTY_R_S2),
    .W_PTR_GRAY(W_PTR_GRAY_R_S2),
    .R_PTR_GRAY(R_PTR_GRAY_R_S2),
    .R_PTR_Binary(R_PTR_Binary_R_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S2)
);
//====================== S2  R ======================//
//====================== S3 AR ======================//
logic   [48:0]  AFIFO_WDATA_AR_S3   , AFIFO_RDATA_AR_S3     , AFIFO_RDATA_T_AR_S3;
logic   [3:0]   R_PTR_GRAY_AR_S3    , R_PTR_Binary_AR_S3    , W_PTR_GRAY_AR_S3;
logic           W_FULL_AR_S3        , R_EMPTY_AR_S3;
assign AFIFO_WDATA_AR_S3 = {ARID_FIFO_S3, ARADDR_FIFO_S3, ARLEN_FIFO_S3, ARSIZE_FIFO_S3, ARBURST_FIFO_S3};
assign {ARID_S3, ARADDR_S3, ARLEN_S3, ARSIZE_S3, ARBURST_S3} = AFIFO_RDATA_T_AR_S3;
assign ARREADY_FIFO_S3 = ~W_FULL_AR_S3;
assign ARVALID_S3 = ~R_EMPTY_AR_S3;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_S3
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AR_S3),
    .WEN(ARVALID_FIFO_S3),
    .W_FULL(W_FULL_AR_S3),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S3),
    .R_PTR_Binary(R_PTR_Binary_AR_S3),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S3)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_S3
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .R_DATA(AFIFO_RDATA_AR_S3),
    .REN(ARREADY_S3),
    .R_EMPTY(R_EMPTY_AR_S3),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S3),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S3),
    .R_PTR_Binary(R_PTR_Binary_AR_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S3)
);
//====================== S3 AR ======================//
//====================== S3  R ======================//
logic   [42:0]  AFIFO_WDATA_R_S3    , AFIFO_RDATA_R_S3      , AFIFO_RDATA_T_R_S3;
logic   [3:0]   R_PTR_GRAY_R_S3     , R_PTR_Binary_R_S3     , W_PTR_GRAY_R_S3;
logic           W_FULL_R_S3         , R_EMPTY_R_S3;
assign AFIFO_WDATA_R_S3 = {RID_S3, RDATA_S3, RRESP_S3, RLAST_S3};
assign {RID_FIFO_S3, RDATA_FIFO_S3, RRESP_FIFO_S3, RLAST_FIFO_S3} = AFIFO_RDATA_T_R_S3;
assign RREADY_S3 = ~W_FULL_R_S3;
assign RVALID_FIFO_S3 = ~R_EMPTY_R_S3;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_S3
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .W_DATA(AFIFO_WDATA_R_S3),
    .WEN(RVALID_S3),
    .W_FULL(W_FULL_R_S3),
    .R_PTR_GRAY(R_PTR_GRAY_R_S3),
    .R_PTR_Binary(R_PTR_Binary_R_S3),
    .W_PTR_GRAY(W_PTR_GRAY_R_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S3)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_S3
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_R_S3),
    .REN(RREADY_FIFO_S3),
    .R_EMPTY(R_EMPTY_R_S3),
    .W_PTR_GRAY(W_PTR_GRAY_R_S3),
    .R_PTR_GRAY(R_PTR_GRAY_R_S3),
    .R_PTR_Binary(R_PTR_Binary_R_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S3)
);
//====================== S3  R ======================//
//====================== S4 AR ======================//
logic   [48:0]  AFIFO_WDATA_AR_S4   , AFIFO_RDATA_AR_S4     , AFIFO_RDATA_T_AR_S4;
logic   [3:0]   R_PTR_GRAY_AR_S4    , R_PTR_Binary_AR_S4    , W_PTR_GRAY_AR_S4;
logic           W_FULL_AR_S4        , R_EMPTY_AR_S4;
assign AFIFO_WDATA_AR_S4 = {ARID_FIFO_S4, ARADDR_FIFO_S4, ARLEN_FIFO_S4, ARSIZE_FIFO_S4, ARBURST_FIFO_S4};
assign {ARID_S4, ARADDR_S4, ARLEN_S4, ARSIZE_S4, ARBURST_S4} = AFIFO_RDATA_T_AR_S4;
assign ARREADY_FIFO_S4 = ~W_FULL_AR_S4;
assign ARVALID_S4 = ~R_EMPTY_AR_S4;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_S4
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AR_S4),
    .WEN(ARVALID_FIFO_S4),
    .W_FULL(W_FULL_AR_S4),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S4),
    .R_PTR_Binary(R_PTR_Binary_AR_S4),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S4)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_S4
(
    .CLK(WDT_CLK_i),
    .RSTn(WDT_RST_i),
    .R_DATA(AFIFO_RDATA_AR_S4),
    .REN(ARREADY_S4),
    .R_EMPTY(R_EMPTY_AR_S4),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S4),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S4),
    .R_PTR_Binary(R_PTR_Binary_AR_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S4)
);
//====================== S4 AR ======================//
//====================== S4  R ======================//
logic   [42:0]  AFIFO_WDATA_R_S4    , AFIFO_RDATA_R_S4      , AFIFO_RDATA_T_R_S4;
logic   [3:0]   R_PTR_GRAY_R_S4     , R_PTR_Binary_R_S4     , W_PTR_GRAY_R_S4;
logic           W_FULL_R_S4         , R_EMPTY_R_S4;
assign AFIFO_WDATA_R_S4 = {RID_S4, RDATA_S4, RRESP_S4, RLAST_S4};
assign {RID_FIFO_S4, RDATA_FIFO_S4, RRESP_FIFO_S4, RLAST_FIFO_S4} = AFIFO_RDATA_T_R_S4;
assign RREADY_S4 = ~W_FULL_R_S4;
assign RVALID_FIFO_S4 = ~R_EMPTY_R_S4;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_S4
(
    .CLK(WDT_CLK_i),
    .RSTn(WDT_RST_i),
    .W_DATA(AFIFO_WDATA_R_S4),
    .WEN(RVALID_S4),
    .W_FULL(W_FULL_R_S4),
    .R_PTR_GRAY(R_PTR_GRAY_R_S4),
    .R_PTR_Binary(R_PTR_Binary_R_S4),
    .W_PTR_GRAY(W_PTR_GRAY_R_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S4)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_S4
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_R_S4),
    .REN(RREADY_FIFO_S4),
    .R_EMPTY(R_EMPTY_R_S4),
    .W_PTR_GRAY(W_PTR_GRAY_R_S4),
    .R_PTR_GRAY(R_PTR_GRAY_R_S4),
    .R_PTR_Binary(R_PTR_Binary_R_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S4)
);
//====================== S4  R ======================//
//====================== S5 AR ======================//
logic   [48:0]  AFIFO_WDATA_AR_S5   , AFIFO_RDATA_AR_S5     , AFIFO_RDATA_T_AR_S5;
logic   [3:0]   R_PTR_GRAY_AR_S5    , R_PTR_Binary_AR_S5    , W_PTR_GRAY_AR_S5;
logic           W_FULL_AR_S5        , R_EMPTY_AR_S5;
assign AFIFO_WDATA_AR_S5 = {ARID_FIFO_S5, ARADDR_FIFO_S5, ARLEN_FIFO_S5, ARSIZE_FIFO_S5, ARBURST_FIFO_S5};
assign {ARID_S5, ARADDR_S5, ARLEN_S5, ARSIZE_S5, ARBURST_S5} = AFIFO_RDATA_T_AR_S5;
assign ARREADY_FIFO_S5 = ~W_FULL_AR_S5;
assign ARVALID_S5 = ~R_EMPTY_AR_S5;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AR_S5
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AR_S5),
    .WEN(ARVALID_FIFO_S5),
    .W_FULL(W_FULL_AR_S5),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S5),
    .R_PTR_Binary(R_PTR_Binary_AR_S5),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S5)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AR_S5
(
    .CLK(DRAM_CLK_i),
    .RSTn(DRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AR_S5),
    .REN(ARREADY_S5),
    .R_EMPTY(R_EMPTY_AR_S5),
    .W_PTR_GRAY(W_PTR_GRAY_AR_S5),
    .R_PTR_GRAY(R_PTR_GRAY_AR_S5),
    .R_PTR_Binary(R_PTR_Binary_AR_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_AR_S5)
);
//====================== S5 AR ======================//
//====================== S5  R ======================//
logic   [42:0]  AFIFO_WDATA_R_S5    , AFIFO_RDATA_R_S5      , AFIFO_RDATA_T_R_S5;
logic   [3:0]   R_PTR_GRAY_R_S5     , R_PTR_Binary_R_S5     , W_PTR_GRAY_R_S5;
logic           W_FULL_R_S5         , R_EMPTY_R_S5;
assign AFIFO_WDATA_R_S5 = {RID_S5, RDATA_S5, RRESP_S5, RLAST_S5};
assign {RID_FIFO_S5, RDATA_FIFO_S5, RRESP_FIFO_S5, RLAST_FIFO_S5} = AFIFO_RDATA_T_R_S5;
assign RREADY_S5 = ~W_FULL_R_S5;
assign RVALID_FIFO_S5 = ~R_EMPTY_R_S5;
AFIFO_Tx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Tx_R_S5
(
    .CLK(DRAM_CLK_i),
    .RSTn(DRAM_RST_i),
    .W_DATA(AFIFO_WDATA_R_S5),
    .WEN(RVALID_S5),
    .W_FULL(W_FULL_R_S5),
    .R_PTR_GRAY(R_PTR_GRAY_R_S5),
    .R_PTR_Binary(R_PTR_Binary_R_S5),
    .W_PTR_GRAY(W_PTR_GRAY_R_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S5)
);
AFIFO_Rx#(
    .DATA_WIDTH(43),
    .ADDR_WIDTH(4)
) AFIFO_Rx_R_S5
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_R_S5),
    .REN(RREADY_FIFO_S5),
    .R_EMPTY(R_EMPTY_R_S5),
    .W_PTR_GRAY(W_PTR_GRAY_R_S5),
    .R_PTR_GRAY(R_PTR_GRAY_R_S5),
    .R_PTR_Binary(R_PTR_Binary_R_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_R_S5)
);
// //====================== S5  R ======================//
/////////////////////////////////////
	ReadAXI readAXI
	(
		.clk(AXI_CLK_i),
		.rst(AXI_RST_i),
		// Master
		// READ ADDRESS0
		.ARID_M0(ARID_FIFO_M0),
		.ARADDR_M0(ARADDR_FIFO_M0),
		.ARLEN_M0(ARLEN_FIFO_M0),
		.ARSIZE_M0(ARSIZE_FIFO_M0),
		.ARBURST_M0(ARBURST_FIFO_M0),
		.ARVALID_M0(ARVALID_FIFO_M0),
		.ARREADY_M0(ARREADY_FIFO_M0),
		// READ DATA0
		.RID_M0(RID_FIFO_M0),
		.RDATA_M0(RDATA_FIFO_M0),
		.RRESP_M0(RRESP_FIFO_M0),
		.RLAST_M0(RLAST_FIFO_M0),
		.RVALID_M0(RVALID_FIFO_M0),
		.RREADY_M0(RREADY_FIFO_M0),
		// READ ADDRESS1
		.ARID_M1(ARID_FIFO_M1),
		.ARADDR_M1(ARADDR_FIFO_M1),
		.ARLEN_M1(ARLEN_FIFO_M1),
		.ARSIZE_M1(ARSIZE_FIFO_M1),
		.ARBURST_M1(ARBURST_FIFO_M1),
		.ARVALID_M1(ARVALID_FIFO_M1),
		.ARREADY_M1(ARREADY_FIFO_M1),
		// READ DATA1
		.RID_M1(RID_FIFO_M1),
		.RDATA_M1(RDATA_FIFO_M1),
		.RRESP_M1(RRESP_FIFO_M1),
		.RLAST_M1(RLAST_FIFO_M1),
		.RVALID_M1(RVALID_FIFO_M1),
		.RREADY_M1(RREADY_FIFO_M1),
		// READ ADDRESS2
		.ARID_M2(ARID_FIFO_M2),
		.ARADDR_M2(ARADDR_FIFO_M2),
		.ARLEN_M2(ARLEN_FIFO_M2),
		.ARSIZE_M2(ARSIZE_FIFO_M2),
		.ARBURST_M2(ARBURST_FIFO_M2),
		.ARVALID_M2(ARVALID_FIFO_M2),
		.ARREADY_M2(ARREADY_FIFO_M2),
		// READ DATA2
		.RID_M2(RID_FIFO_M2),
		.RDATA_M2(RDATA_FIFO_M2),
		.RRESP_M2(RRESP_FIFO_M2),
		.RLAST_M2(RLAST_FIFO_M2),
		.RVALID_M2(RVALID_FIFO_M2),
		.RREADY_M2(RREADY_FIFO_M2),

		// Slave
		///// READ ADDRESS S0 (ROM)/////
		.ARID_S0(ARID_FIFO_S0),
		.ARADDR_S0(ARADDR_FIFO_S0),
		.ARLEN_S0(ARLEN_FIFO_S0),
		.ARSIZE_S0(ARSIZE_FIFO_S0),
		.ARBURST_S0(ARBURST_FIFO_S0),
		.ARVALID_S0(ARVALID_FIFO_S0),
		.ARREADY_S0(ARREADY_FIFO_S0),
		// READ DATA S0
		.RID_S0(RID_FIFO_S0),
		.RDATA_S0(RDATA_FIFO_S0),
		.RRESP_S0(RRESP_FIFO_S0),
		.RLAST_S0(RLAST_FIFO_S0),
		.RVALID_S0(RVALID_FIFO_S0),
		.RREADY_S0(RREADY_FIFO_S0),
		///// READ ADDRESS S1 (IM SRAM)/////
		.ARID_S1(ARID_FIFO_S1),
		.ARADDR_S1(ARADDR_FIFO_S1),
		.ARLEN_S1(ARLEN_FIFO_S1),
		.ARSIZE_S1(ARSIZE_FIFO_S1),
		.ARBURST_S1(ARBURST_FIFO_S1),
		.ARVALID_S1(ARVALID_FIFO_S1),
		.ARREADY_S1(ARREADY_FIFO_S1),
		// READ DATA S1
		.RID_S1(RID_FIFO_S1),
		.RDATA_S1(RDATA_FIFO_S1),
		.RRESP_S1(RRESP_FIFO_S1),
		.RLAST_S1(RLAST_FIFO_S1),
		.RVALID_S1(RVALID_FIFO_S1),
		.RREADY_S1(RREADY_FIFO_S1),
		///// READ ADDRESS S2 (DM SRAM)/////
		.ARID_S2(ARID_FIFO_S2),
		.ARADDR_S2(ARADDR_FIFO_S2),
		.ARLEN_S2(ARLEN_FIFO_S2),
		.ARSIZE_S2(ARSIZE_FIFO_S2),
		.ARBURST_S2(ARBURST_FIFO_S2),
		.ARVALID_S2(ARVALID_FIFO_S2),
		.ARREADY_S2(ARREADY_FIFO_S2),
		// READ DATA S2
		.RID_S2(RID_FIFO_S2),
		.RDATA_S2(RDATA_FIFO_S2),
		.RRESP_S2(RRESP_FIFO_S2),
		.RLAST_S2(RLAST_FIFO_S2),
		.RVALID_S2(RVALID_FIFO_S2),
		.RREADY_S2(RREADY_FIFO_S2),
		///// READ ADDRESS S3 (DMA)/////
		.ARID_S3(ARID_FIFO_S3),
		.ARADDR_S3(ARADDR_FIFO_S3),
		.ARLEN_S3(ARLEN_FIFO_S3),
		.ARSIZE_S3(ARSIZE_FIFO_S3),
		.ARBURST_S3(ARBURST_FIFO_S3),
		.ARVALID_S3(ARVALID_FIFO_S3),
		.ARREADY_S3(ARREADY_FIFO_S3),
		// READ DATA S3
		.RID_S3(RID_FIFO_S3),
		.RDATA_S3(RDATA_FIFO_S3),
		.RRESP_S3(RRESP_FIFO_S3),
		.RLAST_S3(RLAST_FIFO_S3),
		.RVALID_S3(RVALID_FIFO_S3),
		.RREADY_S3(RREADY_FIFO_S3),
		///// READ ADDRESS S4 (WDT)/////
		.ARID_S4(ARID_FIFO_S4),
		.ARADDR_S4(ARADDR_FIFO_S4),
		.ARLEN_S4(ARLEN_FIFO_S4),
		.ARSIZE_S4(ARSIZE_FIFO_S4),
		.ARBURST_S4(ARBURST_FIFO_S4),
		.ARVALID_S4(ARVALID_FIFO_S4),
		.ARREADY_S4(ARREADY_FIFO_S4),
		// READ DATA S4
		.RID_S4(RID_FIFO_S4),
		.RDATA_S4(RDATA_FIFO_S4),
		.RRESP_S4(RRESP_FIFO_S4),
		.RLAST_S4(RLAST_FIFO_S4),
		.RVALID_S4(RVALID_FIFO_S4),
		.RREADY_S4(RREADY_FIFO_S4),
		///// READ ADDRESS S5 (DRAM)/////
		.ARID_S5(ARID_FIFO_S5),
		.ARADDR_S5(ARADDR_FIFO_S5),
		.ARLEN_S5(ARLEN_FIFO_S5),
		.ARSIZE_S5(ARSIZE_FIFO_S5),
		.ARBURST_S5(ARBURST_FIFO_S5),
		.ARVALID_S5(ARVALID_FIFO_S5),
		.ARREADY_S5(ARREADY_FIFO_S5),
		// READ DATA S5
		.RID_S5(RID_FIFO_S5),
		.RDATA_S5(RDATA_FIFO_S5),
		.RRESP_S5(RRESP_FIFO_S5),
		.RLAST_S5(RLAST_FIFO_S5),
		.RVALID_S5(RVALID_FIFO_S5),
		.RREADY_S5(RREADY_FIFO_S5)								
	);


endmodule
