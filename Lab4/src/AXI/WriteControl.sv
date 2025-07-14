
// `include "../include/AXI_define.svh"
// `include "../../src/AXI/WriteChannel/WriteAXI.sv"

module WriteControl(
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

// M1
// WRITE
input  logic[`AXI_ID_BITS-1:0]    AWID_M1,
input  logic[`AXI_ADDR_BITS-1:0]  AWADDR_M1,
input  logic[`AXI_LEN_BITS-1:0]   AWLEN_M1,
input  logic[`AXI_SIZE_BITS-1:0]  AWSIZE_M1,
input  logic[1:0]                 AWBURST_M1,
input  logic                      AWVALID_M1,
output logic                      AWREADY_M1,
input  logic [`AXI_DATA_BITS-1:0] WDATA_M1,
input  logic [`AXI_STRB_BITS-1:0] WSTRB_M1,
input  logic                      WLAST_M1,
input  logic                      WVALID_M1,
output logic                      WREADY_M1,
output logic [`AXI_ID_BITS-1:0]   BID_M1,
output logic [1:0]                BRESP_M1,
output logic                      BVALID_M1,
input  logic                      BREADY_M1,

// M2
// WRITE
input  logic[`AXI_ID_BITS-1:0]    AWID_M2,
input  logic[`AXI_ADDR_BITS-1:0]  AWADDR_M2,
input  logic[`AXI_LEN_BITS-1:0]   AWLEN_M2,
input  logic[`AXI_SIZE_BITS-1:0]  AWSIZE_M2,
input  logic[1:0]                 AWBURST_M2,
input  logic                      AWVALID_M2,
output logic                      AWREADY_M2,
input  logic [`AXI_DATA_BITS-1:0] WDATA_M2,
input  logic [`AXI_STRB_BITS-1:0] WSTRB_M2,
input  logic                      WLAST_M2,
input  logic                      WVALID_M2,
output logic                      WREADY_M2,
output logic [`AXI_ID_BITS-1:0]   BID_M2,
output logic [1:0]                BRESP_M2,
output logic                      BVALID_M2,
input  logic                      BREADY_M2,

//SLAVE INTERFACE
// S0

// S1
// WRITE
output logic [`AXI_IDS_BITS-1:0]  AWID_S1,
output logic[`AXI_ADDR_BITS-1:0]  AWADDR_S1,
output logic[`AXI_LEN_BITS-1:0]   AWLEN_S1,
output logic[`AXI_SIZE_BITS-1:0]  AWSIZE_S1,
output logic[1:0]                 AWBURST_S1,
output logic                      AWVALID_S1,
input  logic                      AWREADY_S1,
output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
output logic                      WLAST_S1,
output logic                      WVALID_S1,
input  logic                      WREADY_S1,
input  logic[`AXI_IDS_BITS-1:0]   BID_S1,
input  logic[1:0]                 BRESP_S1,
input  logic                      BVALID_S1,
output logic                      BREADY_S1,

// S2
// WRITE
output logic [`AXI_IDS_BITS-1:0]  AWID_S2,
output logic[`AXI_ADDR_BITS-1:0]  AWADDR_S2,
output logic[`AXI_LEN_BITS-1:0]   AWLEN_S2,
output logic[`AXI_SIZE_BITS-1:0]  AWSIZE_S2,
output logic[1:0]                 AWBURST_S2,
output logic                      AWVALID_S2,
input  logic                      AWREADY_S2,
output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
output logic                      WLAST_S2,
output logic                      WVALID_S2,
input  logic                      WREADY_S2,
input  logic [`AXI_IDS_BITS-1:0]  BID_S2,
input  logic [1:0]                BRESP_S2,
input  logic                      BVALID_S2,
output logic                      BREADY_S2,

// S3
// WRITE
output logic [`AXI_IDS_BITS-1:0]  AWID_S3,
output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
output logic [`AXI_LEN_BITS-1:0]  AWLEN_S3,
output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
output logic [1:0]                AWBURST_S3,
output logic                      AWVALID_S3,
input  logic                      AWREADY_S3,
output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
output logic                      WLAST_S3,
output logic                      WVALID_S3,
input  logic                      WREADY_S3,
input  logic [`AXI_IDS_BITS-1:0]  BID_S3,
input  logic [1:0]                BRESP_S3,
input  logic                      BVALID_S3,
output logic                      BREADY_S3,

// S4
// WRITE
output logic [`AXI_IDS_BITS-1:0]  AWID_S4,
output logic[`AXI_ADDR_BITS-1:0]  AWADDR_S4,
output logic[`AXI_LEN_BITS-1:0]   AWLEN_S4,
output logic[`AXI_SIZE_BITS-1:0]  AWSIZE_S4,
output logic[1:0]                 AWBURST_S4,
output logic                      AWVALID_S4,
input  logic                      AWREADY_S4,
output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
output logic                      WLAST_S4,
output logic                      WVALID_S4,
input  logic                      WREADY_S4,
input  logic[`AXI_IDS_BITS-1:0]   BID_S4,
input  logic[1:0]                 BRESP_S4,
input  logic                      BVALID_S4,
output logic                      BREADY_S4,

// S5
// WRITE
output logic [`AXI_IDS_BITS-1:0]  AWID_S5,
output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
output logic [`AXI_LEN_BITS-1:0]  AWLEN_S5,
output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
output logic [1:0]                AWBURST_S5,
output logic                      AWVALID_S5,
input  logic                      AWREADY_S5,
output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
output logic                      WLAST_S5,
output logic                      WVALID_S5,
input  logic                      WREADY_S5,
input  logic [`AXI_IDS_BITS-1:0]  BID_S5,
input logic [1:0]                 BRESP_S5,
input logic                       BVALID_S5,
output logic                      BREADY_S5
  
);
////Master//////////////////////////////////////
/////M1
	logic [`AXI_ID_BITS-1:0] AWID_FIFO_M1;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_M1;
	logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_M1;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_M1;
	logic [1:0] AWBURST_FIFO_M1;
	logic AWVALID_FIFO_M1;
	 logic AWREADY_FIFO_M1;
	
	//WRITE DATA M1
	logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_M1;
	logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_M1;
	logic WLAST_FIFO_M1;
	logic WVALID_FIFO_M1;
	 logic WREADY_FIFO_M1;
	
	//WRITE RESPONSE M1
	 logic [`AXI_ID_BITS-1:0] BID_FIFO_M1;
	 logic [1:0] BRESP_FIFO_M1;
	 logic BVALID_FIFO_M1;
	logic BREADY_FIFO_M1;

/////M2
    logic [`AXI_ID_BITS-1:0] AWID_FIFO_M2;
	logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_M2;
	logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_M2;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_M2;
	logic [1:0] AWBURST_FIFO_M2;
	logic AWVALID_FIFO_M2;
	 logic AWREADY_FIFO_M2;
	
	//WRITE DATA M2
	logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_M2;
	logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_M2;
	logic WLAST_FIFO_M2;
	logic WVALID_FIFO_M2;
	 logic WREADY_FIFO_M2;
	
	//WRITE RESPONSE M2
	 logic [`AXI_ID_BITS-1:0] BID_FIFO_M2;
	 logic [1:0] BRESP_FIFO_M2;
	 logic BVALID_FIFO_M2;
	logic BREADY_FIFO_M2;


	/////WRITE ADDRESS S1 (IM SRAM)////
	 logic [`AXI_IDS_BITS-1:0] AWID_FIFO_S1;
	 logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_S1;
	 logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_S1;
	 logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_S1;
	 logic [1:0] AWBURST_FIFO_S1;
	 logic AWVALID_FIFO_S1;
	logic AWREADY_FIFO_S1;
	
	//WRITE DATA S1
	 logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_S1;
	 logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_S1;
	 logic WLAST_FIFO_S1;
	 logic WVALID_FIFO_S1;
	logic WREADY_FIFO_S1;
	
	//WRITE RESPONSE S1
	logic [`AXI_IDS_BITS-1:0] BID_FIFO_S1;
	logic [1:0] BRESP_FIFO_S1;
	logic BVALID_FIFO_S1;
	 logic BREADY_FIFO_S1;

	/////WRITE ADDRESS S2 (DM SRAM)////
	 logic [`AXI_IDS_BITS-1:0] AWID_FIFO_S2;
	 logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_S2;
	 logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_S2;
	 logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_S2;
	 logic [1:0] AWBURST_FIFO_S2;
	 logic AWVALID_FIFO_S2;
	logic AWREADY_FIFO_S2;
	
	//WRITE DATA S2
	 logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_S2;
	 logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_S2;
	 logic WLAST_FIFO_S2;
	 logic WVALID_FIFO_S2;
	logic WREADY_FIFO_S2;
	
	//WRITE RESPONSE S2
	logic [`AXI_IDS_BITS-1:0] BID_FIFO_S2;
	logic [1:0] BRESP_FIFO_S2;
	logic BVALID_FIFO_S2;
	 logic BREADY_FIFO_S2;
	/////WRITE ADDRESS S3 (DMA)////
	 logic [`AXI_IDS_BITS-1:0] AWID_FIFO_S3;
	 logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_S3;
	 logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_S3;
	 logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_S3;
	 logic [1:0] AWBURST_FIFO_S3;
	 logic AWVALID_FIFO_S3;
	logic AWREADY_FIFO_S3;
	
	//WRITE DATA S3
	 logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_S3;
	 logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_S3;
	 logic WLAST_FIFO_S3;
	 logic WVALID_FIFO_S3;
	logic WREADY_FIFO_S3;
	
	//WRITE RESPONSE S3
	logic [`AXI_IDS_BITS-1:0] BID_FIFO_S3;
	logic [1:0] BRESP_FIFO_S3;
	logic BVALID_FIFO_S3;
	 logic BREADY_FIFO_S3;
	/////WRITE ADDRESS S4 (WDT)////
	 logic [`AXI_IDS_BITS-1:0] AWID_FIFO_S4;
	 logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_S4;
	 logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_S4;
	 logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_S4;
	 logic [1:0] AWBURST_FIFO_S4;
	 logic AWVALID_FIFO_S4;
	logic AWREADY_FIFO_S4;
	
	//WRITE DATA S4
	 logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_S4;
	 logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_S4;
	 logic WLAST_FIFO_S4;
	 logic WVALID_FIFO_S4;
	logic WREADY_FIFO_S4;
	
	//WRITE RESPONSE S4
	logic [`AXI_IDS_BITS-1:0] BID_FIFO_S4;
	logic [1:0] BRESP_FIFO_S4;
	logic BVALID_FIFO_S4;
	 logic BREADY_FIFO_S4;
	/////WRITE ADDRESS S5 (DRAM)////
	 logic [`AXI_IDS_BITS-1:0] AWID_FIFO_S5;
	 logic [`AXI_ADDR_BITS-1:0] AWADDR_FIFO_S5;
	 logic [`AXI_LEN_BITS-1:0] AWLEN_FIFO_S5;
	 logic [`AXI_SIZE_BITS-1:0] AWSIZE_FIFO_S5;
	 logic [1:0] AWBURST_FIFO_S5;
	 logic AWVALID_FIFO_S5;
	logic AWREADY_FIFO_S5;
	
	//WRITE DATA S5
	 logic [`AXI_DATA_BITS-1:0] WDATA_FIFO_S5;
	 logic [`AXI_STRB_BITS-1:0] WSTRB_FIFO_S5;
	 logic WLAST_FIFO_S5;
	 logic WVALID_FIFO_S5;
	logic WREADY_FIFO_S5;
	
	//WRITE RESPONSE S5
	logic [`AXI_IDS_BITS-1:0] BID_FIFO_S5;
	logic [1:0] BRESP_FIFO_S5;
	logic BVALID_FIFO_S5;
	 logic BREADY_FIFO_S5;

//////////////MASTER////////////////////////


// /////////M1
// // ====================== M1 AW ======================//
logic   [44:0]  AFIFO_WDATA_AW_M1   , AFIFO_RDATA_AW_M1     , AFIFO_RDATA_T_AW_M1;
logic   [3:0]   R_PTR_GRAY_AW_M1    , R_PTR_Binary_AW_M1    , W_PTR_GRAY_AW_M1;
logic           W_FULL_AW_M1        , R_EMPTY_AW_M1;
assign AFIFO_WDATA_AW_M1 = {AWID_M1, AWADDR_M1, AWLEN_M1, AWSIZE_M1, AWBURST_M1};
assign {AWID_FIFO_M1, AWADDR_FIFO_M1, AWLEN_FIFO_M1, AWSIZE_FIFO_M1, AWBURST_FIFO_M1} = AFIFO_RDATA_T_AW_M1;
assign AWREADY_M1 = ~W_FULL_AW_M1;
assign AWVALID_FIFO_M1 = ~R_EMPTY_AW_M1;
AFIFO_Tx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_M1
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .W_DATA(AFIFO_WDATA_AW_M1),
    .WEN(AWVALID_M1),
    .W_FULL(W_FULL_AW_M1),
    .R_PTR_GRAY(R_PTR_GRAY_AW_M1),
    .R_PTR_Binary(R_PTR_Binary_AW_M1),
    .W_PTR_GRAY(W_PTR_GRAY_AW_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_M1)
);
AFIFO_Rx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_M1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_AW_M1),
    .REN(AWREADY_FIFO_M1),
    .R_EMPTY(R_EMPTY_AW_M1),
    .W_PTR_GRAY(W_PTR_GRAY_AW_M1),
    .R_PTR_GRAY(R_PTR_GRAY_AW_M1),
    .R_PTR_Binary(R_PTR_Binary_AW_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_M1)
);
//====================== M1 AW ======================//
//====================== M1  W ======================//
logic   [36:0]  AFIFO_WDATA_W_M1    , AFIFO_RDATA_W_M1      , AFIFO_RDATA_T_W_M1;
logic   [3:0]   R_PTR_GRAY_W_M1     , R_PTR_Binary_W_M1     , W_PTR_GRAY_W_M1;
logic           W_FULL_W_M1         , R_EMPTY_W_M1;
assign AFIFO_WDATA_W_M1 = {WDATA_M1, WSTRB_M1, WLAST_M1};
assign {WDATA_FIFO_M1, WSTRB_FIFO_M1, WLAST_FIFO_M1} = AFIFO_RDATA_T_W_M1;
assign WREADY_M1 = ~W_FULL_W_M1;
assign WVALID_FIFO_M1 = ~R_EMPTY_W_M1;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_M1
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .W_DATA(AFIFO_WDATA_W_M1),
    .WEN(WVALID_M1),
    .W_FULL(W_FULL_W_M1),
    .R_PTR_GRAY(R_PTR_GRAY_W_M1),
    .R_PTR_Binary(R_PTR_Binary_W_M1),
    .W_PTR_GRAY(W_PTR_GRAY_W_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_W_M1)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_M1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_W_M1),
    .REN(WREADY_FIFO_M1),
    .R_EMPTY(R_EMPTY_W_M1),
    .W_PTR_GRAY(W_PTR_GRAY_W_M1),
    .R_PTR_GRAY(R_PTR_GRAY_W_M1),
    .R_PTR_Binary(R_PTR_Binary_W_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_W_M1)
);
//====================== M1  W ======================//
//====================== M1  B ======================//
logic   [5:0]   AFIFO_WDATA_B_M1    , AFIFO_RDATA_B_M1      , AFIFO_RDATA_T_B_M1;
logic   [3:0]   R_PTR_GRAY_B_M1     , R_PTR_Binary_B_M1     , W_PTR_GRAY_B_M1;
logic           W_FULL_B_M1         , R_EMPTY_B_M1;
assign AFIFO_WDATA_B_M1 = {BID_FIFO_M1, BRESP_FIFO_M1};
assign {BID_M1, BRESP_M1} = AFIFO_RDATA_T_B_M1;
assign BREADY_FIFO_M1 = ~W_FULL_B_M1;
assign BVALID_M1 = ~R_EMPTY_B_M1;
AFIFO_Tx#(
    .DATA_WIDTH(6),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_M1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_B_M1),
    .WEN(BVALID_FIFO_M1),
    .W_FULL(W_FULL_B_M1),
    .R_PTR_GRAY(R_PTR_GRAY_B_M1),
    .R_PTR_Binary(R_PTR_Binary_B_M1),
    .W_PTR_GRAY(W_PTR_GRAY_B_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_B_M1)
);
AFIFO_Rx#(
    .DATA_WIDTH(6),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_M1
