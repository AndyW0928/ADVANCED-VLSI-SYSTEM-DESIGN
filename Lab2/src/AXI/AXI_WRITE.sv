`include "../include/AXI_define.svh"

module AXI_WRITE(

    input ACLK,
	input ARESETn,
    
    // Master
    // WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	// WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	// WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

    // Slave
    // WRITE ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,
	// WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,
	// WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,
	// WRITE ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	// WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	// WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1
);


localparam  IDLE = 1'b0,
            DATA = 1'b1;

logic w_cs, w_ns;


//cs
always_ff@(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)begin
        w_cs <= IDLE;
    end
	else begin
        w_cs <= w_ns;
    end
end

//ns
always_comb 
begin
    case(w_cs)
    IDLE : begin
        if( AWVALID_M1 && AWREADY_S1) begin     //M1 S1
            w_ns = DATA;
        end
        else if( AWVALID_M1 && AWREADY_S0 ) begin   //M1 S0
            w_ns = DATA;
        end
        else begin
            w_ns = IDLE;
        end
        end

    DATA : begin
        if ( BREADY_M1 && BVALID_M1 )           //done
            w_ns = IDLE;
        else
            w_ns = DATA;
        end
    endcase
end

//********************************************************************//
//slave choose
logic S_sel;
logic S_sel_r;

always_comb 
begin
    case(w_cs)
    IDLE : begin
        if( AWVALID_M1 && AWREADY_S1) begin     //M1 S1
            S_sel = 1'b1;
        end
        else if( AWVALID_M1 && AWREADY_S0 ) begin   //M1 S0
            S_sel = 1'b0;
        end
        else begin
            S_sel = 1'b0;
        end
        end

    DATA : begin
            S_sel = S_sel_r;
        end
    endcase
end


always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn) begin
        S_sel_r <= 1'b0;
    end
	else begin
		if(w_cs == IDLE)
        S_sel_r <= S_sel;
		else
		S_sel_r <= S_sel_r;
    end
end
//***************************************************************************//
//reg
logic [`AXI_LEN_BITS-1:0] AWLEN_r;

always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn) begin
        AWLEN_r <= 4'd0;
    end
	else begin
        case(w_cs)
        IDLE:begin
                if(AWVALID_M1) begin
                    AWLEN_r <= AWLEN_M1;
                end
                else begin
                    AWLEN_r <= AWLEN_r;
                end
            end

        DATA:begin
            AWLEN_r <= AWLEN_r;
            end
    endcase
    end
end

/*
logic WVALID_r;
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
    begin
        WVALID_r<=1'b0;
    end
	else begin
        WVALID_r<=WVALID_M1;
    end
end
*/
//*********************************************************************//
//out

always_comb 
begin
    case(w_cs)
    IDLE:begin
        //MASTER 
            AWREADY_M1 = 1'd0;
    
            WREADY_M1 = 1'd0;

            BID_M1 = 4'd0;
            BRESP_M1 = 2'd0;
            BVALID_M1 = 1'd0;

        //SLAVE 
        //S0
            AWID_S0 = 8'd0;
            AWADDR_S0 = 32'd0;
            AWLEN_S0 = 4'd0;
            AWSIZE_S0 = 3'd0;
            AWBURST_S0 = 2'd0;
            AWVALID_S0 = 1'd0;

            WDATA_S0 = 32'd0;
            WSTRB_S0 = 4'd0;
            WLAST_S0 = 1'd0;
            WVALID_S0 = 1'd0;

            BREADY_S0 = 1'd0;

        //S1
            AWID_S1 = 8'd0;
            AWADDR_S1 = 32'd0;
            AWLEN_S1 = 4'd0;
            AWSIZE_S1 = 3'd0;
            AWBURST_S1 = 2'd0;
            AWVALID_S1 = 1'd0;

            WDATA_S1 = 32'd0;
            WSTRB_S1 = 4'd0;
            WLAST_S1 = 1'd0;
            WVALID_S1 = 1'd0;

            BREADY_S1 = 1'd0;
        end

    DATA: begin
        if(~S_sel)begin
        //MASTER 
            AWREADY_M1 = AWREADY_S0;

            WREADY_M1 = WREADY_S0;

            BID_M1 = BID_S0[3:0];
            BRESP_M1 = BRESP_S0;
            BVALID_M1 = BVALID_S0;

        //SLAVE 
        //S0
			AWID_S0 = {4'b0,AWID_M1};
            AWADDR_S0 = AWADDR_M1;
            AWLEN_S0 = AWLEN_r;
            AWSIZE_S0 = AWSIZE_M1;
            AWBURST_S0 = AWBURST_M1;
            AWVALID_S0 = AWVALID_M1;
            
			WDATA_S0 = WDATA_M1;           
            WSTRB_S0 = WSTRB_M1;
            WLAST_S0 = WLAST_M1;
            WVALID_S0 = WVALID_M1; 

            BREADY_S0 = BREADY_M1;
        //S1
            AWID_S1 = 8'd0;
            AWADDR_S1 = 32'd0;
            AWLEN_S1 = 4'd0;
            AWSIZE_S1 = 3'd0;
            AWBURST_S1 = 2'd0;
            AWVALID_S1 = 1'd0;
            
            WDATA_S1 = 32'd0;
            WSTRB_S1 = 4'd0;
            WLAST_S1 = 1'd0;
            WVALID_S1 = 1'd0;
            
            BREADY_S1 = 1'd0;
            end

        else begin
        //MASTER 
            AWREADY_M1 = AWREADY_S1;
            
            WREADY_M1 = WREADY_S1;
            
            BID_M1 = BID_S1[3:0];
            BRESP_M1 = BRESP_S1;
            BVALID_M1 = BVALID_S1;

        //SLAVE 
        //S0
            AWID_S0 = 8'd0;
            AWADDR_S0 = 32'd0;
            AWLEN_S0 = 4'd0;
            AWSIZE_S0 = 3'd0;
            AWBURST_S0 = 2'd0;
            AWVALID_S0 = 1'd0;
            
            WDATA_S0 = 32'd0;
            WSTRB_S0 = 4'd0;
            WLAST_S0 = 1'd0;
            WVALID_S0 = 1'd0;
            
            BREADY_S0 = 1'd0;
        //S1
			AWID_S1 = {4'b0,AWID_M1};
            AWADDR_S1 = AWADDR_M1;
            AWLEN_S1 = AWLEN_r;
            AWSIZE_S1 = AWSIZE_M1;
            AWBURST_S1 = AWBURST_M1;
            AWVALID_S1 = AWVALID_M1;
            
			WDATA_S1 = WDATA_M1;
            WSTRB_S1 = WSTRB_M1;		
            WLAST_S1 = WLAST_M1;
            WVALID_S1 = WVALID_M1;
            
            BREADY_S1 = BREADY_M1;
            
            end
        end 
    endcase
end


endmodule
