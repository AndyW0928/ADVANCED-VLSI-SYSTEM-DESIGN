`include "../../src/DMA/DMA.sv"
module DMA_wrapper(
	input clk,
	input rst,
	
	//Slave
	//WRITE ADDRESS
	input [`AXI_IDS_BITS-1:0] 	AWID_S3,
	input [`AXI_ADDR_BITS-1:0] 	AWADDR_S3,
	input [`AXI_LEN_BITS-1:0] 	AWLEN_S3,
	input [`AXI_SIZE_BITS-1:0] 	AWSIZE_S3,
	input [1:0] 				AWBURST_S3,
	input 						AWVALID_S3,
	output logic 						AWREADY_S3,
	// WRITE DATA
	input [`AXI_DATA_BITS-1:0] 	WDATA_S3,
	input [`AXI_STRB_BITS-1:0] 	WSTRB_S3,
	input 						WLAST_S3,
	input					 	WVALID_S3,
	output logic 						WREADY_S3,
	// WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] 	BID_S3,
	output logic [1:0] 				BRESP_S3,
	output logic 						BVALID_S3,
	input 						BREADY_S3,

	//READ ADDRESS
	
    output logic ARREADY_S3,
    //READ DATA
    output logic [`AXI_IDS_BITS-1:0] RID_S3,
    output logic [`AXI_DATA_BITS-1:0] RDATA_S3,
    output logic [1:0] RRESP_S3,
    output logic RLAST_S3,
    output logic RVALID_S3,

	//Master
	//READ ADDRESS
	output logic [`AXI_ID_BITS-1:0]   ARID_M2,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_M2,
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_M2,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M2,
	output logic [1:0]                ARBURST_M2,
	output logic                      ARVALID_M2,
	input                       ARREADY_M2,
	//READ DATA
	input [`AXI_ID_BITS-1:0]    RID_M2,
	input [`AXI_DATA_BITS-1:0]  RDATA_M2,
	input [1:0]                 RRESP_M2,
	input                       RLAST_M2,
	input                       RVALID_M2,
	output logic                      RREADY_M2,

	//Master
	//WRITE ADDRESS
	output logic [`AXI_ID_BITS-1:0]   AWID_M2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_M2,
	output logic [`AXI_LEN_BITS-1:0]  AWLEN_M2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M2,
	output logic [1:0]                AWBURST_M2,
	output logic                      AWVALID_M2,
	input                       AWREADY_M2,
	//WRITE DATA
	output logic [`AXI_DATA_BITS-1:0] WDATA_M2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_M2,
	output logic                      WLAST_M2,
	output logic                      WVALID_M2,
	input                       WREADY_M2,
	//WRITE RESPONSE
	input [`AXI_ID_BITS-1:0]    BID_M2, 
	input [1:0]                 BRESP_M2,
	input                       BVALID_M2,
	output logic                      BREADY_M2,

	input 						WFI_pc_en,					
    output logic 				interrupt_dma
);
/*
//slave state
localparam 	IDLE = 2'b00,
			ADDR = 2'b01,
			DATA = 2'b10,
			RESP = 2'b11;

logic [1:0] slave_cs, slave_ns;

//dma controll
localparam  FREE = 4'b0000,
			WAIT_DMA = 4'b0001,
			//READ
			RD_ADDR = 4'b0010,
			RD_ADDR_WAIT = 4'b0011,
			RD_DATA = 4'b0100,
			//WRITE
			WR_ADDR = 4'b0101,
			WR_ADDR_WAIT = 4'b0110,
			WR_DATA = 4'b0111,
			WR_DATA_WAIT = 4'b1000,
			WR_RESP = 4'b1001;

logic [3:0] dma_cs, dma_ns;
*/

