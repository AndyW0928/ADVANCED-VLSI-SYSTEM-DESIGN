`include "../include/AXI_define.svh"

module S_WRITE(ACLK, ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY,
WDATA, WSTRB, WLAST, WVALID, WREADY, 
BID, BRESP, BVALID, BREADY,
w_addr, w_data, w_en_out, contr, state
);
    
input logic ACLK, ARESETn;       
    
//WRITE ADDRESS
input logic [`AXI_IDS_BITS-1:0] AWID;
input logic [`AXI_ADDR_BITS-1:0] AWADDR;
input logic [`AXI_LEN_BITS-1:0] AWLEN;
input logic [`AXI_SIZE_BITS-1:0] AWSIZE;
input logic [1:0] AWBURST;
input logic AWVALID;
output logic AWREADY;
	
//WRITE DATA
input logic [`AXI_DATA_BITS-1:0] WDATA;
input logic [`AXI_STRB_BITS-1:0] WSTRB;
input logic WLAST;
input logic WVALID;
output logic WREADY;
	
//WRITE RESPONSE
output logic [`AXI_IDS_BITS-1:0] BID;
output logic [1:0] BRESP;
output logic BVALID;
input logic BREADY;
    
//SRAM
input logic [1:0] contr;
output logic [`AXI_ADDR_BITS-1:0] w_addr;
output logic [`AXI_DATA_BITS-1:0] w_data;
output logic [3:0] w_en_out;

output logic state;
     

localparam WD_IDLE = 2'b00;
localparam WD_TRAN = 2'b01;
localparam WD_RESP = 2'b10;

logic [1:0] w_cs, w_ns;
logic w_shake, b_shake;
logic [`AXI_IDS_BITS-1:0] BID_r;



assign state =  w_cs[0];

assign w_shake = (WVALID & WREADY)? 1'b1 : 1'b0;
assign b_shake = (BVALID & BREADY)? 1'b1 : 1'b0;

//cs
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if (ARESETn) 
        w_cs <= WD_IDLE;
    else
        w_cs <= w_ns;
end
 
//ns
always_comb
begin
    case (w_cs)
    WD_IDLE : begin
            if(AWVALID)
            w_ns =  WD_TRAN; 
            else
            w_ns =  WD_IDLE;  
            end

    WD_TRAN : begin
            if (WLAST && WVALID && WREADY)
                w_ns = WD_RESP;
            else
                w_ns = WD_TRAN;    
            end    

    WD_RESP : begin
            if (BREADY && BVALID)
                w_ns = WD_IDLE ;
            else
                w_ns = WD_RESP;
            end      
            
    default :  w_ns =   WD_IDLE;
    endcase
end          
    
//out
always_comb
begin
    case (w_cs)
    WD_IDLE : begin
             AWREADY = (contr == 2'b11)? 1'b0 : 1'b1;
             WREADY = 1'b0;
             BID = AWID;
             BRESP = 2'b0;
             BVALID = 1'b0;
             w_addr = 32'b0;
             w_data = 32'b0;
             w_en_out = 4'b0;
             end
    WD_TRAN : begin
             AWREADY = 1'b1;
             WREADY = 1'b1;
             BID = BID_r;
             BRESP = 2'b0;
             BVALID = 1'b0;
             w_addr = AWADDR;
             w_data = WDATA;
             w_en_out = WSTRB;
             end         
    WD_RESP : begin
             AWREADY = 1'b1;
             WREADY = 1'b1;
             BID = BID_r;
             BRESP = 2'b0;
             BVALID = 1'b1;
             w_addr = 32'b0;
             w_data = 32'b0;
             w_en_out = 4'b0;
             end         
     default : begin
             AWREADY = 1'b1;
             WREADY = 1'b1;
             BID = 8'b0;
             BRESP = 2'b0;
             BVALID = 1'b0;
             w_addr = 32'b0;
             w_data = 32'b0;
             w_en_out = 4'b0;
             end
     endcase                  
end

//reg
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if(ARESETn) begin
        BID_r <= 8'b0;
    end
    else begin
        case (w_cs)
        WD_IDLE : BID_r <= AWID;
        WD_TRAN : BID_r <= BID_r;
        WD_RESP : BID_r <= BID_r;
        default : BID_r <= BID_r;
        endcase
    end
end

//assign w_BWEB = {{8{~w_strb[3]}},{8{~w_strb[2]}},{8{~w_strb[1]}},{8{~w_strb[0]}}};
                 
endmodule