(
    .CLK(CPU_CLK_i),
    .RSTn(CPU_RST_i),
    .R_DATA(AFIFO_RDATA_B_M1),
    .REN(BREADY_M1),
    .R_EMPTY(R_EMPTY_B_M1),
    .W_PTR_GRAY(W_PTR_GRAY_B_M1),
    .R_PTR_GRAY(R_PTR_GRAY_B_M1),
    .R_PTR_Binary(R_PTR_Binary_B_M1),
    .R_DATA_Tx(AFIFO_RDATA_T_B_M1)
);
//====================== M1  B ======================//
/////////M2
//====================== M2 AW ======================//
logic   [44:0]  AFIFO_WDATA_AW_M2   , AFIFO_RDATA_AW_M2     , AFIFO_RDATA_T_AW_M2;
logic   [3:0]   R_PTR_GRAY_AW_M2    , R_PTR_Binary_AW_M2    , W_PTR_GRAY_AW_M2;
logic           W_FULL_AW_M2        , R_EMPTY_AW_M2;
assign AFIFO_WDATA_AW_M2 = {AWID_M2, AWADDR_M2, AWLEN_M2, AWSIZE_M2, AWBURST_M2};
assign {AWID_FIFO_M2, AWADDR_FIFO_M2, AWLEN_FIFO_M2, AWSIZE_FIFO_M2, AWBURST_FIFO_M2} = AFIFO_RDATA_T_AW_M2;
assign AWREADY_M2 = ~W_FULL_AW_M2;
assign AWVALID_FIFO_M2 = ~R_EMPTY_AW_M2;
AFIFO_Tx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_M2
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .W_DATA(AFIFO_WDATA_AW_M2),
    .WEN(AWVALID_M2),
    .W_FULL(W_FULL_AW_M2),
    .R_PTR_GRAY(R_PTR_GRAY_AW_M2),
    .R_PTR_Binary(R_PTR_Binary_AW_M2),
    .W_PTR_GRAY(W_PTR_GRAY_AW_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_M2)
);
AFIFO_Rx#(
    .DATA_WIDTH(45),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_M2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_AW_M2),
    .REN(AWREADY_FIFO_M2),
    .R_EMPTY(R_EMPTY_AW_M2),
    .W_PTR_GRAY(W_PTR_GRAY_AW_M2),
    .R_PTR_GRAY(R_PTR_GRAY_AW_M2),
    .R_PTR_Binary(R_PTR_Binary_AW_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_M2)
);
//====================== M2 AW ======================//
//====================== M2  W ======================//
logic   [36:0]  AFIFO_WDATA_W_M2    , AFIFO_RDATA_W_M2      , AFIFO_RDATA_T_W_M2;
logic   [3:0]   R_PTR_GRAY_W_M2     , R_PTR_Binary_W_M2     , W_PTR_GRAY_W_M2;
logic           W_FULL_W_M2         , R_EMPTY_W_M2;
assign AFIFO_WDATA_W_M2 = {WDATA_M2, WSTRB_M2, WLAST_M2};
assign {WDATA_FIFO_M2, WSTRB_FIFO_M2, WLAST_FIFO_M2} = AFIFO_RDATA_T_W_M2;
assign WREADY_M2 = ~W_FULL_W_M2;
assign WVALID_FIFO_M2 = ~R_EMPTY_W_M2;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_M2
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .W_DATA(AFIFO_WDATA_W_M2),
    .WEN(WVALID_M2),
    .W_FULL(W_FULL_W_M2),
    .R_PTR_GRAY(R_PTR_GRAY_W_M2),
    .R_PTR_Binary(R_PTR_Binary_W_M2),
    .W_PTR_GRAY(W_PTR_GRAY_W_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_W_M2)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_M2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_W_M2),
    .REN(WREADY_FIFO_M2),
    .R_EMPTY(R_EMPTY_W_M2),
    .W_PTR_GRAY(W_PTR_GRAY_W_M2),
    .R_PTR_GRAY(R_PTR_GRAY_W_M2),
    .R_PTR_Binary(R_PTR_Binary_W_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_W_M2)
);
//====================== M2  W ======================//
//====================== M2  B ======================//
logic   [5:0]   AFIFO_WDATA_B_M2    , AFIFO_RDATA_B_M2      , AFIFO_RDATA_T_B_M2;
logic   [3:0]   R_PTR_GRAY_B_M2     , R_PTR_Binary_B_M2     , W_PTR_GRAY_B_M2;
logic           W_FULL_B_M2         , R_EMPTY_B_M2;
assign AFIFO_WDATA_B_M2 = {BID_FIFO_M2, BRESP_FIFO_M2};
assign {BID_M2, BRESP_M2} = AFIFO_RDATA_T_B_M2;
assign BREADY_FIFO_M2 = ~W_FULL_B_M2;
assign BVALID_M2 = ~R_EMPTY_B_M2;
AFIFO_Tx#(
    .DATA_WIDTH(6),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_M2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_B_M2),
    .WEN(BVALID_FIFO_M2),
    .W_FULL(W_FULL_B_M2),
    .R_PTR_GRAY(R_PTR_GRAY_B_M2),
    .R_PTR_Binary(R_PTR_Binary_B_M2),
    .W_PTR_GRAY(W_PTR_GRAY_B_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_B_M2)
);
AFIFO_Rx#(
    .DATA_WIDTH(6),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_M2
