`define AXI_ID_BITS 4
`define AXI_IDS_BITS 8
`define AXI_ADDR_BITS 32
`define AXI_LEN_BITS 4
`define AXI_SIZE_BITS 3
`define AXI_DATA_BITS 32
`define AXI_STRB_BITS 4
`define AXI_BURST_BITS 2
`define AXI_RESP_BITS 2
`define AXI_LEN_ONE 4'h0
`define AXI_SIZE_BYTE 3'b000
`define AXI_SIZE_HWORD 3'b001
`define AXI_SIZE_WORD 3'b010
`define AXI_BURST_INCR 2'h1
`define AXI_BURST_WRAP 2'h2
`define AXI_STRB_WORD 4'b1111
`define AXI_STRB_HWORD 4'b0011
`define AXI_STRB_BYTE 4'b0001
`define AXI_RESP_OKAY 2'h0
`define AXI_RESP_SLVERR 2'h2
`define AXI_RESP_DECERR 2'h3
`define AXI_MASTER_num 3
`define AXI_BURST_INC 2'h1

//========================= Cache  =========================
// CPU
`define DATA_BITS 32
`define INS_SIZE 32
`define NOP 32'b0
`define DATA_SIZE 32

// Cache
`define CACHE_BLOCK_BITS 2
`define CACHE_INDEX_BITS 6
`define CACHE_TAG_BITS 22
`define CACHE_DATA_BITS 128
`define CACHE_LINES 2**(`CACHE_INDEX_BITS)
`define CACHE_WRITE_BITS 16
`define CACHE_TYPE_BITS 3
`define CACHE_BYTE `CACHE_TYPE_BITS'b000
`define CACHE_HWORD `CACHE_TYPE_BITS'b001
`define CACHE_WORD `CACHE_TYPE_BITS'b010
`define CACHE_BYTE_U `CACHE_TYPE_BITS'b100
`define CACHE_HWORD_U `CACHE_TYPE_BITS'b101

//Read Write data length
`define WRITE_LEN_BITS 2
`define BYTE `WRITE_LEN_BITS'b00
`define HWORD `WRITE_LEN_BITS'b01
`define WORD `WRITE_LEN_BITS'b10



//========================= Commonly used  =========================
`define TRUE  1'b1
`define FALSE 1'b0

// AXI Bridge
// Definition
`define IDLE 1'b0
`define BUSY 1'b1
// Precedence
`define M0 2'd0
`define M1 2'd1
`define M2 2'd2
// Master MUX Selection
`define M0MUX 2'b00
`define M1MUX 2'b01
`define M2MUX 2'b10
`define DEFAULTMMUX 2'b11
// Slave MUX Selection
`define S0MUX 3'b000
`define S1MUX 3'b001
`define S2MUX 3'b010
`define S3MUX 3'b011
`define S4MUX 3'b100
`define S5MUX 3'b101
`define WRONGADDRESS 3'b110
`define DEFAULTSMUX 3'b111
// ARVALID_Sel
`define M0_M1_M2 3'b111
`define M0_nM1_nM2 3'b100
`define M0_M1_nM2 3'b110
`define M0_nM1_M2 3'b101
`define nM0_M1_M2 3'b011
`define nM0_M1_nM2 3'b010
`define nM0_nM1_M2 3'b001
`define nM0_nM1_nM2 3'b000

// AXI Slave
// Select
`define FREE 2'b00
`define READ 2'b01
`define WRITE 2'b10
// Read State
`define ADDRESS 1'b0
`define DATA 1'b1
// Write State
`define ADDRESSDATA 1'b0
`define RESPONSE 1'b1


module top(
  input  logic           cpu_clk,
  input  logic           axi_clk,
  input  logic           rom_clk,
  input  logic           dram_clk,
  input  logic           cpu_rst,
  input  logic           axi_rst,
  input  logic           rom_rst,
  input  logic           dram_rst,
  input  logic [   31:0] ROM_out,
  input  logic [   31:0] DRAM_Q,
  output logic           ROM_read,
  output logic           ROM_enable,
  output logic [   11:0] ROM_address,
  output logic           DRAM_CSn,
  output logic [    3:0] DRAM_WEn,
  output logic           DRAM_RASn,
  output logic           DRAM_CASn,
  output logic [   10:0] DRAM_A,
  output logic [   31:0] DRAM_D,
  input  logic           DRAM_valid
);

logic CPU_CLK_i,AXI_CLK_i,ROM_CLK_i,DRAM_CLK_i,SRAM_CLK_i,DMA_CLK_i,WDT_CLK_i;
logic CPU_RST_i,AXI_RST_i,ROM_RST_i,DRAM_RST_i,SRAM_RST_i,DMA_RST_i,WDT_RST_i;

assign CPU_CLK_i = cpu_clk;
assign AXI_CLK_i = axi_clk;
assign ROM_CLK_i = rom_clk;
assign DRAM_CLK_i = dram_clk;
assign SRAM_CLK_i = cpu_clk;
assign DMA_CLK_i = cpu_clk;
assign WDT_CLK_i = rom_clk;

assign CPU_RST_i = cpu_rst;
assign AXI_RST_i = axi_rst;
assign ROM_RST_i = rom_rst;
assign DRAM_RST_i = dram_rst;
assign SRAM_RST_i = cpu_rst;
assign DMA_RST_i  = cpu_rst;
assign WDT_RST_i  = rom_rst;

// assign CPU_CLK_i = cpu_clk;
// assign AXI_CLK_i = cpu_clk;
// assign ROM_CLK_i = cpu_clk;
// assign DRAM_CLK_i = cpu_clk;
// assign SRAM_CLK_i = cpu_clk;
// assign DMA_CLK_i = cpu_clk;
// assign WDT_CLK_i = cpu_clk;

// assign CPU_RST_i = cpu_rst;
// assign AXI_RST_i = cpu_rst;
// assign ROM_RST_i = cpu_rst;
// assign DRAM_RST_i = cpu_rst;
// assign SRAM_RST_i = cpu_rst;
// assign DMA_RST_i  = cpu_rst;
// assign WDT_RST_i  = cpu_rst;

// ---------------------------------master--------------------------------- //
    // ---------master0------------ //
    // Read address channel signals
    logic    [`AXI_ID_BITS-1:0]      arid_m0;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_m0;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_m0;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_m0;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_m0;   // Read address burst type
    logic                        arvalid_m0;   // Read address valid
    logic                        arready_m0;   // Read address ready

    // Read data channel signals
    logic    [`AXI_ID_BITS-1:0]      rid_m0;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_m0;     // Read data
    logic                        rlast_m0;     // Read last
    logic                        rvalid_m0;    // Read valid
    logic                        rready_m0;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]   rresp_m0;     // Read response

    // ----------master1---------- //
    // Write address channel signals
    logic    [`AXI_ID_BITS-1:0]      awid_m1;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    awaddr_m1;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     awlen_m1;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    awsize_m1;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   awburst_m1;   // Write address burst type
    logic                        awvalid_m1;   // Write address valid
    logic                        awready_m1;   // Write address ready

    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    wdata_m1;     // Write data
    logic    [`AXI_STRB_BITS-1:0]  wstrb_m1;     // Write strobe
    logic                        wlast_m1;     // Write last
    logic                        wvalid_m1;    // Write valid
    logic                        wready_m1;    // Write ready
    // Write response channel signals
    logic    [`AXI_ID_BITS-1:0]      bid_m1;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]   bresp_m1;     // Write response
    logic                        bvalid_m1;    // Write response valid
    logic                        bready_m1;    // Write response ready
    // Read address channel signals
    logic    [`AXI_ID_BITS-1:0]      arid_m1;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_m1;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_m1;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_m1;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_m1;   // Read address burst type
    logic                        arvalid_m1;   // Read address valid
    logic                        arready_m1;   // Read address ready

    // Read data channel signals
    logic    [`AXI_ID_BITS-1:0]      rid_m1;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_m1;     // Read data
    logic                        rlast_m1;     // Read last
    logic                        rvalid_m1;    // Read valid
    logic                        rready_m1;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]   rresp_m1;     // Read response

    
    // ----------master2---------- //
    // Write address channel signals
    logic    [`AXI_ID_BITS-1:0]      awid_m2;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    awaddr_m2;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     awlen_m2;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    awsize_m2;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   awburst_m2;   // Write address burst type
    logic                        awvalid_m2;   // Write address valid
    logic                        awready_m2;   // Write address ready

    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    wdata_m2;     // Write data
    logic    [`AXI_STRB_BITS-1:0]    wstrb_m2;     // Write strobe
    logic                        wlast_m2;     // Write last
    logic                        wvalid_m2;    // Write valid
    logic                        wready_m2;    // Write ready
    // Write response channel signals
    logic    [`AXI_ID_BITS-1:0]      bid_m2;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    bresp_m2;     // Write response
    logic                        bvalid_m2;    // Write response valid
    logic                        bready_m2;    // Write response ready
    // Read address channel signals
    logic    [`AXI_ID_BITS-1:0]      arid_m2;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_m2;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_m2;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_m2;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_m2;   // Read address burst type
    logic                        arvalid_m2;   // Read address valid
    logic                        arready_m2;   // Read address ready

    // Read data channel signals
    logic    [`AXI_ID_BITS-1:0]      rid_m2;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_m2;     // Read data
    logic                        rlast_m2;     // Read last
    logic                        rvalid_m2;    // Read valid
    logic                        rready_m2;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    rresp_m2;     // Read response



