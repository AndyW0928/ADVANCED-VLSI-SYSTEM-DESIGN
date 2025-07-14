`include "../include/AXI_define.svh"

module M_READ(ACLK, ARESETn, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID, ARREADY,
RID, RDATA, RRESP, RLAST, RVALID, RREADY, 
r_en, r_addr, r_id, r_data_out, stall, rvalid_out
);

input logic ACLK, ARESETn;  
 
  
//READ ADDRESS     
output logic [`AXI_ID_BITS-1:0] ARID;
output logic [`AXI_ADDR_BITS-1:0] ARADDR;           
output logic [`AXI_LEN_BITS-1:0] ARLEN;
output logic [`AXI_SIZE_BITS-1:0] ARSIZE;
output logic [1:0] ARBURST;
output logic ARVALID;
input logic ARREADY;

//READ DATA  
input logic [`AXI_ID_BITS-1:0] RID;
input logic [`AXI_DATA_BITS-1:0] RDATA;            
input logic [1:0] RRESP;
input logic RLAST;
input logic RVALID;
output logic RREADY; 

//CPU
input logic r_en;
input logic [31:0] r_addr;
input logic [`AXI_ID_BITS-1:0] r_id;
output logic [31:0] r_data_out;
output logic stall, rvalid_out;

assign rvalid_out = RVALID;		//for read_DM

localparam RD_IDLE = 2'b00;
localparam RD_ADDR = 2'b01;    
localparam RD_DATA = 2'b10;

logic [1:0] r_cs, r_ns;
logic r_shake;

//reg
logic [31:0] r_addr_r;
logic r_en_r;
logic [3:0] r_id_r;

assign r_shake = (RVALID & RREADY)? 1'b1 : 1'b0;

//cs
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if (!ARESETn) 
        r_cs <= RD_IDLE;
    else
        r_cs <= r_ns;
end

//ns
always_comb 
begin
    case (r_cs)
    RD_IDLE : begin
				if(ARVALID)begin
					if(ARREADY) 
					r_ns = RD_DATA;
					else 
					r_ns = RD_ADDR;
				end
				else begin
					r_ns = RD_IDLE;
				end
			end
                            
    RD_ADDR : r_ns = (ARREADY)? RD_DATA : RD_ADDR;      

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
    case (r_cs)
    RD_IDLE : begin
            ARID = 4'b0;
            ARADDR = r_addr;
            ARLEN = 4'b0;
            ARSIZE = 3'b010;
            ARBURST = 2'b01;
            ARVALID = r_en;
            RREADY = 1'b0;
            r_data_out = RDATA;
            stall = (r_en)? 1'b1 : 1'b0;
            end   

    RD_ADDR : begin
            ARID = 4'b0;
            ARADDR = r_addr_r;
            ARLEN = 4'b0;
            ARSIZE = 3'b010;
            ARBURST = 2'b01;
            ARVALID = r_en_r;
            RREADY = 1'b0;
            r_data_out = RDATA;
            stall = 1'b1;
            end           

    RD_DATA : begin
            ARID = r_id_r;
            ARADDR = r_addr_r;
            ARLEN = 4'b0;
            ARSIZE = 3'b010;
            ARBURST = 2'b01;
            ARVALID = 1'b0;
            RREADY = 1'b1;
            r_data_out = RDATA;
            stall = (RLAST)? 1'b0: 1'b1;
            end   
			
    default : begin
            ARID = 4'b0;
            ARADDR = 32'b0;
            ARLEN = 4'b0;
            ARSIZE = 3'b010;
            ARBURST = 2'b01;
            ARVALID = 1'b0;
            RREADY = 1'b0;
            r_data_out = 32'b0;
            stall = 1'b0;
            end
     endcase
end

//read reg
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if (!ARESETn) begin
        r_addr_r <= 32'b0;
        r_en_r <= 1'b0;
        r_id_r <= 4'b0;
    end
    else begin
        case (r_cs)
        RD_IDLE : begin
                 r_addr_r <= r_addr;
                 r_en_r <= r_en;    
                 r_id_r <= r_id;
                 end
        RD_ADDR : ;
        RD_DATA : ;
        default : ;
        endcase
    end
end                 
                   
       
    
    
endmodule