(
    .CLK(DMA_CLK_i),
    .RSTn(DMA_RST_i),
    .R_DATA(AFIFO_RDATA_B_M2),
    .REN(BREADY_M2),
    .R_EMPTY(R_EMPTY_B_M2),
    .W_PTR_GRAY(W_PTR_GRAY_B_M2),
    .R_PTR_GRAY(R_PTR_GRAY_B_M2),
    .R_PTR_Binary(R_PTR_Binary_B_M2),
    .R_DATA_Tx(AFIFO_RDATA_T_B_M2)
);
// //====================== M2  B ======================//


// /////////////////SLAVE//////////////////
//====================== S1 AW ======================//
logic   [48:0]  AFIFO_WDATA_AW_S1   , AFIFO_RDATA_AW_S1     , AFIFO_RDATA_T_AW_S1;
logic   [3:0]   R_PTR_GRAY_AW_S1    , R_PTR_Binary_AW_S1    , W_PTR_GRAY_AW_S1;
logic           W_FULL_AW_S1        , R_EMPTY_AW_S1;
assign AFIFO_WDATA_AW_S1 = {AWID_FIFO_S1, AWADDR_FIFO_S1, AWLEN_FIFO_S1, AWSIZE_FIFO_S1, AWBURST_FIFO_S1};
assign {AWID_S1, AWADDR_S1, AWLEN_S1, AWSIZE_S1, AWBURST_S1} = AFIFO_RDATA_T_AW_S1;
assign AWREADY_FIFO_S1 = ~W_FULL_AW_S1;
assign AWVALID_S1 = ~R_EMPTY_AW_S1;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_S1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AW_S1),
    .WEN(AWVALID_FIFO_S1),
    .W_FULL(W_FULL_AW_S1),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S1),
    .R_PTR_Binary(R_PTR_Binary_AW_S1),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S1)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_S1
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AW_S1),
    .REN(AWREADY_S1),
    .R_EMPTY(R_EMPTY_AW_S1),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S1),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S1),
    .R_PTR_Binary(R_PTR_Binary_AW_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S1)
);
//====================== S1 AW ======================//
//====================== S1  W ======================//
logic   [36:0]  AFIFO_WDATA_W_S1    , AFIFO_RDATA_W_S1      , AFIFO_RDATA_T_W_S1;
logic   [3:0]   R_PTR_GRAY_W_S1     , R_PTR_Binary_W_S1     , W_PTR_GRAY_W_S1;
logic           W_FULL_W_S1         , R_EMPTY_W_S1;
assign AFIFO_WDATA_W_S1 = {WDATA_FIFO_S1, WSTRB_FIFO_S1, WLAST_FIFO_S1};
assign {WDATA_S1, WSTRB_S1, WLAST_S1} = AFIFO_RDATA_T_W_S1;
assign WREADY_FIFO_S1 = ~W_FULL_W_S1;
assign WVALID_S1 = ~R_EMPTY_W_S1;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_S1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_W_S1),
    .WEN(WVALID_FIFO_S1),
    .W_FULL(W_FULL_W_S1),
    .R_PTR_GRAY(R_PTR_GRAY_W_S1),
    .R_PTR_Binary(R_PTR_Binary_W_S1),
    .W_PTR_GRAY(W_PTR_GRAY_W_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S1)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_S1
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_W_S1),
    .REN(WREADY_S1),
    .R_EMPTY(R_EMPTY_W_S1),
    .W_PTR_GRAY(W_PTR_GRAY_W_S1),
    .R_PTR_GRAY(R_PTR_GRAY_W_S1),
    .R_PTR_Binary(R_PTR_Binary_W_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S1)
);
//====================== S1  W ======================//
//====================== S1  B ======================//
logic   [9:0]   AFIFO_WDATA_B_S1    , AFIFO_RDATA_B_S1      , AFIFO_RDATA_T_B_S1;
logic   [3:0]   R_PTR_GRAY_B_S1     , R_PTR_Binary_B_S1     , W_PTR_GRAY_B_S1;
logic           W_FULL_B_S1         , R_EMPTY_B_S1;
assign AFIFO_WDATA_B_S1 = {BID_S1, BRESP_S1};
assign {BID_FIFO_S1, BRESP_FIFO_S1} = AFIFO_RDATA_T_B_S1;
assign BREADY_S1 = ~W_FULL_B_S1;
assign BVALID_FIFO_S1 = ~R_EMPTY_B_S1;
AFIFO_Tx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_S1
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .W_DATA(AFIFO_WDATA_B_S1),
    .WEN(BVALID_S1),
    .W_FULL(W_FULL_B_S1),
    .R_PTR_GRAY(R_PTR_GRAY_B_S1),
    .R_PTR_Binary(R_PTR_Binary_B_S1),
    .W_PTR_GRAY(W_PTR_GRAY_B_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S1)
);
AFIFO_Rx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_S1
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_B_S1),
    .REN(BREADY_FIFO_S1),
    .R_EMPTY(R_EMPTY_B_S1),
    .W_PTR_GRAY(W_PTR_GRAY_B_S1),
    .R_PTR_GRAY(R_PTR_GRAY_B_S1),
    .R_PTR_Binary(R_PTR_Binary_B_S1),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S1)
);
//====================== S1  B ======================//
//====================== S2 AW ======================//
logic   [48:0]  AFIFO_WDATA_AW_S2   , AFIFO_RDATA_AW_S2     , AFIFO_RDATA_T_AW_S2;
logic   [3:0]   R_PTR_GRAY_AW_S2    , R_PTR_Binary_AW_S2    , W_PTR_GRAY_AW_S2;
logic           W_FULL_AW_S2        , R_EMPTY_AW_S2;
assign AFIFO_WDATA_AW_S2 = {AWID_FIFO_S2, AWADDR_FIFO_S2, AWLEN_FIFO_S2, AWSIZE_FIFO_S2, AWBURST_FIFO_S2};
assign {AWID_S2, AWADDR_S2, AWLEN_S2, AWSIZE_S2, AWBURST_S2} = AFIFO_RDATA_T_AW_S2;
assign AWREADY_FIFO_S2 = ~W_FULL_AW_S2;
assign AWVALID_S2 = ~R_EMPTY_AW_S2;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_S2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AW_S2),
    .WEN(AWVALID_FIFO_S2),
    .W_FULL(W_FULL_AW_S2),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S2),
    .R_PTR_Binary(R_PTR_Binary_AW_S2),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S2)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_S2
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AW_S2),
    .REN(AWREADY_S2),
    .R_EMPTY(R_EMPTY_AW_S2),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S2),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S2),
    .R_PTR_Binary(R_PTR_Binary_AW_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S2)
);
//====================== S2 AW ======================//
//====================== S2  W ======================//
logic   [36:0]  AFIFO_WDATA_W_S2    , AFIFO_RDATA_W_S2      , AFIFO_RDATA_T_W_S2;
logic   [3:0]   R_PTR_GRAY_W_S2     , R_PTR_Binary_W_S2     , W_PTR_GRAY_W_S2;
logic           W_FULL_W_S2         , R_EMPTY_W_S2;
assign AFIFO_WDATA_W_S2 = {WDATA_FIFO_S2, WSTRB_FIFO_S2, WLAST_FIFO_S2};
assign {WDATA_S2, WSTRB_S2, WLAST_S2} = AFIFO_RDATA_T_W_S2;
assign WREADY_FIFO_S2 = ~W_FULL_W_S2;
assign WVALID_S2 = ~R_EMPTY_W_S2;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_S2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_W_S2),
    .WEN(WVALID_FIFO_S2),
    .W_FULL(W_FULL_W_S2),
    .R_PTR_GRAY(R_PTR_GRAY_W_S2),
    .R_PTR_Binary(R_PTR_Binary_W_S2),
    .W_PTR_GRAY(W_PTR_GRAY_W_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S2)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_S2
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_W_S2),
    .REN(WREADY_S2),
    .R_EMPTY(R_EMPTY_W_S2),
    .W_PTR_GRAY(W_PTR_GRAY_W_S2),
    .R_PTR_GRAY(R_PTR_GRAY_W_S2),
    .R_PTR_Binary(R_PTR_Binary_W_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S2)
);
//====================== S2  W ======================//
//====================== S2  B ======================//
logic   [9:0]   AFIFO_WDATA_B_S2    , AFIFO_RDATA_B_S2      , AFIFO_RDATA_T_B_S2;
logic   [3:0]   R_PTR_GRAY_B_S2     , R_PTR_Binary_B_S2     , W_PTR_GRAY_B_S2;
logic           W_FULL_B_S2         , R_EMPTY_B_S2;
assign AFIFO_WDATA_B_S2 = {BID_S2, BRESP_S2};
assign {BID_FIFO_S2, BRESP_FIFO_S2} = AFIFO_RDATA_T_B_S2;
assign BREADY_S2 = ~W_FULL_B_S2;
assign BVALID_FIFO_S2 = ~R_EMPTY_B_S2;
AFIFO_Tx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_S2
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .W_DATA(AFIFO_WDATA_B_S2),
    .WEN(BVALID_S2),
    .W_FULL(W_FULL_B_S2),
    .R_PTR_GRAY(R_PTR_GRAY_B_S2),
    .R_PTR_Binary(R_PTR_Binary_B_S2),
    .W_PTR_GRAY(W_PTR_GRAY_B_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S2)
);
AFIFO_Rx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_S2
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_B_S2),
    .REN(BREADY_FIFO_S2),
    .R_EMPTY(R_EMPTY_B_S2),
    .W_PTR_GRAY(W_PTR_GRAY_B_S2),
    .R_PTR_GRAY(R_PTR_GRAY_B_S2),
    .R_PTR_Binary(R_PTR_Binary_B_S2),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S2)
);
//====================== S2  B ======================//
//====================== S3 AW ======================//
logic   [48:0]  AFIFO_WDATA_AW_S3   , AFIFO_RDATA_AW_S3     , AFIFO_RDATA_T_AW_S3;
logic   [3:0]   R_PTR_GRAY_AW_S3    , R_PTR_Binary_AW_S3    , W_PTR_GRAY_AW_S3;
logic           W_FULL_AW_S3        , R_EMPTY_AW_S3;
assign AFIFO_WDATA_AW_S3 = {AWID_FIFO_S3, AWADDR_FIFO_S3, AWLEN_FIFO_S3, AWSIZE_FIFO_S3, AWBURST_FIFO_S3};
assign {AWID_S3, AWADDR_S3, AWLEN_S3, AWSIZE_S3, AWBURST_S3} = AFIFO_RDATA_T_AW_S3;
assign AWREADY_FIFO_S3 = ~W_FULL_AW_S3;
assign AWVALID_S3 = ~R_EMPTY_AW_S3;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_S3
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AW_S3),
    .WEN(AWVALID_FIFO_S3),
    .W_FULL(W_FULL_AW_S3),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S3),
    .R_PTR_Binary(R_PTR_Binary_AW_S3),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S3)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_S3
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AW_S3),
    .REN(AWREADY_S3),
    .R_EMPTY(R_EMPTY_AW_S3),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S3),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S3),
    .R_PTR_Binary(R_PTR_Binary_AW_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S3)
);
//====================== S3 AW ======================//
//====================== S3  W ======================//
logic   [36:0]  AFIFO_WDATA_W_S3    , AFIFO_RDATA_W_S3      , AFIFO_RDATA_T_W_S3;
logic   [3:0]   R_PTR_GRAY_W_S3     , R_PTR_Binary_W_S3     , W_PTR_GRAY_W_S3;
logic           W_FULL_W_S3         , R_EMPTY_W_S3;
assign AFIFO_WDATA_W_S3 = {WDATA_FIFO_S3, WSTRB_FIFO_S3, WLAST_FIFO_S3};
assign {WDATA_S3, WSTRB_S3, WLAST_S3} = AFIFO_RDATA_T_W_S3;
assign WREADY_FIFO_S3 = ~W_FULL_W_S3;
assign WVALID_S3 = ~R_EMPTY_W_S3;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_S3
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_W_S3),
    .WEN(WVALID_FIFO_S3),
    .W_FULL(W_FULL_W_S3),
    .R_PTR_GRAY(R_PTR_GRAY_W_S3),
    .R_PTR_Binary(R_PTR_Binary_W_S3),
    .W_PTR_GRAY(W_PTR_GRAY_W_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S3)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_S3
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .R_DATA(AFIFO_RDATA_W_S3),
    .REN(WREADY_S3),
    .R_EMPTY(R_EMPTY_W_S3),
    .W_PTR_GRAY(W_PTR_GRAY_W_S3),
    .R_PTR_GRAY(R_PTR_GRAY_W_S3),
    .R_PTR_Binary(R_PTR_Binary_W_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S3)
);
//====================== S3  W ======================//
//====================== S3  B ======================//
logic   [9:0]   AFIFO_WDATA_B_S3    , AFIFO_RDATA_B_S3      , AFIFO_RDATA_T_B_S3;
logic   [3:0]   R_PTR_GRAY_B_S3     , R_PTR_Binary_B_S3     , W_PTR_GRAY_B_S3;
logic           W_FULL_B_S3         , R_EMPTY_B_S3;
assign AFIFO_WDATA_B_S3 = {BID_S3, BRESP_S3};
assign {BID_FIFO_S3, BRESP_FIFO_S3} = AFIFO_RDATA_T_B_S3;
assign BREADY_S3 = ~W_FULL_B_S3;
assign BVALID_FIFO_S3 = ~R_EMPTY_B_S3;
AFIFO_Tx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_S3
(
    .CLK(SRAM_CLK_i),
    .RSTn(SRAM_RST_i),
    .W_DATA(AFIFO_WDATA_B_S3),
    .WEN(BVALID_S3),
    .W_FULL(W_FULL_B_S3),
    .R_PTR_GRAY(R_PTR_GRAY_B_S3),
    .R_PTR_Binary(R_PTR_Binary_B_S3),
    .W_PTR_GRAY(W_PTR_GRAY_B_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S3)
);
AFIFO_Rx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_S3
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_B_S3),
    .REN(BREADY_FIFO_S3),
    .R_EMPTY(R_EMPTY_B_S3),
    .W_PTR_GRAY(W_PTR_GRAY_B_S3),
    .R_PTR_GRAY(R_PTR_GRAY_B_S3),
    .R_PTR_Binary(R_PTR_Binary_B_S3),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S3)
);
//====================== S3  B ======================//
//====================== S4 AW ======================//
logic   [48:0]  AFIFO_WDATA_AW_S4   , AFIFO_RDATA_AW_S4     , AFIFO_RDATA_T_AW_S4;
logic   [3:0]   R_PTR_GRAY_AW_S4    , R_PTR_Binary_AW_S4    , W_PTR_GRAY_AW_S4;
logic           W_FULL_AW_S4        , R_EMPTY_AW_S4;
assign AFIFO_WDATA_AW_S4 = {AWID_FIFO_S4, AWADDR_FIFO_S4, AWLEN_FIFO_S4, AWSIZE_FIFO_S4, AWBURST_FIFO_S4};
assign {AWID_S4, AWADDR_S4, AWLEN_S4, AWSIZE_S4, AWBURST_S4} = AFIFO_RDATA_T_AW_S4;
assign AWREADY_FIFO_S4 = ~W_FULL_AW_S4;
assign AWVALID_S4 = ~R_EMPTY_AW_S4;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_S4
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AW_S4),
    .WEN(AWVALID_FIFO_S4),
    .W_FULL(W_FULL_AW_S4),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S4),
    .R_PTR_Binary(R_PTR_Binary_AW_S4),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S4)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_S4