// ---------------------------------slave--------------------------------- //
    // ----------slave0---------- //
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]      arid_s0;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_s0;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_s0;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_s0;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_s0;   // Read address burst type
    logic                        arvalid_s0;   // Read address valid
    logic                        arready_s0;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]      rid_s0;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_s0;     // Read data
    logic                       rlast_s0;     // Read last
    logic                       rvalid_s0;    // Read valid
    logic                        rready_s0;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    rresp_s0;     // Read response

    // ----------slave1---------- //
    logic    [`AXI_IDS_BITS-1:0]      awid_s1;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    awaddr_s1;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     awlen_s1;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    awsize_s1;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   awburst_s1;   // Write address burst type

    logic                        awvalid_s1;   // Write address valid
    logic                        awready_s1;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    wdata_s1;     // Write data
    logic    [`AXI_STRB_BITS-1:0]  wstrb_s1;     // Write strobe
    logic                        wlast_s1;     // Write last
    logic                        wvalid_s1;    // Write valid
    logic                        wready_s1;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]      bid_s1;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    bresp_s1;     // Write response
    logic                        bvalid_s1;    // Write response valid
    logic                       bready_s1;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]      arid_s1;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_s1;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_s1;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_s1;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_s1;   // Read address burst type
    logic                        arvalid_s1;   // Read address valid
    logic                        arready_s1;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]      rid_s1;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_s1;     // Read data
    logic                       rlast_s1;     // Read last
    logic                       rvalid_s1;    // Read valid
    logic                        rready_s1;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    rresp_s1;     // Read response

    // ----------slave2---------- //
    logic    [`AXI_IDS_BITS-1:0]      awid_s2;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    awaddr_s2;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     awlen_s2;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    awsize_s2;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   awburst_s2;   // Write address burst type

    logic                        awvalid_s2;   // Write address valid
    logic                        awready_s2;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    wdata_s2;     // Write data
    logic    [`AXI_STRB_BITS-1:0]  wstrb_s2;     // Write strobe
    logic                        wlast_s2;     // Write last
    logic                        wvalid_s2;    // Write valid
    logic                        wready_s2;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]      bid_s2;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    bresp_s2;     // Write response
    logic                        bvalid_s2;    // Write response valid
    logic                       bready_s2;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]      arid_s2;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_s2;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_s2;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_s2;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_s2;   // Read address burst type
    logic                        arvalid_s2;   // Read address valid
    logic                        arready_s2;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]      rid_s2;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_s2;     // Read data
    logic                       rlast_s2;     // Read last
    logic                       rvalid_s2;    // Read valid
    logic                        rready_s2;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    rresp_s2;     // Read response

    // ----------slave3---------- //
    logic    [`AXI_IDS_BITS-1:0]   awid_s3;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]  awaddr_s3;    // Write address
    logic    [`AXI_LEN_BITS-1:0]   awlen_s3;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]  awsize_s3;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0] awburst_s3;   // Write address burst type
    logic                          awvalid_s3;   // Write address valid
    logic                          awready_s3;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]  wdata_s3;     // Write data
    logic    [`AXI_STRB_BITS-1:0]  wstrb_s3;     // Write strobe
    logic                          wlast_s3;     // Write last
    logic                          wvalid_s3;    // Write valid
    logic                          wready_s3;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]   bid_s3;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]  bresp_s3;     // Write response
    logic                          bvalid_s3;    // Write response valid
    logic                          bready_s3;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]   arid_s3;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]  araddr_s3;    // Read address
    logic    [`AXI_LEN_BITS-1:0]   arlen_s3;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]  arsize_s3;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0] arburst_s3;   // Read address burst type
    logic                          arvalid_s3;   // Read address valid
    logic                          arready_s3;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]   rid_s3;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]  rdata_s3;     // Read data
    logic                          rlast_s3;     // Read last
    logic                          rvalid_s3;    // Read valid
    logic                          rready_s3;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]  rresp_s3;     // Read response

    // ----------slave4---------- //
    logic    [`AXI_IDS_BITS-1:0]   awid_s4;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]  awaddr_s4;    // Write address
    logic    [`AXI_LEN_BITS-1:0]   awlen_s4;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]  awsize_s4;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0] awburst_s4;   // Write address burst type
    logic                          awvalid_s4;   // Write address valid
    logic                          awready_s4;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]  wdata_s4;     // Write data
    logic    [`AXI_STRB_BITS-1:0]  wstrb_s4;     // Write strobe
    logic                          wlast_s4;     // Write last
    logic                          wvalid_s4;    // Write valid
    logic                          wready_s4;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]   bid_s4;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]  bresp_s4;     // Write response
    logic                          bvalid_s4;    // Write response valid
    logic                          bready_s4;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]   arid_s4;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]  araddr_s4;    // Read address
    logic    [`AXI_LEN_BITS-1:0]   arlen_s4;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]  arsize_s4;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0] arburst_s4;   // Read address burst type
    logic                          arvalid_s4;   // Read address valid
    logic                          arready_s4;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]   rid_s4;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]  rdata_s4;     // Read data
    logic                          rlast_s4;     // Read last
    logic                          rvalid_s4;    // Read valid
    logic                          rready_s4;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]  rresp_s4;     // Read response

	
	// ----------slave4---------- //
    logic    [`AXI_IDS_BITS-1:0]      awid_s5;      // Write address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    awaddr_s5;    // Write address
    logic    [`AXI_LEN_BITS-1:0]     awlen_s5;     // Write address burst length
    logic    [`AXI_SIZE_BITS-1:0]    awsize_s5;    // Write address burst size
    logic    [`AXI_BURST_BITS-1:0]   awburst_s5;   // Write address burst type

    logic                        awvalid_s5;   // Write address valid
    logic                        awready_s5;   // Write address ready
    // Write data channel signals
    logic    [`AXI_DATA_BITS-1:0]    wdata_s5;     // Write data
    logic    [`AXI_STRB_BITS-1:0]  wstrb_s5;     // Write strobe
    logic                        wlast_s5;     // Write last
    logic                        wvalid_s5;    // Write valid
    logic                        wready_s5;    // Write ready
    // Write response channel signals
    logic    [`AXI_IDS_BITS-1:0]      bid_s5;       // Write response ID tag
    logic    [`AXI_RESP_BITS-1:0]    bresp_s5;     // Write response
    logic                        bvalid_s5;    // Write response valid
    logic                       bready_s5;    // Write response ready
    // Read address channel signals
    logic    [`AXI_IDS_BITS-1:0]      arid_s5;      // Read address ID tag
    logic    [`AXI_ADDR_BITS-1:0]    araddr_s5;    // Read address
    logic    [`AXI_LEN_BITS-1:0]     arlen_s5;     // Read address burst length
    logic    [`AXI_SIZE_BITS-1:0]    arsize_s5;    // Read address burst size
    logic    [`AXI_BURST_BITS-1:0]   arburst_s5;   // Read address burst type
    logic                        arvalid_s5;   // Read address valid
    logic                        arready_s5;   // Read address ready
    // Read data channel signals
    logic    [`AXI_IDS_BITS-1:0]      rid_s5;       // Read ID tag
    logic    [`AXI_DATA_BITS-1:0]    rdata_s5;     // Read data
    logic                       rlast_s5;     // Read last
    logic                       rvalid_s5;    // Read valid
    logic                        rready_s5;    // Read ready
    logic    [`AXI_RESP_BITS-1:0]    rresp_s5;     // Read response

    logic inter_DMA, inter_WDT, WFI_pc_en;
    

