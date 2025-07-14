`include "../include/AXI_define.svh"

module S_READ(ACLK, ARESETn, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY, 
RID, RDATA, RRESP, RVALID, RLAST, RREADY,
r_data, r_addr, contr
);

input logic ACLK, ARESETn;
    
//READ ADDRESS
input logic [`AXI_IDS_BITS-1:0] ARID;
input logic [`AXI_ADDR_BITS-1:0] ARADDR;
input logic [`AXI_LEN_BITS-1:0] ARLEN;
input logic [`AXI_SIZE_BITS-1:0] ARSIZE;
input logic [1:0] ARBURST;
input logic ARVALID;
output logic ARREADY;
	
//READ DATA
output logic [`AXI_IDS_BITS-1:0] RID;
output logic [`AXI_DATA_BITS-1:0] RDATA;
output logic [1:0] RRESP;
output logic RLAST;
output logic RVALID;
input logic RREADY;    
    
//SRAM
input logic [31:0] r_data;
output logic [31:0] r_addr;
input logic [1:0] contr;     

localparam RD_IDLE = 2'b00;
localparam RD_ADDR = 2'b01;
localparam RD_DATA = 2'b10;

logic [1:0] r_cs, r_ns, r_ps;
logic r_shake;

logic [`AXI_DATA_BITS-1:0] RDATA_r;
logic [`AXI_LEN_BITS-1:0] ARLEN_r;
logic [`AXI_IDS_BITS-1:0] RID_r;

assign r_shake = (RVALID & RREADY)? 1'b1 : 1'b0;

//ps    //for VIP
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if (ARESETn) 
        r_ps <= RD_IDLE;
    else
        r_ps <= r_cs;
end

//cs 
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if (ARESETn) 
        r_cs <= RD_IDLE;
    else
        r_cs <= r_ns;
end

//ns
always_comb
begin
    case(r_cs)
    RD_IDLE : begin
             if (ARVALID)
                r_ns = (ARREADY)? RD_ADDR : RD_IDLE;
             else
                r_ns = RD_IDLE;
             end
    RD_ADDR : r_ns = RD_DATA;
    RD_DATA : begin
             if (r_shake & RLAST)
                r_ns = RD_IDLE;
            else
                r_ns = RD_DATA;
            end                 
    default : r_ns = RD_IDLE;
    endcase
end                
    
//out
always_comb
begin
    case(r_cs)
    RD_IDLE : begin
             RID = ARID; 
             RDATA = 32'b0;
             RRESP = 2'b0;
             RLAST = 1'b0;
             RVALID = 1'b0;            
             ARREADY = (contr == 2'b11)? 1'b0 : 1'b1;
             r_addr = 32'b0;
             end
    RD_ADDR : begin
             RID = RID_r;         
             RDATA = 32'b0;
             RRESP = 2'b0;
             RLAST = 1'b0;
             RVALID = 1'b0;            
             ARREADY = 1'b0;
             r_addr = ARADDR;
             end
    RD_DATA : begin
             RVALID = 1'b1;
             if (r_shake) begin
                r_addr = 32'b0;
                RID = RID_r; 
                RDATA = (r_ps == RD_ADDR)? r_data : RDATA_r;
                RRESP = 2'b0;
                RLAST = (ARLEN_r == 4'b1)? 1'b1 : 1'b0;
                ARREADY = 1'b0;
             end
             else begin
                r_addr = 32'b0;
                RID = RID_r; 
                RDATA = (r_ps == RD_ADDR)? r_data : RDATA_r;
                RRESP = 2'b0;
                if (ARLEN_r == 4'b1)begin
                    if (RVALID)
                        RLAST =  1'b1;
                    else
                        RLAST =  1'b0; 
                end
                else begin
                    RLAST =  1'b0;
                end
                ARREADY = 1'b0;        
             end
             end
    default : begin
             RID = 8'b0;         
             RDATA = 32'b0;
             RRESP = 2'b0;
             RLAST = 1'b0;
             RVALID = 1'b0;            
             ARREADY = 1'b0;
             r_addr = 32'b0;
             end
    endcase
end

//reg
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if(ARESETn) begin
        RDATA_r <= 32'b0;
        ARLEN_r <= 4'b0;
        RID_r <= 8'b0;
    end
    else begin
        case (r_cs)
        RD_IDLE : begin
                RDATA_r <= 32'b0;
                ARLEN_r <= ARLEN + 4'b1;
                RID_r <= ARID;
                end
        RD_ADDR : begin
                RDATA_r <= 32'b0;
                ARLEN_r <= ARLEN_r;
                RID_r <= RID_r;
                end
        RD_DATA : begin
                RID_r <= RID_r;
                if(r_shake)begin
                   RDATA_r <= (r_ps == RD_ADDR)? r_data : RDATA_r;
                   ARLEN_r <= (ARLEN_r == 4'b1)? ARLEN_r : (ARLEN_r - 4'b1);  
                end
                else begin
                   RDATA_r <= (r_ps == RD_ADDR)? r_data : RDATA_r;
                   ARLEN_r <= ARLEN_r;
                end
                end
         default : ;
         endcase
     end
end                                            
                           
             
    
endmodule
