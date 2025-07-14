`include "../include/AXI_define.svh"

module AXI_READ(
    input ACLK,
	input ARESETn,

//SLAVE INTERFACE FOR MASTERS
	

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

localparam IDLE = 1'b0;
localparam DATA = 1'b1;

logic r_cs, r_ns;
logic M_ps;     //last master
logic M_cs;     //next master
logic S_sel, S_sel_r;


//cs
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
        r_cs <= IDLE;
    else 
        r_cs <= r_ns;
end  

//ns
always_comb
begin
    case(r_cs)
    IDLE : begin
            if(ARVALID_M0 && ARVALID_M1) begin          //both
                if(ARREADY_S0) begin
                    r_ns = DATA;
                end
                else if(ARREADY_S1) begin
                    r_ns = DATA;
                end
                else begin
                    r_ns = IDLE;
                end
            end
            else if(ARVALID_M0 && ARREADY_S0) begin     //M0 S0
                r_ns = DATA;
            end
            else if(ARVALID_M0 && ARREADY_S1) begin     //M0 S1
                r_ns = DATA;
            end
            else if(ARVALID_M1 && ARREADY_S0) begin     //M1 S0
                r_ns = DATA;
            end
            else if(ARVALID_M1 && ARREADY_S1) begin     //M1 S1
                r_ns = DATA;
            end
            else begin
                r_ns = IDLE;
            end
        end 
    DATA : begin 
            if (M_cs == 1'b0) begin     //M0
                if (RREADY_S0 && RVALID_S0 && RLAST_M0 || RREADY_S1 && RVALID_S1 && RLAST_M0)
                    r_ns = IDLE;    //done
                else
                    r_ns = DATA;
            end
            else begin      //M1
                if (RREADY_S1 && RVALID_S1 && RLAST_M1 || RREADY_S0 && RVALID_S0 && RLAST_M1)
                    r_ns = IDLE;    //done
                else
                    r_ns = DATA;
            end   
        end
    endcase
end        

//*************************************************************************//
//Master choose (round)
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn)
        M_ps <= 1'b0;
    else begin
        if (r_ns == DATA)   
             M_ps <= M_cs;
        else 
             M_ps <= M_ps;
    end
end                 

logic [`AXI_LEN_BITS-1:0] ARLEN_r;
logic RVALID_M1_r;