(
    .CLK(WDT_CLK_i),
    .RSTn(WDT_RST_i),
    .R_DATA(AFIFO_RDATA_AW_S4),
    .REN(AWREADY_S4),
    .R_EMPTY(R_EMPTY_AW_S4),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S4),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S4),
    .R_PTR_Binary(R_PTR_Binary_AW_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S4)
);
//====================== S4 AW ======================//
//====================== S4  W ======================//
logic   [36:0]  AFIFO_WDATA_W_S4    , AFIFO_RDATA_W_S4      , AFIFO_RDATA_T_W_S4;
logic   [3:0]   R_PTR_GRAY_W_S4     , R_PTR_Binary_W_S4     , W_PTR_GRAY_W_S4;
logic           W_FULL_W_S4         , R_EMPTY_W_S4;
assign AFIFO_WDATA_W_S4 = {WDATA_FIFO_S4, WSTRB_FIFO_S4, WLAST_FIFO_S4};
assign {WDATA_S4, WSTRB_S4, WLAST_S4} = AFIFO_RDATA_T_W_S4;
assign WREADY_FIFO_S4 = ~W_FULL_W_S4;
assign WVALID_S4 = ~R_EMPTY_W_S4;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_S4
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_W_S4),
    .WEN(WVALID_FIFO_S4),
    .W_FULL(W_FULL_W_S4),
    .R_PTR_GRAY(R_PTR_GRAY_W_S4),
    .R_PTR_Binary(R_PTR_Binary_W_S4),
    .W_PTR_GRAY(W_PTR_GRAY_W_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S4)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_S4