/*



//
always_comb
begin
	//slave
	BRESP_S3	=2'b00;
	ARREADY_S3 = 1'd0;
	RID_S3 = 8'd0;
	RDATA_S3 = 32'd0;
	RRESP_S3 = 2'b00;
	RLAST_S3 = 1'd0;
	RVALID_S3 = 1'd0;
	//master
	//write
	AWID_M2    = 4'b0;
	AWADDR_M2  = DMADST_addr;
	AWLEN_M2   = 4'b0;
	AWSIZE_M2  = 3'b010;
	AWBURST_M2 = 2'b01;
	//read
	ARID_M2    = 4'b0;
	ARADDR_M2  = DMASRC_addr;
	ARLEN_M2   = 4'b0;
	ARSIZE_M2  = 3'b010;
	ARBURST_M2 = 2'b01;
	
	DMA_en  = (dma_cs == FREE && dma_ns == WAIT_DMA);
end	
*/
//***********************SLAVE*******************************//
/*
//slave cs
always_ff @(posedge clk or posedge rst)
begin
	if(rst)
		slave_cs <= IDLE;
	else
		slave_cs <= slave_ns;
end

//slave ns
always_comb
begin
	case (slave_cs)
		IDLE :slave_ns = (AWVALID_S3)? ADDR : IDLE; 
		ADDR :slave_ns = (AWVALID_S3 && AWREADY_S3)? DATA : ADDR; 
		DATA :slave_ns = (AWVALID_S3 && AWREADY_S3 && WLAST_S3)? RESP : DATA; 
		RESP :slave_ns = (BREADY_S3 && BVALID_S3)? IDLE : DATA;	
		// default :slave_ns =  IDLE;
	endcase
end

//slave out
always_comb 
begin
	case(slave_cs)
		IDLE: begin
				AWREADY_S3 = 1'b0;
				WREADY_S3  = 1'b0;
				BID_S3     = 8'd0;
				BVALID_S3  = 1'b0;
			end
		ADDR: begin
				AWREADY_S3 = 1'b1;
				WREADY_S3  = 1'b0;
				BID_S3     = 8'd0;
				BVALID_S3  = 1'b0;
			end
		DATA: begin
				AWREADY_S3 = 1'b0;
				WREADY_S3  = 1'b1;
				BID_S3     = 8'd0;
				BVALID_S3  = 1'b0;
			end
		RESP: begin
				AWREADY_S3 = 1'b0;
				WREADY_S3  = 1'b0;
				BID_S3     = AWID_r;
				BVALID_S3  = 1'b1;
			end
		// default: begin
		// 		AWREADY_S3 = 1'b0;
		// 		WREADY_S3  = 1'b0;
		// 		BID_S3     = 8'd0;
		// 		BVALID_S3  = 1'b0;
		// 	end
	endcase
end

//AWID_r reg
always_ff@(posedge clk or posedge rst) 
begin
    if(rst)begin
		AWID_r   <= 8'd0;
	end
    else if (slave_cs == IDLE && slave_ns == ADDR) begin
		AWID_r <= AWID_S3;
	end
    else begin
		AWID_r <= AWID_r;
	end
end
*/
//***********************MASTER*******************************//
/*
always_ff@(posedge clk or posedge rst)
begin
    if(rst)begin
        AWADDR_r <= 32'd0;
	end
    else if(AWVALID_S3 && AWREADY_S3)begin
        AWADDR_r <= AWADDR_S3;
	end
end

//arb
always_ff@(posedge clk or posedge rst) 
begin
    if(rst)begin
		DMAEN  <= 1'd0;
        DMASRC <= 32'd0;
        DMADST <= 32'd0;
        DMALEN <= 32'd0;
	end
    else begin
        if(WVALID_S3 && WREADY_S3)begin
            if(AWADDR_r == 32'h10020100)
                DMAEN <= WDATA_S3[0];
            else if (AWADDR_r == 32'h10020200) begin
                DMASRC <= WDATA_S3;
            end
            else if (AWADDR_r == 32'h10020300) begin
                DMADST <= WDATA_S3;
            end
            else if (AWADDR_r == 32'h10020400) begin
                DMALEN <= WDATA_S3;
            end
        end
    end
end


//dma_cs
always_ff@(posedge clk or posedge rst)
begin
    if(rst)
        dma_cs <= FREE;
    else 
        dma_cs <= dma_ns;
end

//dma_ns
always_comb
begin
	case(dma_cs)
	FREE : begin
			if (DMAEN) begin
				if(interrupt_dma || DMALEN == 32'b0)
					dma_ns = FREE;
				else 
					dma_ns = WAIT_DMA;	
			end
			else
				dma_ns = FREE;
			end	
	WAIT_DMA :  begin
			dma_ns = RD_ADDR;
			end
		
	RD_ADDR : dma_ns = (ARREADY_M2 && ARVALID_M2)? RD_ADDR_WAIT : RD_ADDR;
	RD_ADDR_WAIT : dma_ns = RD_DATA;
	RD_DATA : 	begin
				if(RVALID_M2 && RREADY_M2 && RLAST_M2 && (RRESP_M2==2'b00))
					dma_ns = WR_ADDR;
                else
                    dma_ns = RD_DATA;
				end		
		
	WR_ADDR : dma_ns = (AWREADY_M2 && AWVALID_M2)? WR_ADDR_WAIT : WR_ADDR;
	WR_ADDR_WAIT : dma_ns = WR_DATA; 
	WR_DATA : dma_ns = (WVALID_M2 && WREADY_M2 && WLAST_M2)? WR_DATA_WAIT :WR_DATA;
	WR_DATA_WAIT : dma_ns = WR_RESP; 
	WR_RESP : begin
				if(BVALID_M2 && BREADY_M2 && (BRESP_M2==2'b00))
                dma_ns =  FREE;
            	else
                dma_ns = WR_RESP;
        	end	
	default : dma_ns =  FREE;
	endcase
end

//out
always_comb 
begin
	        ARVALID_M2 = 1'b0;
            RREADY_M2  = 1'b0;

			AWVALID_M2 = 1'b0;            
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b0;
            WSTRB_M2   = 4'b0000;
    case(dma_cs)
        FREE:begin
            ARVALID_M2 = 1'b0;
            RREADY_M2  = 1'b0;

			AWVALID_M2 = 1'b0;            
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b0;
            WSTRB_M2   = 4'b0000;
        	end
		WAIT_DMA : begin
			ARVALID_M2 = 1'b0;
            RREADY_M2  = 1'b0;
			end
        RD_ADDR  : begin
            ARVALID_M2 = 1'b1;
            RREADY_M2  = 1'b0;
       		end
        RD_ADDR_WAIT  : begin
            ARVALID_M2 = 1'b0;
            RREADY_M2  = 1'b0;
        	end
        	RD_DATA  : begin
            ARVALID_M2 = 1'b0;
            RREADY_M2  = 1'b1;
        	end

		WR_ADDR : begin
            AWVALID_M2 = 1'b1;
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b0;
            WSTRB_M2   = 4'b0000;
        	end
        WR_ADDR_WAIT : begin
            AWVALID_M2 = 1'b0;
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b0;
            WSTRB_M2   = 4'b0000;
        	end
        WR_DATA : begin
            AWVALID_M2 = 1'b0;
            WLAST_M2   = 1'b1;
            WVALID_M2  = 1'b1;
            BREADY_M2  = 1'b0; 
            WSTRB_M2   = 4'b0000;
        	end
        WR_DATA_WAIT : begin
            AWVALID_M2 = 1'b0;
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b0;
            WSTRB_M2   = 4'b0000;
        	end
        WR_RESP : begin
            AWVALID_M2 = 1'b0;
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b1;
            WSTRB_M2   = 4'b0000;
        	end

        default    : begin
            ARVALID_M2 = 1'b0;
            RREADY_M2  = 1'b0;
			AWVALID_M2 = 1'b0;
            WLAST_M2   = 1'b0;
            WVALID_M2  = 1'b0;
            BREADY_M2  = 1'b0;
            WSTRB_M2   = 4'b0000;
        end
    endcase
end

*/