always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn) begin
        M_cs <= 1'b0;       //M0
        ARLEN_r <= 4'd0;
    end
    else begin
        case(r_cs)    
        IDLE : begin
                if(ARVALID_M0 && ARVALID_M1) begin
                   M_cs <= ~M_ps;
                   if (M_ps)
                        ARLEN_r <= ARLEN_M0; 
                   else
                        ARLEN_r <=  ARLEN_M1;
                end
                else if (ARVALID_M1 && ARREADY_S0 || ARVALID_M1 && ARREADY_S1) begin
                   M_cs <= 1'b1;                //M1
                   ARLEN_r <= ARLEN_M1;
                end
                else if  (ARVALID_M0 && ARREADY_S0 || ARVALID_M0 && ARREADY_S1) begin
                   M_cs <= 1'b0;                //M0
                   ARLEN_r <= ARLEN_M0;    
                end
                else begin
                   M_cs <= 1'b0;                //M0
                   ARLEN_r <= ARLEN_M0; 
                end    
            end
        DATA : begin
                 M_cs <= M_cs; 
                 if (ARLEN_r != 4'd0)  begin
                    ARLEN_r <= ARLEN_r - 4'b1 ;
                 end
                 else begin 
                    ARLEN_r <=  ARLEN_r;
                 end   
                end 
        endcase
    end             
end

//************************************************************************//
//slave choose

always_comb
begin
    case(r_cs)
    IDLE : begin
            if(ARVALID_M0 && ARVALID_M1) begin          //both
                if(ARREADY_S0) begin
                    S_sel = 1'b0;
                end
                else if(ARREADY_S1) begin
                    S_sel = 1'b1;
                end
                else begin
                    S_sel = 1'b0;
                end
            end
            else if(ARVALID_M0 && ARREADY_S0) begin     //M0 S0
                S_sel = 1'b0;
            end
            else if(ARVALID_M0 && ARREADY_S1) begin     //M0 S1
                S_sel = 1'b1;
            end
            else if(ARVALID_M1 && ARREADY_S0) begin     //M1 S0
                S_sel = 1'b0;
            end
            else if(ARVALID_M1 && ARREADY_S1) begin     //M1 S1
                S_sel = 1'b1;
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
    if(!ARESETn) 
        S_sel_r <= 1'b0;
    else 
        if (r_cs == IDLE)
        S_sel_r <=  S_sel ;
        else
        S_sel_r <= S_sel_r;
end

//*****************************************************************//
//reg
logic RID_counter;

always_ff @(posedge ACLK or negedge ARESETn)
begin
    if(!ARESETn) begin
        RID_counter <= 1'b0;
    end
    else begin
        if( r_cs == IDLE) begin
	        RID_counter <= 1'b0;
	    end
	    else begin
	        RID_counter <= 1'b1;
	    end
    end
end 



always_ff@(posedge ACLK or negedge ARESETn)begin
    if(!ARESETn) begin
        RVALID_M1_r <= 1'b0;
    end
	else begin
        RVALID_M1_r <= RVALID_M1;
    end
end 


logic [31:0] ARADDR_M1_r;

always_ff @(posedge ACLK or negedge ARESETn)begin
    if(!ARESETn)
    begin
        ARADDR_M1_r <= 32'b0;
    end
	else begin
        if(r_cs == DATA) begin
        	if(RID_counter)
        	    ARADDR_M1_r <= ARADDR_M1_r;
        	else
        	    ARADDR_M1_r <= ARADDR_M1;
        end
        else
        ARADDR_M1_r <= ARADDR_M1;
	end
    
end 

logic [31:0] ARADDR_M1_r2;  //for ~RID_counter 

always_comb 
begin
	if(r_cs == IDLE)
	    ARADDR_M1_r2 = ARADDR_M1;
	else begin
		if(RVALID_M1_r)
		    ARADDR_M1_r2 = ARADDR_M1_r;
		else begin
            if(~RID_counter)
            ARADDR_M1_r2 = ARADDR_M1;
            else
            ARADDR_M1_r2 = ARADDR_M1_r;
		end
	end
end

//*******************************************************************//
//out

always_comb 
begin
    case(r_cs)
    IDLE: begin
            ARREADY_M0 = 1'd0;
            ARREADY_M1 = 1'd0;

            RREADY_S0 = 1'd0;
            RREADY_S1 = 1'd0;

            RID_M0 = 4'd0;
            RDATA_M0 = 32'd0;
            RRESP_M0 = 2'd0;
            RLAST_M0 = 1'd0;
            RVALID_M0 = 1'd0;

            RID_M1 = 4'd0;
            RDATA_M1 = 32'd0;
            RRESP_M1 = 2'd0;
            RLAST_M1 = 1'd0;
            RVALID_M1 = 1'd0;
            ARID_S0 = 8'd0;
            ARADDR_S0 = 32'd0;
            ARLEN_S0 = 4'd0;
            ARSIZE_S0 = 3'd0;
            ARBURST_S0 = 2'd0;
            ARVALID_S0 = 1'd0;
            ARID_S1 = 8'd0;
            ARADDR_S1 = 32'd0;
            ARLEN_S1 = 4'd0;
            ARSIZE_S1 = 3'd0;
            ARBURST_S1 = 2'd0;
            ARVALID_S1 = 1'd0;
        end

    DATA:begin
        if (M_cs == 1'b0)       //M0
        begin
            if(~S_sel) begin
                ARID_S0 = {4'b0,ARID_M0};
                ARADDR_S0 = ARADDR_M0;
                ARLEN_S0 = ARLEN_M0;
                ARSIZE_S0 = ARSIZE_M0;
                ARBURST_S0 = ARBURST_M0;
                ARVALID_S0 = ARVALID_M0;
                ARREADY_M0 = ARREADY_S0;
                
                RID_M0 = RID_S0[3:0];
                RDATA_M0 = RDATA_S0;
                RRESP_M0 = 2'b00;
                if (ARLEN_r == 4'd0) 
                    RLAST_M0 = RLAST_S0;
                else
                    RLAST_M0 = 1'b0;
                RVALID_M0 = RVALID_S0;

                RREADY_S0 = RREADY_M0;

                ARREADY_M1 = 1'd0;
                RID_M1 = 4'd0;
                RDATA_M1 = 32'd0;
                RRESP_M1 = 2'd0;
                RLAST_M1 = 1'd0;
                RVALID_M1 = 1'd0;

                RREADY_S1 = 1'd0;
                ARID_S1 = 8'd0;
                ARADDR_S1 = 32'd0;
                ARLEN_S1 = 4'd0;
                ARSIZE_S1 = 3'd0;
                ARBURST_S1 = 2'd0;
                ARVALID_S1 = 1'd0;                
            end

            else begin
				ARID_S1 = {4'b0,ARID_M0};
                ARADDR_S1 = ARADDR_M0;
                ARLEN_S1 = ARLEN_M0;
                ARSIZE_S1 = ARSIZE_M0;
                ARBURST_S1 = ARBURST_M0;
                ARVALID_S1 = ARVALID_M0;
                ARREADY_M0 = ARREADY_S1;

                RID_M0 = RID_S1[3:0];
                RDATA_M0 = RDATA_S1;
                RRESP_M0 = 2'b00;
                if (ARLEN_r == 4'd0) 
                    RLAST_M0 = RLAST_S1;
                else
                    RLAST_M0 = 1'b0;

                RVALID_M0 = RVALID_S1;
                RREADY_S1 = RREADY_M0;

                ARREADY_M1 = 1'd0;
                RID_M1 = 4'd0;
                RDATA_M1 = 32'd0;
                RRESP_M1 = 2'd0;
                RLAST_M1 = 1'd0;
                RVALID_M1 = 1'd0;

                RREADY_S0 = 1'd0;
                ARID_S0 = 8'd0;
                ARADDR_S0 = 32'd0;
                ARLEN_S0 = 4'd0;
                ARSIZE_S0 = 3'd0;
                ARBURST_S0 = 2'd0;
                ARVALID_S0 = 1'd0;               
            end
        end

        else begin  //M1

            if(~|(ARADDR_M1_r2[31:14])) begin // M1  S0
                ARID_S0 = {4'b0,ARID_M1};
                ARADDR_S0 = ARADDR_M1_r2;
                ARLEN_S0 = ARLEN_M1;
                ARSIZE_S0 = ARSIZE_M1;
                ARBURST_S0 = ARBURST_M1;
                ARVALID_S0 = ARVALID_M1;
                ARREADY_M1 = ARREADY_S0;
                RID_M1 = RID_S0[3:0];
                RDATA_M1 = RDATA_S0;
                RRESP_M1 = 2'b00;
                if (ARLEN_r == 4'd0) 
                    RLAST_M1 = RLAST_S0;
                else
                    RLAST_M1 = 1'b0;
                RVALID_M1 = RVALID_S0;
                RREADY_S0 = RREADY_M1;
                //
                ARREADY_M0 = 1'd0;
                RID_M0 = 4'd0;
                RDATA_M0 = 32'd0;
                RRESP_M0 = 2'd0;
                RLAST_M0 = 1'd0;
                RVALID_M0 = 1'd0;
                RREADY_S1 = 1'd0;
                ARID_S1 = 8'd0;
                ARADDR_S1 = 32'd0;
                ARLEN_S1 = 4'd0;
                ARSIZE_S1 = 3'd0;
                ARBURST_S1 = 2'd0;
                ARVALID_S1 = 1'd0;
                end

                else begin
				ARID_S1 = {4'b0,ARID_M1};
                ARADDR_S1 = ARADDR_M1_r2;
                ARLEN_S1 = ARLEN_M1;
                ARSIZE_S1 = ARSIZE_M1;
                ARBURST_S1 = ARBURST_M1;
                ARVALID_S1 = ARVALID_M1;
                
                ARREADY_M1 = ARREADY_S1;
                ARID_S0 = 8'd0;
                ARADDR_S0 = 32'd0;
                ARLEN_S0 = 4'd0;
                ARSIZE_S0 = 3'd0;
                ARBURST_S0 = 2'd0;
                ARVALID_S0 = 1'd0;
                ARREADY_M0 = 1'd0;
                RID_M0 = 4'd0;
                RDATA_M0 = 32'd0;
                RRESP_M0 = 2'd0;
                RLAST_M0 = 1'd0;
                RVALID_M0 = 1'd0;

                RREADY_S0 = 1'd0;
                
                RID_M1 = RID_S1[3:0];
                RDATA_M1 = RDATA_S1;
                RRESP_M1 = 2'b00;
                if (ARLEN_r == 4'd0) 
                    RLAST_M1 = RLAST_S1;
                else
                    RLAST_M1 = 1'b0;

                RVALID_M1 = RVALID_S1;
                RREADY_S1 = RREADY_M1;
                
                end
            end
        end
    endcase
end

endmodule