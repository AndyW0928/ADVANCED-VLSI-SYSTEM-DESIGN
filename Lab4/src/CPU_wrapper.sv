//CPU wrapper
// `include "../include/AXI_define.svh"
// `include "../../src/CPU/CPU.sv"
// `include "../../src/CPU/Master_Read.sv"
// `include "../../src/CPU/Master_Write.sv"

// `include "src/CPU/CPU.sv"
// `include "src/CPU/Master_Read.sv"
// `include "src/CPU/Master_Write.sv"


// `include "src/CACHE/L1C_inst.sv"
// `include "src/CACHE/L1C_data.sv"
// `include "src/CACHE/tag_array_wrapper.sv"
// `include "src/CACHE/data_array_wrapper.sv"

// `include "../../src/CACHE/L1C_inst.sv"
// `include "../../src/CACHE/L1C_data.sv"
// `include "../../src/CACHE/tag_array_wrapper.sv"
// `include "../../src/CACHE/data_array_wrapper.sv"

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
// logic IM_WEB, DM_WEB;
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
 

logic Is_M0_now_reading,Is_M0_next_reading;
logic Is_M1_now_writing,Is_M1_next_writing;

//cache
logic IM_READ_AXI;
logic [31:0] IM_A_AXI;
logic stall_IM, stall_DM;
logic [31:0] inst_L1c, data_L1C;

logic DM_READ_AXI, DM_WRITE_AXI;
logic [31:0] DM_A_AXI;
logic [31:0] DM_DI_AXI;
logic [3:0] DM_BWEB_AXI;
logic read_finish;

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
.IM_DO(inst_L1c),

// .DM_CEB(DM_CEB),
// .DM_WEB(DM_WEB),
.DM_READ(DM_READ),
.DM_WRITE(DM_WRITE),
.DM_BWEB(DM_BWEB),
.DM_A(DM_A),
.DM_DI(DM_DI),
.DM_DO(data_L1C),
.DM_READ_DONE(read_finish),
// .IM_READ_DONE(IM_READ_DONE),

.stall_CPU(stall_CPU)
);

//========================================MASTER0=========================================//

L1C_inst L1C_inst(
					.clk(ACLK),
					.rst(ARESETn),

				// Core to CPU wrapper
					.core_addr(IM_A),
					.core_req(IM_READ),	// im_OE
					.I_out(IM_DO),
					//	 .I_wait(),
					//   .rvalid_m0_i(),	// NEW
					//   .rready_m0_i(),
					.core_wait_CD_i(stall_DM),       //L1C_data stall

				// CPU wrapper to core
					.core_out(inst_L1c),	// im_DO
					.core_wait(stall_IM),	// ON when L1CI_state is not IDLE

				// CPU wrapper to Mem
					.I_req(IM_READ_AXI),	// ON when L1CI_state is READ_MISS, like im_OE
					.I_addr(IM_A_AXI), // when L1CI_state is READ_MISS, send to wrapper

				//for AXI
					.RVALID(RVALID_M0), 
					.RLAST(RLAST_M0)
);

// assign DM_READ_DONE = RVALID_M1;
//assign stall_CPU = stall_CPU_R0 & stall_CPU_W1 ;//& stall_CPU_R1;

assign stall_CPU = stall_DM || stall_IM ;