// ---------------------------------PORT--------------------------------- //
    // CPU
    CPU_wrapper cpu(
        .ACLK(CPU_CLK_i),
        .ARESETn(CPU_RST_i),
        .WFI_pc_en(WFI_pc_en),
        .inter_DMA(inter_DMA),
        .inter_WDT(inter_WDT),

        .AWID_M1(awid_m1),
        .AWADDR_M1(awaddr_m1),
        .AWLEN_M1(awlen_m1),
        .AWSIZE_M1(awsize_m1),
        .AWBURST_M1(awburst_m1),
        .AWVALID_M1(awvalid_m1),
        .AWREADY_M1(awready_m1),

        .WDATA_M1(wdata_m1),
        .WSTRB_M1(wstrb_m1),
        .WLAST_M1(wlast_m1),
        .WVALID_M1(wvalid_m1),
        .WREADY_M1(wready_m1),

        .BID_M1(bid_m1),
        .BRESP_M1(bresp_m1),
        .BVALID_M1(bvalid_m1),
        .BREADY_M1(bready_m1),

        .ARID_M0(arid_m0),
        .ARADDR_M0(araddr_m0),
        .ARLEN_M0(arlen_m0),
        .ARSIZE_M0(arsize_m0),
        .ARBURST_M0(arburst_m0),
        .ARVALID_M0(arvalid_m0),
        .ARREADY_M0(arready_m0),

        .RID_M0(rid_m0),
        .RDATA_M0(rdata_m0),
        .RRESP_M0(rresp_m0),
        .RLAST_M0(rlast_m0),
        .RVALID_M0(rvalid_m0),
        .RREADY_M0(rready_m0),

        .ARID_M1(arid_m1),
        .ARADDR_M1(araddr_m1),
        .ARLEN_M1(arlen_m1),
        .ARSIZE_M1(arsize_m1),
        .ARBURST_M1(arburst_m1),
        .ARVALID_M1(arvalid_m1),
        .ARREADY_M1(arready_m1),

        .RID_M1(rid_m1),
        .RDATA_M1(rdata_m1),
        .RRESP_M1(rresp_m1),
        .RLAST_M1(rlast_m1),
        .RVALID_M1(rvalid_m1),
        .RREADY_M1(rready_m1)
    );

    AXI axi_duv_bridge(
        // .ACLK       (clk ),
        // .ARESETn    (rst ),

        .CPU_CLK_i 	(CPU_CLK_i ),
        .AXI_CLK_i 	(AXI_CLK_i ),
        .ROM_CLK_i 	(ROM_CLK_i ),
        .DRAM_CLK_i	(DRAM_CLK_i),
        .SRAM_CLK_i	(SRAM_CLK_i),
        .DMA_CLK_i	(DMA_CLK_i),
        .WDT_CLK_i	(WDT_CLK_i),
        .CPU_RST_i 	(CPU_RST_i ),
        .AXI_RST_i 	(AXI_RST_i ),
        .ROM_RST_i 	(ROM_RST_i ),
        .DRAM_RST_i	(DRAM_RST_i),
        .SRAM_RST_i	(SRAM_RST_i),
        .DMA_RST_i	(DMA_RST_i),
        .WDT_RST_i	(WDT_RST_i),

        // WRITE M2 (DMA)
        .AWID_M2    (awid_m2   ),
        .AWADDR_M2  (awaddr_m2 ),
        .AWLEN_M2   (awlen_m2  ),
        .AWSIZE_M2  (awsize_m2 ),
        .AWBURST_M2 (awburst_m2),
        .AWVALID_M2 (awvalid_m2),
        .AWREADY_M2 (awready_m2),
        .WDATA_M2   (wdata_m2  ),
        .WSTRB_M2   (wstrb_m2  ),
        .WLAST_M2   (wlast_m2  ),
        .WVALID_M2  (wvalid_m2 ),
        .WREADY_M2  (wready_m2 ),
        .BID_M2     (bid_m2    ),
        .BRESP_M2   (bresp_m2  ),
        .BVALID_M2  (bvalid_m2 ),
        .BREADY_M2  (bready_m2 ),

        // READ M2 (DMA)
        .ARID_M2    (arid_m2   ),
        .ARADDR_M2  (araddr_m2 ),
        .ARLEN_M2   (arlen_m2  ),
        .ARSIZE_M2  (arsize_m2 ),
        .ARBURST_M2 (arburst_m2),
        .ARVALID_M2 (arvalid_m2),
        .ARREADY_M2 (arready_m2),
        .RID_M2     (rid_m2    ),
        .RDATA_M2   (rdata_m2  ),
        .RRESP_M2   (rresp_m2  ),
        .RLAST_M2   (rlast_m2  ),
        .RVALID_M2  (rvalid_m2 ),
        .RREADY_M2  (rready_m2 ),

	    // WRITE M1 (Data)
        .AWID_M1    (awid_m1   ),
        .AWADDR_M1  (awaddr_m1 ),
        .AWLEN_M1   (awlen_m1  ),
        .AWSIZE_M1  (awsize_m1 ),
        .AWBURST_M1 (awburst_m1),
        .AWVALID_M1 (awvalid_m1),
        .AWREADY_M1 (awready_m1),
        .WDATA_M1   (wdata_m1  ),
        .WSTRB_M1   (wstrb_m1  ),
        .WLAST_M1   (wlast_m1  ),
        .WVALID_M1  (wvalid_m1 ),
        .WREADY_M1  (wready_m1 ),
        .BID_M1     (bid_m1    ),
        .BRESP_M1   (bresp_m1  ),
        .BVALID_M1  (bvalid_m1 ),
        .BREADY_M1  (bready_m1 ),
	    // READ M0 (Instruction)
        .ARID_M0    (arid_m0   ),
        .ARADDR_M0  (araddr_m0 ),
        .ARLEN_M0   (arlen_m0  ),
        .ARSIZE_M0  (arsize_m0 ),
        .ARBURST_M0 (arburst_m0),
        .ARVALID_M0 (arvalid_m0),
        .ARREADY_M0 (arready_m0),
        .RID_M0     (rid_m0    ),
        .RDATA_M0   (rdata_m0  ),
        .RRESP_M0   (rresp_m0  ),
        .RLAST_M0   (rlast_m0  ),
        .RVALID_M0  (rvalid_m0 ),
        .RREADY_M0  (rready_m0 ),
        // READ M1 (Data)
        .ARID_M1    (arid_m1   ),
        .ARADDR_M1  (araddr_m1 ),
        .ARLEN_M1   (arlen_m1  ),
        .ARSIZE_M1  (arsize_m1 ),
        .ARBURST_M1 (arburst_m1),
        .ARVALID_M1 (arvalid_m1),
        .ARREADY_M1 (arready_m1),
        .RID_M1     (rid_m1    ),
        .RDATA_M1   (rdata_m1  ),
        .RRESP_M1   (rresp_m1  ),
        .RLAST_M1   (rlast_m1  ),
        .RVALID_M1  (rvalid_m1 ),
        .RREADY_M1  (rready_m1 ),

        // SLAVE READ CHANNEL
        // READ S0 (ROM)
        .ARID_S0    (arid_s0   ),
        .ARADDR_S0  (araddr_s0 ),
        .ARLEN_S0   (arlen_s0  ),
        .ARSIZE_S0  (arsize_s0 ),
        .ARBURST_S0 (arburst_s0),
        .ARVALID_S0 (arvalid_s0),
        .ARREADY_S0 (arready_s0),
        .RID_S0     (rid_s0    ),
        .RDATA_S0   (rdata_s0  ),
        .RRESP_S0   (rresp_s0  ),
        .RLAST_S0   (rlast_s0  ),
        .RVALID_S0  (rvalid_s0 ),
        .RREADY_S0  (rready_s0 ),
        // READ S1 (IM SRAM)
        .ARID_S1    (arid_s1   ),
        .ARADDR_S1  (araddr_s1 ),
        .ARLEN_S1   (arlen_s1  ),
        .ARSIZE_S1  (arsize_s1 ),
        .ARBURST_S1 (arburst_s1),
        .ARVALID_S1 (arvalid_s1),
        .ARREADY_S1 (arready_s1),
        .RID_S1     (rid_s1    ),
        .RDATA_S1   (rdata_s1  ),
        .RRESP_S1   (rresp_s1  ),
        .RLAST_S1   (rlast_s1  ),
        .RVALID_S1  (rvalid_s1 ),
        .RREADY_S1  (rready_s1 ),
        // READ S2 (DM SRAM)
        .ARID_S2    (arid_s2   ),
        .ARADDR_S2  (araddr_s2 ),
        .ARLEN_S2   (arlen_s2  ),
        .ARSIZE_S2  (arsize_s2 ),
        .ARBURST_S2 (arburst_s2),
        .ARVALID_S2 (arvalid_s2),
        .ARREADY_S2 (arready_s2),
        .RID_S2     (rid_s2    ),
        .RDATA_S2   (rdata_s2  ),
        .RRESP_S2   (rresp_s2  ),
        .RLAST_S2   (rlast_s2  ),
        .RVALID_S2  (rvalid_s2 ),
        .RREADY_S2  (rready_s2 ),
        // READ S3 (DMA)
        .ARID_S3    (arid_s3   ),
        .ARADDR_S3  (araddr_s3 ),
        .ARLEN_S3   (arlen_s3  ),
        .ARSIZE_S3  (arsize_s3 ),
        .ARBURST_S3 (arburst_s3),
        .ARVALID_S3 (arvalid_s3),
        .ARREADY_S3 (arready_s3),
        .RID_S3     (rid_s3    ),
        .RDATA_S3   (rdata_s3  ),
        .RRESP_S3   (rresp_s3  ),
        .RLAST_S3   (rlast_s3  ),
        .RVALID_S3  (rvalid_s3 ),
        .RREADY_S3  (rready_s3 ),
        // READ S4 (WDT)
        .ARID_S4    (arid_s4   ),
        .ARADDR_S4  (araddr_s4 ),
        .ARLEN_S4   (arlen_s4  ),
        .ARSIZE_S4  (arsize_s4 ),
        .ARBURST_S4 (arburst_s4),
        .ARVALID_S4 (arvalid_s4),
        .ARREADY_S4 (arready_s4),
        .RID_S4     (rid_s4    ),
        .RDATA_S4   (rdata_s4  ),
        .RRESP_S4   (rresp_s4  ),
        .RLAST_S4   (rlast_s4  ),
        .RVALID_S4  (rvalid_s4 ),
        .RREADY_S4  (rready_s4 ),
            // READ S5 (DRAM)
        .ARID_S5    (arid_s5   ),
        .ARADDR_S5  (araddr_s5 ),
        .ARLEN_S5   (arlen_s5  ),
        .ARSIZE_S5  (arsize_s5 ),
        .ARBURST_S5 (arburst_s5),
        .ARVALID_S5 (arvalid_s5),
        .ARREADY_S5 (arready_s5),
        .RID_S5     (rid_s5    ),
        .RDATA_S5   (rdata_s5  ),
        .RRESP_S5   (rresp_s5  ),
        .RLAST_S5   (rlast_s5  ),
        .RVALID_S5  (rvalid_s5 ),
        .RREADY_S5  (rready_s5 ),            
        // SLAVE WRITE CHANNEL
        // WRITE S0 (ROM)
        // .AWID_S0    (awid_s0   ),
        // .AWADDR_S0  (awaddr_s0 ),
        // .AWLEN_S0   (awlen_s0  ),
        // .AWSIZE_S0  (awsize_s0 ),
        // .AWBURST_S0 (awburst_s0),
        // .AWVALID_S0 (awvalid_s0),
        // .AWREADY_S0 (awready_s0),
        // .WDATA_S0   (wdata_s0  ),
        // .WSTRB_S0   (wstrb_s0  ),
        // .WLAST_S0   (wlast_s0  ),
        // .WVALID_S0  (wvalid_s0 ),
        // .WREADY_S0  (wready_s0 ),
        // .BID_S0     (bid_s0    ),
        // .BRESP_S0   (bresp_s0  ),
        // .BVALID_S0  (bvalid_s0 ),
        // .BREADY_S0  (bready_s0 ),
        // WRITE S1 (IM SRAM)
        .AWID_S1    (awid_s1   ),
        .AWADDR_S1  (awaddr_s1 ),
        .AWLEN_S1   (awlen_s1  ),
        .AWSIZE_S1  (awsize_s1 ),
        .AWBURST_S1 (awburst_s1),
        .AWVALID_S1 (awvalid_s1),
        .AWREADY_S1 (awready_s1),
        .WDATA_S1   (wdata_s1  ),
        .WSTRB_S1   (wstrb_s1  ),
        .WLAST_S1   (wlast_s1  ),
        .WVALID_S1  (wvalid_s1 ),
        .WREADY_S1  (wready_s1 ),
        .BID_S1     (bid_s1    ),
        .BRESP_S1   (bresp_s1  ),
        .BVALID_S1  (bvalid_s1 ),
        .BREADY_S1  (bready_s1 ),
        // WRITE S2 (DM SRAM)
        .AWID_S2    (awid_s2   ),
        .AWADDR_S2  (awaddr_s2 ),
        .AWLEN_S2   (awlen_s2  ),
        .AWSIZE_S2  (awsize_s2 ),
        .AWBURST_S2 (awburst_s2),
        .AWVALID_S2 (awvalid_s2),
        .AWREADY_S2 (awready_s2),
        .WDATA_S2   (wdata_s2  ),
        .WSTRB_S2   (wstrb_s2  ),
        .WLAST_S2   (wlast_s2  ),
        .WVALID_S2  (wvalid_s2 ),
        .WREADY_S2  (wready_s2 ),
        .BID_S2     (bid_s2    ),
        .BRESP_S2   (bresp_s2  ),
        .BVALID_S2  (bvalid_s2 ),
        .BREADY_S2  (bready_s2 ),
        // WRITE S3 (DMA)
        .AWID_S3    (awid_s3   ),
        .AWADDR_S3  (awaddr_s3 ),
        .AWLEN_S3   (awlen_s3  ),
        .AWSIZE_S3  (awsize_s3 ),
        .AWBURST_S3 (awburst_s3),
        .AWVALID_S3 (awvalid_s3),
        .AWREADY_S3 (awready_s3),
        .WDATA_S3   (wdata_s3  ),
        .WSTRB_S3   (wstrb_s3  ),
        .WLAST_S3   (wlast_s3  ),
        .WVALID_S3  (wvalid_s3 ),
        .WREADY_S3  (wready_s3 ),
        .BID_S3     (bid_s3    ),
        .BRESP_S3   (bresp_s3  ),
        .BVALID_S3  (bvalid_s3 ),
        .BREADY_S3  (bready_s3 ),
        // WRITE S4 (WDT)
        .AWID_S4    (awid_s4   ),
        .AWADDR_S4  (awaddr_s4 ),
        .AWLEN_S4   (awlen_s4  ),
        .AWSIZE_S4  (awsize_s4 ),
        .AWBURST_S4 (awburst_s4),
        .AWVALID_S4 (awvalid_s4),
        .AWREADY_S4 (awready_s4),
        .WDATA_S4   (wdata_s4  ),
        .WSTRB_S4   (wstrb_s4  ),
        .WLAST_S4   (wlast_s4  ),
        .WVALID_S4  (wvalid_s4 ),
        .WREADY_S4  (wready_s4 ),
        .BID_S4     (bid_s4    ),
        .BRESP_S4   (bresp_s4  ),
        .BVALID_S4  (bvalid_s4 ),
        .BREADY_S4  (bready_s4 ),
        // WRITE S5 (DRAM)
        .AWID_S5    (awid_s5),
        .AWADDR_S5  (awaddr_s5),
        .AWLEN_S5   (awlen_s5),
        .AWSIZE_S5  (awsize_s5),
        .AWBURST_S5 (awburst_s5),
        .AWVALID_S5 (awvalid_s5),
        .AWREADY_S5 (awready_s5),
        .WDATA_S5   (wdata_s5),
        .WSTRB_S5   (wstrb_s5),
        .WLAST_S5   (wlast_s5),
        .WVALID_S5  (wvalid_s5),
        .WREADY_S5  (wready_s5),
        .BID_S5     (bid_s5),
        .BRESP_S5   (bresp_s5),
        .BVALID_S5  (bvalid_s5),
        .BREADY_S5  (bready_s5)        
	);

    //ROM
    ROM_Wrapper ROM(
        .clk  (ROM_CLK_i),
        .rst  (ROM_RST_i),
            // READ ADDRESS
        .ARID   (arid_s0),
        .ARADDR (araddr_s0),
        .ARLEN  (arlen_s0),
        .ARSIZE (arsize_s0),
        .ARBURST(arburst_s0),
        .ARVALID(arvalid_s0),
        .ARREADY(arready_s0),
        // READ DATA
        .RID    (rid_s0),
        .RDATA  (rdata_s0),
        .RRESP  (rresp_s0),
        .RLAST  (rlast_s0),
        .RVALID (rvalid_s0),
        .RREADY (rready_s0),
        // ROM
        .DO(ROM_out),
        .CS(ROM_enable),
        .OE(ROM_read),
        .A (ROM_address)
    );

    // IM1
    SRAM_wrapper IM1(
        .ACLK  (SRAM_CLK_i),
        .ARESETn  (SRAM_RST_i),
        // .clk  (clk),
        // .rst  (rst),
            // READ ADDRESS
        .ARID   (arid_s1),
        .ARADDR (araddr_s1),
        .ARLEN  (arlen_s1),
        .ARSIZE (arsize_s1),
        .ARBURST(arburst_s1),
        .ARVALID(arvalid_s1),
        .ARREADY(arready_s1),
        // READ DATA
        .RID    (rid_s1),
        .RDATA  (rdata_s1),
        .RRESP  (rresp_s1),
        .RLAST  (rlast_s1),
        .RVALID (rvalid_s1),
        .RREADY (rready_s1),
            // WRITE ADDRESS
        .AWID   (awid_s1),
        .AWADDR (awaddr_s1),
        .AWLEN  (awlen_s1),
        .AWSIZE (awsize_s1),
        .AWBURST(awburst_s1),
        .AWVALID(awvalid_s1),
        .AWREADY(awready_s1),
        // WRITE DATA
        .WDATA  (wdata_s1),
        .WSTRB  (wstrb_s1),
        .WLAST  (wlast_s1),
        .WVALID (wvalid_s1),
        .WREADY (wready_s1),
        // WRITE RESPONSEcomplete
        .BID    (bid_s1),
        .BRESP  (bresp_s1),
        .BVALID (bvalid_s1),
        .BREADY (bready_s1)
    );

    // DM1
    SRAM_wrapper DM1(
        .ACLK  (SRAM_CLK_i),
        .ARESETn  (SRAM_RST_i),
        // .clk  (clk),
        // .rst  (rst),
            // READ ADDRESS
        .ARID   (arid_s2),
        .ARADDR (araddr_s2),
        .ARLEN  (arlen_s2),
        .ARSIZE (arsize_s2),
        .ARBURST(arburst_s2),
        .ARVALID(arvalid_s2),
        .ARREADY(arready_s2),
        // READ DATA
        .RID    (rid_s2),
        .RDATA  (rdata_s2),
        .RRESP  (rresp_s2),
        .RLAST  (rlast_s2),
        .RVALID (rvalid_s2),
        .RREADY (rready_s2),
            // WRITE ADDRESS
        .AWID   (awid_s2),
        .AWADDR (awaddr_s2),
        .AWLEN  (awlen_s2),
        .AWSIZE (awsize_s2),
        .AWBURST(awburst_s2),
        .AWVALID(awvalid_s2),
        .AWREADY(awready_s2),
        // WRITE DATA
        .WDATA  (wdata_s2),
        .WSTRB  (wstrb_s2),
        .WLAST  (wlast_s2),
        .WVALID (wvalid_s2),
        .WREADY (wready_s2),
        // WRITE RESPONSE
        .BID    (bid_s2),
        .BRESP  (bresp_s2),
        .BVALID (bvalid_s2),
        .BREADY (bready_s2)
    );

    DMA_wrapper DMA(
        .clk(DMA_CLK_i),
        .rst(DMA_RST_i),
        

        // Slave
        // WRITE ADDRESS
        .AWID_S3(awid_s3),
        .AWADDR_S3(awaddr_s3),
        .AWLEN_S3(awlen_s3),
        .AWSIZE_S3(awsize_s3),
        .AWBURST_S3(awburst_s3),
        .AWVALID_S3(awvalid_s3),
        .AWREADY_S3(awready_s3),
        // WRITE DATA
        .WDATA_S3(wdata_s3),
        .WSTRB_S3(wstrb_s3),
        .WLAST_S3(wlast_s3),
        .WVALID_S3(wvalid_s3),
        .WREADY_S3(wready_s3),
        // WRITE RESPONSE
        .BID_S3(bid_s3),
        .BRESP_S3(bresp_s3),
        .BVALID_S3(bvalid_s3),
        .BREADY_S3(bready_s3),

        // READ ADDRESS
        .ARID_S3   (arid_s3),
        .ARADDR_S3 (araddr_s3),
        .ARLEN_S3  (arlen_s3),
        .ARSIZE_S3 (arsize_s3),
        .ARBURST_S3(arburst_s3),
        .ARVALID_S3(arvalid_s3),
        .ARREADY_S3(arready_s3),
        // READ DATA
        .RID_S3    (rid_s3),
        .RDATA_S3  (rdata_s3),
        .RRESP_S3  (rresp_s3),
        .RLAST_S3  (rlast_s3),
        .RVALID_S3 (rvalid_s3),
        .RREADY_S3 (rready_s3),

        // Master
        // READ ADDRESS
        .ARID_M2(arid_m2),
        .ARADDR_M2(araddr_m2),
        .ARLEN_M2(arlen_m2),
        .ARSIZE_M2(arsize_m2),
        .ARBURST_M2(arburst_m2),
        .ARVALID_M2(arvalid_m2),
        .ARREADY_M2(arready_m2),
        // READ DATA
        .RID_M2(rid_m2),
        .RDATA_M2(rdata_m2),
        .RRESP_M2(rresp_m2),
        .RLAST_M2(rlast_m2),
        .RVALID_M2(rvalid_m2),
        .RREADY_M2(rready_m2),

        // WRITE ADDRESS
        .AWID_M2(awid_m2),
        .AWADDR_M2(awaddr_m2),
        .AWLEN_M2(awlen_m2),
        .AWSIZE_M2(awsize_m2),
        .AWBURST_M2(awburst_m2),
        .AWVALID_M2(awvalid_m2),
        .AWREADY_M2(awready_m2),
        // WRITE DATA
        .WDATA_M2(wdata_m2),
        .WSTRB_M2(wstrb_m2),
        .WLAST_M2(wlast_m2),
        .WVALID_M2(wvalid_m2),
        .WREADY_M2(wready_m2),
        // WRITE RESPONSE
        .BID_M2(bid_m2),
        .BRESP_M2(bresp_m2),
        .BVALID_M2(bvalid_m2),
        .BREADY_M2(bready_m2),


        // Control Signals
        .WFI_pc_en(WFI_pc_en),
        .interrupt_dma(inter_DMA)
    );

    //WDT
   	WDT_wrapper WDT
    (
        .clk  (WDT_CLK_i),
        .rst  (WDT_RST_i),
        .clk2 (CPU_CLK_i),
        .rst2  (CPU_RST_i),

        // READ ADDRESS
        .ARID   (arid_s4),
        .ARADDR (araddr_s4),
        .ARLEN  (arlen_s4),
        .ARSIZE (arsize_s4),
        .ARBURST(arburst_s4),
        .ARVALID(arvalid_s4),
        .ARREADY(arready_s4),
        // READ DATA
        .RID    (rid_s4),
        .RDATA  (rdata_s4),
        .RRESP  (rresp_s4),
        .RLAST  (rlast_s4),
        .RVALID (rvalid_s4),
        .RREADY (rready_s4),
        // WRITE ADDRESS
        .AWID   (awid_s4),
        .AWADDR (awaddr_s4),
        .AWLEN  (awlen_s4),
        .AWSIZE (awsize_s4),
        .AWBURST(awburst_s4),
        .AWVALID(awvalid_s4),
        .AWREADY(awready_s4),
        // WRITE DATA
        .WDATA  (wdata_s4),
        .WSTRB  (wstrb_s4),
        .WLAST  (wlast_s4),
        .WVALID (wvalid_s4),
        .WREADY (wready_s4),
        // WRITE RESPONSE
        .BID    (bid_s4),
        .BRESP  (bresp_s4),
        .BVALID (bvalid_s4),
        .BREADY (bready_s4),
        
        .interrupt_t(inter_WDT)
    );

    // WDT_wrapper WDT
    //     (
    //         .clk  (WDT_CLK_i),
    //         .rst  (WDT_RST_i),
    //         // .clk2 (clk2),
    //         // .rst2  (rst2),
    //         // READ ADDRESS
    //         .ARID   (arid_s4),
    //         .ARADDR (araddr_s4),
    //         .ARLEN  (arlen_s4),
    //         .ARSIZE (arsize_s4),
    //         .ARBURST(arburst_s4),
    //         .ARVALID(arvalid_s4),
    //         .ARREADY(arready_s4),
    //         // READ DATA
    //         .RID    (rid_s4),
    //         .RDATA  (rdata_s4),
    //         .RRESP  (rresp_s4),
    //         .RLAST  (rlast_s4),
    //         .RVALID (rvalid_s4),
    //         .RREADY (rready_s4),
    //         // WRITE ADDRESS
    //         .AWID   (awid_s4),
    //         .AWADDR (awaddr_s4),
    //         .AWLEN  (awlen_s4),
    //         .AWSIZE (awsize_s4),
    //         .AWBURST(awburst_s4),
    //         .AWVALID(awvalid_s4),
    //         .AWREADY(awready_s4),
    //         // WRITE DATA
    //         .WDATA  (wdata_s4),
    //         .WSTRB  (wstrb_s4),
    //         .WLAST  (wlast_s4),
    //         .WVALID (wvalid_s4),
    //         .WREADY (wready_s4),
    //         // WRITE RESPONSE
    //         .BID    (bid_s4),
    //         .BRESP  (bresp_s4),
    //         .BVALID (bvalid_s4),
    //         .BREADY (bready_s4),

    //         .WTO       (inter_WDT)
    //         // .interrupt_wdt(inter_WDT)
    //     );

    // DRAM
    DRAM_wrapper DRAM(
        .clk  (DRAM_CLK_i),
        .rst  (DRAM_RST_i),
        // READ ADDRESS
        .ARID   (arid_s5),
        .ARADDR (araddr_s5),
        .ARLEN  (arlen_s5),
        .ARSIZE (arsize_s5),
        .ARBURST(arburst_s5),
        .ARVALID(arvalid_s5),
        .ARREADY(arready_s5),
        // READ DATA
        .RID    (rid_s5),
        .RDATA  (rdata_s5),
        .RRESP  (rresp_s5),
        .RLAST  (rlast_s5),
        .RVALID (rvalid_s5),
        .RREADY (rready_s5),
        // WRITE ADDRESS
        .AWID   (awid_s5),
        .AWADDR (awaddr_s5),
        .AWLEN  (awlen_s5),
        .AWSIZE (awsize_s5),
        .AWBURST(awburst_s5),
        .AWVALID(awvalid_s5),
        .AWREADY(awready_s5),
        // WRITE DATA
        .WDATA  (wdata_s5),
        .WSTRB  (wstrb_s5),
        .WLAST  (wlast_s5),
        .WVALID (wvalid_s5),
        .WREADY (wready_s5),
        // WRITE RESPONSE
        .BID    (bid_s5),
        .BRESP  (bresp_s5),
        .BVALID (bvalid_s5),
        .BREADY (bready_s5),
        // DRAM
        .CS   (DRAM_CSn),
        .RAS  (DRAM_RASn),
        .CAS  (DRAM_CASn),
        .WEB  (DRAM_WEn),
        .A    (DRAM_A),
        .DI   (DRAM_D),
        .DO   (DRAM_Q),
        .valid(DRAM_valid)
    );



endmodule


