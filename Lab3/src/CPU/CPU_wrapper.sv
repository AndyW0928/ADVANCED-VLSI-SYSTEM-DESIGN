//CPU wrapper
// `include "../include/AXI_define.svh"
`include "../../src/CPU/CPU.sv"
// `include "../src/AXI/Master_Read.sv"
// `include "../src/AXI/Master_Write.sv"
// `include "src/CPU/CPU.sv"
module CPU_wrapper (
    input ACLK,
    input ARESETn,
	//interrupt
	input logic inter_DMA, inter_WDT,
	output logic WFI_pc_en,

    output [`AXI_ID_BITS-1:0]   AWID_M1,
	output [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	output [`AXI_LEN_BITS-1:0]  AWLEN_M1,
	output [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	output [1:0]                AWBURST_M1,
	output                      AWVALID_M1,
	input                       AWREADY_M1,
	//WRITE DATA
	output [`AXI_DATA_BITS-1:0] WDATA_M1,
	output [`AXI_STRB_BITS-1:0] WSTRB_M1,
	output                      WLAST_M1,
	output                      WVALID_M1,
	input                       WREADY_M1,
	//WRITE RESPONSE
	input [`AXI_ID_BITS-1:0]    BID_M1, 
	input [1:0]                 BRESP_M1,
	input                       BVALID_M1,
	output                      BREADY_M1,

	//READ ADDRESS0
	output [`AXI_ID_BITS-1:0]   ARID_M0,
	output [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	output [`AXI_LEN_BITS-1:0]  ARLEN_M0,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	output [1:0]                ARBURST_M0,
	output                      ARVALID_M0,
	input                       ARREADY_M0,
	//READ DATA0
	input [`AXI_ID_BITS-1:0]    RID_M0,
	input [`AXI_DATA_BITS-1:0]  RDATA_M0,
	input [1:0]                 RRESP_M0,
	input                       RLAST_M0,
	input                       RVALID_M0,
	output                      RREADY_M0,
	//READ ADDRESS1
	output [`AXI_ID_BITS-1:0]   ARID_M1,
	output [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	output [`AXI_LEN_BITS-1:0]  ARLEN_M1,
	output [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	output [1:0]                ARBURST_M1,
	output                      ARVALID_M1,
	input                       ARREADY_M1,
	//READ DATA1
	input [`AXI_ID_BITS-1:0]    RID_M1,
	input [`AXI_DATA_BITS-1:0]  RDATA_M1,
	input [1:0]                 RRESP_M1,
	input                       RLAST_M1,
	input                       RVALID_M1,
	output                      RREADY_M1
);
	wire clk = ACLK;
    wire rst = ARESETn;

// logic IM_CEB, DM_CEB;
logic IM_WEB, DM_WEB;
logic [3:0] IM_BWEB;
// logic [31:0] DM_BWEB;
logic [3:0] DM_BWEB;
logic [31:0] IM_A, DM_A;
logic [31:0] IM_DI, DM_DI;
logic [31:0] IM_DO, DM_DO;

logic IM_READ;
logic DM_WRITE,DM_READ;
logic DM_READ_DONE,IM_READ_DONE;
logic stall_CPU_R0, stall_CPU_R1, stall_CPU_W1, stall_CPU;
 
CPU CPU(
.clk(clk),
.rst(rst),
.WFI_pc_en(WFI_pc_en),
.inter_DMA(inter_DMA), 
.inter_WDT(inter_WDT),
// .IM_CEB(IM_CEB),
// .IM_WEB(IM_WEB),
.IM_READ(IM_READ),
.IM_BWEB(IM_BWEB),
.IM_A(IM_A),
.IM_DI(IM_DI),
.IM_DO(IM_DO),

// .DM_CEB(DM_CEB),
// .DM_WEB(DM_WEB),
.DM_READ(DM_READ),
.DM_WRITE(DM_WRITE),
.DM_BWEB(DM_BWEB),
.DM_A(DM_A),
.DM_DI(DM_DI),
.DM_DO(DM_DO),
.DM_READ_DONE(DM_READ_DONE),
// .IM_READ_DONE(IM_READ_DONE),

.stall_CPU(stall_CPU)
);

assign stall_CPU=stall_CPU_R0 & stall_CPU_W1 ;//& stall_CPU_R1;

// Master_Read MR(.ACLK(ACLK), .ARESETn(ARESETn),
//             .ARID(ARID_M0), .ARADDR(ARADDR_M0), .ARLEN(ARLEN_M0), .ARSIZE(ARSIZE_M0), 
//             .ARBURST(ARBURST_M0), .ARVALID(ARVALID_M0), .ARREADY(ARREADY_M0),

//             .RID(RID_M0), .RDATA(RDATA_M0), .RRESP(RRESP_M0),
//             .RLAST(RLAST_M0), .RVALID(RVALID_M0), .RREADY(RREADY_M0),

//             .read_signal(IM_READ), .A({18'b0,IM_A[15:2]}), .id_in(4'd1),
//             .DO(IM_DO), .stall_CPU_R(stall_CPU_R0), .rvalid_out(IM_READ_DONE)
//             );


// Master_Read MR1(.ACLK(ACLK), .ARESETn(ARESETn),
//             .ARID(ARID_M1), .ARADDR(ARADDR_M1), .ARLEN(ARLEN_M1), .ARSIZE(ARSIZE_M1), 
//             .ARBURST(ARBURST_M1), .ARVALID(ARVALID_M1), .ARREADY(ARREADY_M1),

//             .RID(RID_M1), .RDATA(RDATA_M1), .RRESP(RRESP_M1),
//             .RLAST(RLAST_M1), .RVALID(RVALID_M1), .RREADY(RREADY_M1),

//             .read_signal(DM_READ), .A({17'b0,DM_A[16:2]}), .id_in(4'd2),
//             .DO(DM_DO), .stall_CPU_R(stall_CPU_R1), .rvalid_out(DM_READ_DONE)
//             );


// Master_Write MW(.ACLK(ACLK), .ARESETn(ARESETn),
// 				.AWID(AWID_M1), .AWADDR(AWADDR_M1), .AWLEN(AWLEN_M1), .AWSIZE(AWSIZE_M1),
// 				.AWBURST(AWBURST_M1), .AWVALID(AWVALID_M1), .AWREADY(AWREADY_M1),
				
// 				.WDATA(WDATA_M1), .WSTRB(WSTRB_M1), .WLAST(WLAST_M1), .WVALID(WVALID_M1), .WREADY(WREADY_M1),

// 				.BID(BID_M1), .BRESP(BRESP_M1), .BVALID(BVALID_M1), .BREADY(BREADY_M1), 

// 				.A({18'b0,DM_A[15:2]}), .bweb_in(DM_BWEB), .DI(DM_DI), .id_in(4'd0), .write_signal(DM_WRITE),

// 				.stall_CPU_W(stall_CPU_W1)
// 				);

logic [1:0] MW_nstate,MW_state;
logic [1:0] MR_state,MR_nstate;
logic [3:0] strb;

Master_Read MR(
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

	.read_signal(IM_READ /*read_signal_IM*/), 
	.address_in(IM_A/*pc_32*/), 
	.id_in(4'b1),
	.data_out(IM_DO /*inst*/), 
	.stall_IF(stall_CPU_R0 /*stall_IM*/), 
	.rvalid_out(IM_READ_DONE),

	.MW_state(MW_state), 
	.MW_nstate(MW_nstate),
	.state(MR_state), 
	.nstate(MR_nstate)
);


Master_Read MR1(
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

	.read_signal(DM_READ /*read_signal*/), 
	.address_in(DM_A /*alu_mul_csr*/), 
	.id_in(4'd2),
	.data_out(DM_DO /*ld_data*/), 
	.stall_IF(stall_CPU_R1 /*stall_DM*/), 
	.rvalid_out(DM_READ_DONE),

	.MW_state(2'b0), 
	.MW_nstate(2'b0),
	.state(), 
	.nstate()
);

Master_Write MW(
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

	.address_in(DM_A /*alu_mul_csr*/), 
	.w_en(DM_BWEB /*M_dm_w_en_out*/), 
	.data_in(DM_DI /*rs2_data_RegM_out*/), 
	.id_in(4'd0 /*id_in_W*/), 
	.write_signal(DM_WRITE /*write_signal*/),

	.stall_W(stall_CPU_W1 /*stall_W*/),

	.state(MW_state), 
	.nstate(MW_nstate),
	.MR_state(MR_state), 
	.MR_nstate(MR_nstate)
);


endmodule
