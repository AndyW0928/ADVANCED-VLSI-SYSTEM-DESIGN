//////////////////////////////////////////////////////////////////////
//          ??  ?  ??       ??  ?  ?  ?  ?  ?  ??   ??  ?  ??  ??  ?  ??    ??  ?  ?  ?  ?  ?  ??            		//
//          ??  ?  ??       ??  ?  ?  ?  ?  ?  ??   ??  ?  ??  ??  ?  ??    ??  ?  ?  ?  ?  ?  ??            		//
//          ??  ?  ??       ??  ?  ?  ?  ?  ?  ??   ??  ?  ?  ?  ?  ?  ?  ??    ??  ?  ?  ?  ?  ?  ??            		//
//          ??  ?  ??       ??  ?  ?  ?  ?  ?  ??   ??  ?  ?  ?  ?  ?  ?  ??    ??  ?  ?  ?  ?  ?  ??            		//
//          ??  ?  ?  ?  ?  ?  ?  ??  ??  ?  ??  	    ??  ?  ??  ??  ?  ??    ??  ?  ??  	           		//
//          ??  ?  ?  ?  ?  ?  ?  ??  ??  ?  ??  	    ??  ?  ??  ??  ?  ??    ??  ?  ??  	           		//
//                                                             		//
// 	2024 Advanced VLSI System Design, advisor: Lih-Yih, Chiou		//
//                                                             		//
//////////////////////////////////////////////////////////////////////
//                                                             		//
// 	Autor: 			TZUNG-JIN, TSAI (Leo)				  	   		//
//	Filename:		 AXI.sv			                            	//
//	Description:	Top module of AXI	 							//
// 	Version:		1.0	    								   		//
//////////////////////////////////////////////////////////////////////
`include "../include/AXI_define.svh"
`include "AXI_READ.sv"
`include "AXI_WRITE.sv"

module AXI(

	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic ARREADY_M0,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic ARREADY_M1,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,

	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,
	
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,
	
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,
	
	//WRITE ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,
	
	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1
	
);
    //---------- you should put your design here ----------//

AXI_WRITE BW(
			.ACLK(ACLK), 
			.ARESETn(ARESETn),
			.AWID_M1(AWID_M1), 
			.AWADDR_M1(AWADDR_M1), 
			.AWLEN_M1(AWLEN_M1), 
			.AWSIZE_M1(AWSIZE_M1),		
			.AWBURST_M1(AWBURST_M1), 
			.AWVALID_M1(AWVALID_M1), 
			.AWREADY_M1(AWREADY_M1),
							
			.WDATA_M1(WDATA_M1), 
			.WSTRB_M1(WSTRB_M1), 
			.WLAST_M1(WLAST_M1), 
			.WVALID_M1(WVALID_M1), 
			.WREADY_M1(WREADY_M1),

			.BID_M1(BID_M1), 
			.BRESP_M1(BRESP_M1), 
			.BVALID_M1(BVALID_M1), 
			.BREADY_M1(BREADY_M1),

			.AWID_S1(AWID_S1), 
			.AWADDR_S1(AWADDR_S1), 
			.AWLEN_S1(AWLEN_S1), 
			.AWSIZE_S1(AWSIZE_S1), 
			.AWBURST_S1(AWBURST_S1), 
			.AWVALID_S1(AWVALID_S1), 
			.AWREADY_S1(AWREADY_S1),

			.WDATA_S1(WDATA_S1), 
			.WSTRB_S1(WSTRB_S1), 
			.WLAST_S1(WLAST_S1), 
			.WVALID_S1(WVALID_S1), 
			.WREADY_S1(WREADY_S1),

			.BID_S1(BID_S1), 
			.BRESP_S1(BRESP_S1), 
			.BVALID_S1(BVALID_S1), 
			.BREADY_S1(BREADY_S1),

			.AWID_S0(AWID_S0), 
			.AWADDR_S0(AWADDR_S0), 
			.AWLEN_S0(AWLEN_S0), 
			.AWSIZE_S0(AWSIZE_S0), 
			.AWBURST_S0(AWBURST_S0), 
			.AWVALID_S0(AWVALID_S0), 
			.AWREADY_S0(AWREADY_S0),

			.WDATA_S0(WDATA_S0), 
			.WSTRB_S0(WSTRB_S0), 
			.WLAST_S0(WLAST_S0), 
			.WVALID_S0(WVALID_S0), 
			.WREADY_S0(WREADY_S0),

			.BID_S0(BID_S0), 
			.BRESP_S0(BRESP_S0), 
			.BVALID_S0(BVALID_S0), 
			.BREADY_S0(BREADY_S0)
);

AXI_READ BR(
			.ACLK(ACLK),
			.ARESETn(ARESETn),
		// Master
		// READ ADDRESS0
			.ARID_M0(ARID_M0),
			.ARADDR_M0(ARADDR_M0),
			.ARLEN_M0(ARLEN_M0),
			.ARSIZE_M0(ARSIZE_M0),
			.ARBURST_M0(ARBURST_M0),
			.ARVALID_M0(ARVALID_M0),
			.ARREADY_M0(ARREADY_M0),

		// READ DATA0
			.RID_M0(RID_M0),
			.RDATA_M0(RDATA_M0),
			.RRESP_M0(RRESP_M0),
			.RLAST_M0(RLAST_M0),
			.RVALID_M0(RVALID_M0),
			.RREADY_M0(RREADY_M0),

		// READ ADDRESS1
			.ARID_M1(ARID_M1),
			.ARADDR_M1(ARADDR_M1),
			.ARLEN_M1(ARLEN_M1),
			.ARSIZE_M1(ARSIZE_M1),
			.ARBURST_M1(ARBURST_M1),
			.ARVALID_M1(ARVALID_M1),
			.ARREADY_M1(ARREADY_M1),

		// READ DATA1
			.RID_M1(RID_M1),
			.RDATA_M1(RDATA_M1),
			.RRESP_M1(RRESP_M1),
			.RLAST_M1(RLAST_M1),
			.RVALID_M1(RVALID_M1),
			.RREADY_M1(RREADY_M1),

		// Slave
		// READ ADDRESS0
			.ARID_S0(ARID_S0),
			.ARADDR_S0(ARADDR_S0),
			.ARLEN_S0(ARLEN_S0),
			.ARSIZE_S0(ARSIZE_S0),
			.ARBURST_S0(ARBURST_S0),
			.ARVALID_S0(ARVALID_S0),
			.ARREADY_S0(ARREADY_S0),

		// READ DATA0
			.RID_S0(RID_S0),
			.RDATA_S0(RDATA_S0),
			.RRESP_S0(RRESP_S0),
			.RLAST_S0(RLAST_S0),
			.RVALID_S0(RVALID_S0),
			.RREADY_S0(RREADY_S0),

		// READ ADDRESS1
			.ARID_S1(ARID_S1),
			.ARADDR_S1(ARADDR_S1),
			.ARLEN_S1(ARLEN_S1),
			.ARSIZE_S1(ARSIZE_S1),
			.ARBURST_S1(ARBURST_S1),
			.ARVALID_S1(ARVALID_S1),
			.ARREADY_S1(ARREADY_S1),
			
		// READ DATA1
			.RID_S1(RID_S1),
			.RDATA_S1(RDATA_S1),
			.RRESP_S1(RRESP_S1),
			.RLAST_S1(RLAST_S1),
			.RVALID_S1(RVALID_S1),
			.RREADY_S1(RREADY_S1)
			);












endmodule