(
    .CLK(WDT_CLK_i),
    .RSTn(WDT_RST_i),
    .R_DATA(AFIFO_RDATA_W_S4),
    .REN(WREADY_S4),
    .R_EMPTY(R_EMPTY_W_S4),
    .W_PTR_GRAY(W_PTR_GRAY_W_S4),
    .R_PTR_GRAY(R_PTR_GRAY_W_S4),
    .R_PTR_Binary(R_PTR_Binary_W_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S4)
);
//====================== S4  W ======================//
//====================== S4  B ======================//
logic   [9:0]   AFIFO_WDATA_B_S4    , AFIFO_RDATA_B_S4      , AFIFO_RDATA_T_B_S4;
logic   [3:0]   R_PTR_GRAY_B_S4     , R_PTR_Binary_B_S4     , W_PTR_GRAY_B_S4;
logic           W_FULL_B_S4         , R_EMPTY_B_S4;
assign AFIFO_WDATA_B_S4 = {BID_S4, BRESP_S4};
assign {BID_FIFO_S4, BRESP_FIFO_S4} = AFIFO_RDATA_T_B_S4;
assign BREADY_S4 = ~W_FULL_B_S4;
assign BVALID_FIFO_S4 = ~R_EMPTY_B_S4;
AFIFO_Tx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_S4
(
    .CLK(WDT_CLK_i),
    .RSTn(WDT_RST_i),
    .W_DATA(AFIFO_WDATA_B_S4),
    .WEN(BVALID_S4),
    .W_FULL(W_FULL_B_S4),
    .R_PTR_GRAY(R_PTR_GRAY_B_S4),
    .R_PTR_Binary(R_PTR_Binary_B_S4),
    .W_PTR_GRAY(W_PTR_GRAY_B_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S4)
);
AFIFO_Rx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_S4
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_B_S4),
    .REN(BREADY_FIFO_S4),
    .R_EMPTY(R_EMPTY_B_S4),
    .W_PTR_GRAY(W_PTR_GRAY_B_S4),
    .R_PTR_GRAY(R_PTR_GRAY_B_S4),
    .R_PTR_Binary(R_PTR_Binary_B_S4),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S4)
);
//====================== S4  B ======================//
//====================== S5 AW ======================//
logic   [48:0]  AFIFO_WDATA_AW_S5   , AFIFO_RDATA_AW_S5     , AFIFO_RDATA_T_AW_S5;
logic   [3:0]   R_PTR_GRAY_AW_S5    , R_PTR_Binary_AW_S5    , W_PTR_GRAY_AW_S5;
logic           W_FULL_AW_S5        , R_EMPTY_AW_S5;
assign AFIFO_WDATA_AW_S5 = {AWID_FIFO_S5, AWADDR_FIFO_S5, AWLEN_FIFO_S5, AWSIZE_FIFO_S5, AWBURST_FIFO_S5};
assign {AWID_S5, AWADDR_S5, AWLEN_S5, AWSIZE_S5, AWBURST_S5} = AFIFO_RDATA_T_AW_S5;
assign AWREADY_FIFO_S5 = ~W_FULL_AW_S5;
assign AWVALID_S5 = ~R_EMPTY_AW_S5;
AFIFO_Tx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Tx_AW_S5
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_AW_S5),
    .WEN(AWVALID_FIFO_S5),
    .W_FULL(W_FULL_AW_S5),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S5),
    .R_PTR_Binary(R_PTR_Binary_AW_S5),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S5)
);
AFIFO_Rx#(
    .DATA_WIDTH(49),
    .ADDR_WIDTH(4)
) AFIFO_Rx_AW_S5
(
    .CLK(DRAM_CLK_i),
    .RSTn(DRAM_RST_i),
    .R_DATA(AFIFO_RDATA_AW_S5),
    .REN(AWREADY_S5),
    .R_EMPTY(R_EMPTY_AW_S5),
    .W_PTR_GRAY(W_PTR_GRAY_AW_S5),
    .R_PTR_GRAY(R_PTR_GRAY_AW_S5),
    .R_PTR_Binary(R_PTR_Binary_AW_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_AW_S5)
);
//====================== S5 AW ======================//
//====================== S5  W ======================//
logic   [36:0]  AFIFO_WDATA_W_S5    , AFIFO_RDATA_W_S5      , AFIFO_RDATA_T_W_S5;
logic   [3:0]   R_PTR_GRAY_W_S5     , R_PTR_Binary_W_S5     , W_PTR_GRAY_W_S5;
logic           W_FULL_W_S5         , R_EMPTY_W_S5;
assign AFIFO_WDATA_W_S5 = {WDATA_FIFO_S5, WSTRB_FIFO_S5, WLAST_FIFO_S5};
assign {WDATA_S5, WSTRB_S5, WLAST_S5} = AFIFO_RDATA_T_W_S5;
assign WREADY_FIFO_S5 = ~W_FULL_W_S5;
assign WVALID_S5 = ~R_EMPTY_W_S5;
AFIFO_Tx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Tx_W_S5
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .W_DATA(AFIFO_WDATA_W_S5),
    .WEN(WVALID_FIFO_S5),
    .W_FULL(W_FULL_W_S5),
    .R_PTR_GRAY(R_PTR_GRAY_W_S5),
    .R_PTR_Binary(R_PTR_Binary_W_S5),
    .W_PTR_GRAY(W_PTR_GRAY_W_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S5)
);
AFIFO_Rx#(
    .DATA_WIDTH(37),
    .ADDR_WIDTH(4)
) AFIFO_Rx_W_S5
(
    .CLK(DRAM_CLK_i),
    .RSTn(DRAM_RST_i),
    .R_DATA(AFIFO_RDATA_W_S5),
    .REN(WREADY_S5),
    .R_EMPTY(R_EMPTY_W_S5),
    .W_PTR_GRAY(W_PTR_GRAY_W_S5),
    .R_PTR_GRAY(R_PTR_GRAY_W_S5),
    .R_PTR_Binary(R_PTR_Binary_W_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_W_S5)
);
//====================== S5  W ======================//
//====================== S5  B ======================//
logic   [9:0]   AFIFO_WDATA_B_S5    , AFIFO_RDATA_B_S5      , AFIFO_RDATA_T_B_S5;
logic   [3:0]   R_PTR_GRAY_B_S5     , R_PTR_Binary_B_S5     , W_PTR_GRAY_B_S5;
logic           W_FULL_B_S5         , R_EMPTY_B_S5;
assign AFIFO_WDATA_B_S5 = {BID_S5, BRESP_S5};
assign {BID_FIFO_S5, BRESP_FIFO_S5} = AFIFO_RDATA_T_B_S5;
assign BREADY_S5 = ~W_FULL_B_S5;
assign BVALID_FIFO_S5 = ~R_EMPTY_B_S5;
AFIFO_Tx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Tx_B_S5
(
    .CLK(DRAM_CLK_i),
    .RSTn(DRAM_RST_i),
    .W_DATA(AFIFO_WDATA_B_S5),
    .WEN(BVALID_S5),
    .W_FULL(W_FULL_B_S5),
    .R_PTR_GRAY(R_PTR_GRAY_B_S5),
    .R_PTR_Binary(R_PTR_Binary_B_S5),
    .W_PTR_GRAY(W_PTR_GRAY_B_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S5)
);
AFIFO_Rx#(
    .DATA_WIDTH(10),
    .ADDR_WIDTH(4)
) AFIFO_Rx_B_S5
(
    .CLK(AXI_CLK_i),
    .RSTn(AXI_RST_i),
    .R_DATA(AFIFO_RDATA_B_S5),
    .REN(BREADY_FIFO_S5),
    .R_EMPTY(R_EMPTY_B_S5),
    .W_PTR_GRAY(W_PTR_GRAY_B_S5),
    .R_PTR_GRAY(R_PTR_GRAY_B_S5),
    .R_PTR_Binary(R_PTR_Binary_B_S5),
    .R_DATA_Tx(AFIFO_RDATA_T_B_S5)
);
// //====================== S5  B ======================//
/////////////////////////////////////
	WriteAXI writeAXI
	(
		.clk(AXI_CLK_i),
		.rst(AXI_RST_i),

		// Master
        // M1
		// WRITE ADDRESS
		.AWID_M1(AWID_FIFO_M1),
		.AWADDR_M1(AWADDR_FIFO_M1),
		.AWLEN_M1(AWLEN_FIFO_M1),
		.AWSIZE_M1(AWSIZE_FIFO_M1),
		.AWBURST_M1(AWBURST_FIFO_M1),
		.AWVALID_M1(AWVALID_FIFO_M1),
		.AWREADY_M1(AWREADY_FIFO_M1),
		// WRITE DATA
		.WDATA_M1(WDATA_FIFO_M1),
		.WSTRB_M1(WSTRB_FIFO_M1),
		.WLAST_M1(WLAST_FIFO_M1),
		.WVALID_M1(WVALID_FIFO_M1),
		.WREADY_M1(WREADY_FIFO_M1),
		// WRITE RESPONSE
		.BID_M1(BID_FIFO_M1),
		.BRESP_M1(BRESP_FIFO_M1),
		.BVALID_M1(BVALID_FIFO_M1),
		.BREADY_M1(BREADY_FIFO_M1),

        // M2
        // WRITE ADDRESS
        .AWID_M2(AWID_FIFO_M2),
		.AWADDR_M2(AWADDR_FIFO_M2),
		.AWLEN_M2(AWLEN_FIFO_M2),
		.AWSIZE_M2(AWSIZE_FIFO_M2),
		.AWBURST_M2(AWBURST_FIFO_M2),
		.AWVALID_M2(AWVALID_FIFO_M2),
		.AWREADY_M2(AWREADY_FIFO_M2),
		// WRITE DATA
		.WDATA_M2(WDATA_FIFO_M2),
		.WSTRB_M2(WSTRB_FIFO_M2),
		.WLAST_M2(WLAST_FIFO_M2),
		.WVALID_M2(WVALID_FIFO_M2),
		.WREADY_M2(WREADY_FIFO_M2),
		// WRITE RESPONSE
		.BID_M2(BID_FIFO_M2),
		.BRESP_M2(BRESP_FIFO_M2),
		.BVALID_M2(BVALID_FIFO_M2),
		.BREADY_M2(BREADY_FIFO_M2),

		// Slave
		////// WRITE ADDRESS S1
		.AWID_S1(AWID_FIFO_S1),
		.AWADDR_S1(AWADDR_FIFO_S1),
		.AWLEN_S1(AWLEN_FIFO_S1),
		.AWSIZE_S1(AWSIZE_FIFO_S1),
		.AWBURST_S1(AWBURST_FIFO_S1),
		.AWVALID_S1(AWVALID_FIFO_S1),
		.AWREADY_S1(AWREADY_FIFO_S1),
		// WRITE DATA S1
		.WDATA_S1(WDATA_FIFO_S1),
		.WSTRB_S1(WSTRB_FIFO_S1),
		.WLAST_S1(WLAST_FIFO_S1),
		.WVALID_S1(WVALID_FIFO_S1),
		.WREADY_S1(WREADY_FIFO_S1),
		// WRITE RESPONSE S1
		.BID_S1(BID_FIFO_S1),
		.BRESP_S1(BRESP_FIFO_S1),
		.BVALID_S1(BVALID_FIFO_S1),
		.BREADY_S1(BREADY_FIFO_S1),
		////// WRITE ADDRESS S2
		.AWID_S2(AWID_FIFO_S2),
		.AWADDR_S2(AWADDR_FIFO_S2),
		.AWLEN_S2(AWLEN_FIFO_S2),
		.AWSIZE_S2(AWSIZE_FIFO_S2),
		.AWBURST_S2(AWBURST_FIFO_S2),
		.AWVALID_S2(AWVALID_FIFO_S2),
		.AWREADY_S2(AWREADY_FIFO_S2),
		// WRITE DATA S2
		.WDATA_S2(WDATA_FIFO_S2),
		.WSTRB_S2(WSTRB_FIFO_S2),
		.WLAST_S2(WLAST_FIFO_S2),
		.WVALID_S2(WVALID_FIFO_S2),
		.WREADY_S2(WREADY_FIFO_S2),
		// WRITE RESPONSE S2
		.BID_S2(BID_FIFO_S2),
		.BRESP_S2(BRESP_FIFO_S2),
		.BVALID_S2(BVALID_FIFO_S2),
		.BREADY_S2(BREADY_FIFO_S2),
		// WRITE ADDRESS S3 
		.AWID_S3(AWID_FIFO_S3),
		.AWADDR_S3(AWADDR_FIFO_S3),
		.AWLEN_S3(AWLEN_FIFO_S3),
		.AWSIZE_S3(AWSIZE_FIFO_S3),
		.AWBURST_S3(AWBURST_FIFO_S3),
		.AWVALID_S3(AWVALID_FIFO_S3),
		.AWREADY_S3(AWREADY_FIFO_S3),
		// WRITE DATA S3
		.WDATA_S3(WDATA_FIFO_S3),
		.WSTRB_S3(WSTRB_FIFO_S3),
		.WLAST_S3(WLAST_FIFO_S3),
		.WVALID_S3(WVALID_FIFO_S3),
		.WREADY_S3(WREADY_FIFO_S3),
		// WRITE RESPONSE1 S3
		.BID_S3(BID_FIFO_S3),
		.BRESP_S3(BRESP_FIFO_S3),
		.BVALID_S3(BVALID_FIFO_S3),
		.BREADY_S3(BREADY_FIFO_S3),
		// WRITE ADDRESS S4 
		.AWID_S4(AWID_FIFO_S4),
		.AWADDR_S4(AWADDR_FIFO_S4),
		.AWLEN_S4(AWLEN_FIFO_S4),
		.AWSIZE_S4(AWSIZE_FIFO_S4),
		.AWBURST_S4(AWBURST_FIFO_S4),
		.AWVALID_S4(AWVALID_FIFO_S4),
		.AWREADY_S4(AWREADY_FIFO_S4),
		// WRITE DATA S4
		.WDATA_S4(WDATA_FIFO_S4),
		.WSTRB_S4(WSTRB_FIFO_S4),
		.WLAST_S4(WLAST_FIFO_S4),
		.WVALID_S4(WVALID_FIFO_S4),
		.WREADY_S4(WREADY_FIFO_S4),
		// WRITE RESPONSE S4
		.BID_S4(BID_FIFO_S4),
		.BRESP_S4(BRESP_FIFO_S4),
		.BVALID_S4(BVALID_FIFO_S4),
		.BREADY_S4(BREADY_FIFO_S4),
		// WRITE ADDRESS S5 
		.AWID_S5(AWID_FIFO_S5),
		.AWADDR_S5(AWADDR_FIFO_S5),
		.AWLEN_S5(AWLEN_FIFO_S5),
		.AWSIZE_S5(AWSIZE_FIFO_S5),
		.AWBURST_S5(AWBURST_FIFO_S5),
		.AWVALID_S5(AWVALID_FIFO_S5),
		.AWREADY_S5(AWREADY_FIFO_S5),
		// WRITE DATA S5
		.WDATA_S5(WDATA_FIFO_S5),
		.WSTRB_S5(WSTRB_FIFO_S5),
		.WLAST_S5(WLAST_FIFO_S5),
		.WVALID_S5(WVALID_FIFO_S5),
		.WREADY_S5(WREADY_FIFO_S5),
		// WRITE RESP S5
		.BID_S5(BID_FIFO_S5),
		.BRESP_S5(BRESP_FIFO_S5),
		.BVALID_S5(BVALID_FIFO_S5),
		.BREADY_S5(BREADY_FIFO_S5)
	);

endmodule
