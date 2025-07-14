// `include "../../src/DMA/DMA_Master_Read.sv"
// `include "../../src/DMA/DMA_Master_Write.sv"
// `include "../../src/DMA/DMA_Slave_Write.sv"
// `include "../../src/DMA/DMA.sv"

module DMA_wrapper (
    input  logic                        clk,
    input  logic                        rst,

    // Slave Interface
    input  logic [`AXI_IDS_BITS-1:0]    AWID_S3,
    input  logic [`AXI_ADDR_BITS-1:0]   AWADDR_S3,
    input  logic [`AXI_LEN_BITS-1:0]    AWLEN_S3,
    input  logic [`AXI_SIZE_BITS-1:0]   AWSIZE_S3,
    input  logic [1:0]                  AWBURST_S3,
    input  logic                        AWVALID_S3,
    output logic                        AWREADY_S3,
    input  logic [`AXI_DATA_BITS-1:0]   WDATA_S3,
    input  logic [`AXI_STRB_BITS-1:0]   WSTRB_S3,
    input  logic                        WLAST_S3,
    input  logic                        WVALID_S3,
    output logic                        WREADY_S3,
    output logic [`AXI_IDS_BITS-1:0]    BID_S3,
    output logic [1:0]                  BRESP_S3,
    output logic                        BVALID_S3,
    input  logic                        BREADY_S3,
    input  logic [`AXI_IDS_BITS-1:0]    ARID_S3,
    input  logic [`AXI_ADDR_BITS-1:0]   ARADDR_S3,
    input  logic [`AXI_LEN_BITS-1:0]    ARLEN_S3,
    input  logic [`AXI_SIZE_BITS-1:0]   ARSIZE_S3,
    input  logic [1:0]                  ARBURST_S3,
    input  logic                        ARVALID_S3,
    output logic                        ARREADY_S3,
    output logic [`AXI_IDS_BITS-1:0]    RID_S3,
    output logic [`AXI_DATA_BITS-1:0]   RDATA_S3,
    output logic [1:0]                  RRESP_S3,
    output logic                        RLAST_S3,
    output logic                        RVALID_S3,
    input  logic                        RREADY_S3,

    // Master Interface
    output logic [`AXI_ID_BITS-1:0]     ARID_M2,
    output logic [`AXI_ADDR_BITS-1:0]   ARADDR_M2,
    output logic [`AXI_LEN_BITS-1:0]    ARLEN_M2,
    output logic [`AXI_SIZE_BITS-1:0]   ARSIZE_M2,
    output logic [1:0]                  ARBURST_M2,
    output logic                        ARVALID_M2,
    input  logic                        ARREADY_M2,
    input  logic [`AXI_ID_BITS-1:0]     RID_M2,
    input  logic [`AXI_DATA_BITS-1:0]   RDATA_M2,
    input  logic [1:0]                  RRESP_M2,
    input  logic                        RLAST_M2,
    input  logic                        RVALID_M2,
    output logic                        RREADY_M2,
    output logic [`AXI_ID_BITS-1:0]     AWID_M2,
    output logic [`AXI_ADDR_BITS-1:0]   AWADDR_M2,
    output logic [`AXI_LEN_BITS-1:0]    AWLEN_M2,
    output logic [`AXI_SIZE_BITS-1:0]   AWSIZE_M2,
    output logic [1:0]                  AWBURST_M2,
    output logic                        AWVALID_M2,
    input  logic                        AWREADY_M2,
    output logic [`AXI_DATA_BITS-1:0]   WDATA_M2,
    output logic [`AXI_STRB_BITS-1:0]   WSTRB_M2,
    output logic                        WLAST_M2,
    output logic                        WVALID_M2,
    input  logic                        WREADY_M2,
    input  logic [`AXI_ID_BITS-1:0]     BID_M2,
    input  logic [1:0]                  BRESP_M2,
    input  logic                        BVALID_M2,
    output logic                        BREADY_M2,

    input  logic                        WFI_pc_en,
    output logic                        interrupt_dma
);

    // Internal Signals
    logic [31:0]                        DMASRC_addr, DMADST_addr;
    logic [31:0]                        DMA_SlaveWrite_addr, DMA_SlaveWrite_data;
    logic                               slave_write;
    logic                               read_complete, read_valid, write_complete, write_valid;
    logic                               master_read, master_write;
    logic [3:0]                         burst_LEN;
    logic [31:0]                        read_data, write_data;

    assign slave_write = WVALID_S3 && WREADY_S3;
    assign write_ready = AWREADY_M2;

    DMA DMA (
        .clk(clk), .rst(rst),
        .slave_write(slave_write),
        .DMA_SlaveWrite_addr(DMA_SlaveWrite_addr),
        .DMA_SlaveWrite_data(DMA_SlaveWrite_data),
        .WFI_pc_en(WFI_pc_en),
        .read_ready(read_ready),
        .write_ready(write_ready),
        .read_complete(read_complete),
        .read_valid(read_valid),
        .write_valid(write_valid),
        .write_complete(write_complete),
        .interrupt(interrupt_dma),
        .DMASRC_addr(DMASRC_addr),
        .DMADST_addr(DMADST_addr),
        .master_read(master_read),
        .master_write(master_write),
        .read_data(read_data),
        .write_data(write_data),
        .burst_LEN(burst_LEN)
    );

    DMA_Slave_Write DMA_Slave_Write (
        .ACLK(clk), .ARESETn(rst),
        .AWID(AWID_S3), .AWADDR(AWADDR_S3), .AWLEN(AWLEN_S3), .AWSIZE(AWSIZE_S3),
        .AWBURST(AWBURST_S3), .AWVALID(AWVALID_S3), .AWREADY(AWREADY_S3),
        .WDATA(WDATA_S3), .WSTRB(WSTRB_S3), .WLAST(WLAST_S3), .WVALID(WVALID_S3),
        .WREADY(WREADY_S3), .BID(BID_S3), .BRESP(BRESP_S3), .BVALID(BVALID_S3),
        .BREADY(BREADY_S3), .A(DMA_SlaveWrite_addr), .DI(DMA_SlaveWrite_data),
        .BWEB(), .isnot_writing()
    );

    DMA_Master_Read DMA_Master_Read (
        .ACLK(clk), .ARESETn(rst),
        .ARID(ARID_M2), .ARADDR(ARADDR_M2), .ARLEN(ARLEN_M2), .ARSIZE(ARSIZE_M2),
        .ARBURST(ARBURST_M2), .ARVALID(ARVALID_M2), .ARREADY(ARREADY_M2),
        .RID(RID_M2), .RDATA(RDATA_M2), .RRESP(RRESP_M2), .RLAST(RLAST_M2),
        .RVALID(RVALID_M2), .RREADY(RREADY_M2), .read_signal(master_read),
        .A(DMASRC_addr), .id_in(4'd3), .DO(read_data), .stall_CPU_R(),
        .rvalid_out(read_valid), .rlast_out(read_complete), .burst_LEN(burst_LEN)
    );

    DMA_Master_Write DMA_Master_Write (
        .ACLK(clk), .ARESETn(rst),
        .AWID(AWID_M2), .AWADDR(AWADDR_M2), .AWLEN(AWLEN_M2), .AWSIZE(AWSIZE_M2),
        .AWBURST(AWBURST_M2), .AWVALID(AWVALID_M2), .AWREADY(AWREADY_M2),
        .WDATA(WDATA_M2), .WSTRB(WSTRB_M2), .WLAST(WLAST_M2), .WVALID(WVALID_M2),
        .WREADY(WREADY_M2), .BID(BID_M2), .BRESP(BRESP_M2), .BVALID(BVALID_M2),
        .BREADY(BREADY_M2), .A(DMADST_addr), .bweb_in(4'b1111), .DI(write_data),
        .id_in(4'd4), .write_signal(master_write), .stall_CPU_W(),
        .burst_LEN(burst_LEN), .wvalid_out(write_valid), .wlast_out(write_complete)
    );

endmodule