Master_Read MR(.ACLK(ACLK), .ARESETn(ARESETn),
            .ARID(ARID_M0), .ARADDR(ARADDR_M0), .ARLEN(ARLEN_M0), .ARSIZE(ARSIZE_M0), 
            .ARBURST(ARBURST_M0), .ARVALID(ARVALID_M0), .ARREADY(ARREADY_M0),

            .RID(RID_M0), .RDATA(RDATA_M0), .RRESP(RRESP_M0),
            .RLAST(RLAST_M0), .RVALID(RVALID_M0), .RREADY(RREADY_M0),

            .read_signal(IM_READ_AXI), .A(IM_A_AXI), .id_in(4'd1),
            .DO(IM_DO), .stall_CPU_R(stall_CPU_R0), .rvalid_out(IM_READ_DONE),
			// .Is_M_now_reading_i(1'b0), .Is_M_next_reading_i(1'b0),
			.Is_M_now_writing_i(Is_M1_now_writing),.Is_M_next_writing_i(Is_M1_next_writing),

            .Is_M_now_reading_o(Is_M0_now_reading), .Is_M_next_reading_o(Is_M0_next_reading)
			);


//========================================MASTER1=========================================//

logic L1c_data_req;
assign L1c_data_req = DM_WRITE || DM_READ;

L1C_data L1C_data(
					.clk(ACLK),
					.rst(ARESETn),
					
				// Core to CPU wrapper
					.core_addr(DM_A),
					.core_req(L1c_data_req),
					.core_write_req(DM_WRITE),
					.core_write(DM_BWEB),	// DM_wen from CPU
					.core_in(DM_DI),
				//	.core_type(),
				
				// Mem to CPU wrapper
					.D_out(DM_DO),
					//   .D_wait(), // unused
					//   .rvalid_m1_i(),	// NEW
					//   .rready_m1_i(),
					.core_wait_CI_i(stall_IM),         //L1C_inst stall
				
				// CPU wrapper to core
					.core_out(data_L1C),
					.core_wait(stall_DM),
				
				// CPU wrapper to Mem
					.D_req(DM_READ_AXI),
					.D_addr(DM_A_AXI),
					.D_write(DM_WRITE_AXI),
					.D_in(DM_DI_AXI),
					.D_type(DM_BWEB_AXI),	// DM_wen to CPU wrapper

				//for AXI
					.RVALID(RVALID_M1), 
					.RLAST(RLAST_M1),
					.BVALID(BVALID_M1), 
					.BREADY(BREADY_M1),
					// .WVALID(WVALID_M1),
					// .WREADY(WREADY_M1),
					// .WLAST(WLAST_M1),
					// .BVALID(WLAST_M1), 
					// .BREADY(1'b1),

					.read_finish(read_finish)
);


Master_Read MR1(.ACLK(ACLK), .ARESETn(ARESETn),
            .ARID(ARID_M1), .ARADDR(ARADDR_M1), .ARLEN(ARLEN_M1), .ARSIZE(ARSIZE_M1), 
            .ARBURST(ARBURST_M1), .ARVALID(ARVALID_M1), .ARREADY(ARREADY_M1),

            .RID(RID_M1), .RDATA(RDATA_M1), .RRESP(RRESP_M1),
            .RLAST(RLAST_M1), .RVALID(RVALID_M1), .RREADY(RREADY_M1),

            .read_signal(DM_READ_AXI), .A(DM_A_AXI), .id_in(4'd2),
            .DO(DM_DO), .stall_CPU_R(stall_CPU_R1), .rvalid_out(DM_READ_DONE),

			.Is_M_now_writing_i(1'b0),.Is_M_next_writing_i(1'b0),
			
            .Is_M_now_reading_o(), .Is_M_next_reading_o()
            );


Master_Write MW(.ACLK(ACLK), .ARESETn(ARESETn),
				.AWID(AWID_M1), .AWADDR(AWADDR_M1), .AWLEN(AWLEN_M1), .AWSIZE(AWSIZE_M1),
				.AWBURST(AWBURST_M1), .AWVALID(AWVALID_M1), .AWREADY(AWREADY_M1),
				
				.WDATA(WDATA_M1), .WSTRB(WSTRB_M1), .WLAST(WLAST_M1), .WVALID(WVALID_M1), .WREADY(WREADY_M1),

				.BID(BID_M1), .BRESP(BRESP_M1), .BVALID(BVALID_M1), .BREADY(BREADY_M1), 

				.A(DM_A_AXI), .bweb_in(DM_BWEB_AXI), .DI(DM_DI_AXI), .id_in(4'd0), .write_signal(DM_WRITE_AXI),

				.stall_CPU_W(stall_CPU_W1),

				.Is_M_now_reading_i(Is_M0_now_reading), .Is_M_next_reading_i(Is_M0_next_reading),
				.Is_M_now_writing_o(Is_M1_now_writing), .Is_M_next_writing_o(Is_M1_next_writing)
				);


endmodule