logic DMA_en;

logic DMAEN;
logic [31:0] DMASRC;
logic [31:0] DMADST;
logic [31:0] DMALEN;
logic [31:0] DMASRC_addr, DMADST_addr;

//SLAVE WRITE
logic [31:0] dma_write_addr;
logic [31:0] DI_out;

always_ff@(posedge clk or posedge rst) 
begin
    if(rst)begin
		DMAEN  <= 1'd0;
        DMASRC <= 32'd0;
        DMADST <= 32'd0;
        DMALEN <= 32'd0;
	end
    else begin
        if(WVALID_S3 && WREADY_S3)begin
            if(dma_write_addr == 32'h10020100)
                DMAEN <= DI_out[0];
            else if (dma_write_addr == 32'h10020200) begin
                DMASRC <= DI_out;
            end
            else if (dma_write_addr == 32'h10020300) begin
                DMADST <= DI_out;
            end
            else if (dma_write_addr == 32'h10020400) begin
                DMALEN <= DI_out;
            end
        end
    end
end

SRAM_SlaveWrite DRAM_SlaveWrite(.ACLK(clk), .ARESETn(rst),
            .AWID(AWID_S3), .AWADDR(AWADDR_S3), .AWLEN(AWLEN_S3), .AWSIZE(AWSIZE_S3), 
            .AWBURST(AWBURST_S3), .AWVALID(AWVALID_S3), .AWREADY(AWREADY_S3),

            .WDATA(WDATA_S3), .WSTRB(WSTRB_S3), .WLAST(WLAST_S3), .WVALID(WVALID_S3), .WREADY(WREADY_S3),

            .BID(BID_S3), .BRESP(BRESP_S3), .BVALID(BVALID_S3), .BREADY(BREADY_S3),

            .A(dma_write_addr), .DI(DI_out), .BWEB(),.isnot_writing(), .select(2'd2)
            );


logic [31:0] dma_trans_data;
//MASTER
Master_Read MR2(
	.ACLK(clk), 
	.ARESETn(rst),
	.ARID(ARID_M2), 
	.ARADDR(ARADDR_M2), 
	.ARLEN(ARLEN_M2), 
	.ARSIZE(ARSIZE_M2), 
	.ARBURST(ARBURST_M2), 
	.ARVALID(ARVALID_M2), 
	.ARREADY(ARREADY_M2),

	.RID(RID_M2), 
	.RDATA(RDATA_M2), 
	.RRESP(RRESP_M2),
	.RLAST(RLAST_M2), 
	.RVALID(RVALID_M2), 
	.RREADY(RREADY_M2),

	.read_signal(DMAEN), 
	.address_in(DMASRC_addr), 
	.id_in(4'd2),
	.data_out(dma_trans_data), 
	.stall_IF(), 
	.rvalid_out(),

	.MW_state(2'b0), 
	.MW_nstate(2'b0),
	.state(), 
	.nstate()
);

Master_Write MW2(
	.ACLK(clk), 
	.ARESETn(rst),
	.AWID(AWID_M2), 
	.AWADDR(AWADDR_M2), 
	.AWLEN(AWLEN_M2), 
	.AWSIZE(AWSIZE_M2),
	.AWBURST(AWBURST_M2), 
	.AWVALID(AWVALID_M2), 
	.AWREADY(AWREADY_M2),
	
	.WDATA(WDATA_M2), 
	.WSTRB(WSTRB_M2), 
	.WLAST(WLAST_M2), 
	.WVALID(WVALID_M2), 
	.WREADY(WREADY_M2),

	.BID(BID_M2), 
	.BRESP(BRESP_M2), 
	.BVALID(BVALID_M2), 
	.BREADY(BREADY_M2), 

	.address_in(DMADST_addr), 
	.w_en(4'b0000), 
	.data_in(dma_trans_data), 
	.id_in(4'd0), 
	.write_signal(1'b0),

	.stall_W(),

	.state(), 
	.nstate(),
	.MR_state(2'b0), 
	.MR_nstate(2'b0)
);

assign DMA_en = (DMAEN && ~(interrupt_dma || DMALEN == 32'b0));

DMA DMA(
    .clk(clk),
    .rst(rst),
    .DMAEN(DMAEN),
    .DMASRC(DMASRC),
    .DMADST(DMADST),
    .DMALEN(DMALEN),
	.WFI_pc_en(WFI_pc_en),
    .interrupt_dma(interrupt_dma),
    .DMASRC_addr(DMASRC_addr),
    .DMADST_addr(DMADST_addr),
    .dma_en(DMA_en)
);

endmodule