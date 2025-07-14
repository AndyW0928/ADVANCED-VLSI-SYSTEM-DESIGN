`include "../include/AXI_define.svh"

module M_WRITE(ACLK, ARESETn, AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID, AWREADY,
WDATA, WSTRB, WLAST, WVALID, WREADY,
BID, BRESP, BVALID, BREADY,
w_en, w_addr, w_data_in, BWEB, w_id, stall
);
    
input logic ACLK, ARESETn;      
    
//WRITE ADDRESS channel M1
output logic [`AXI_ID_BITS-1:0] AWID;
output logic [`AXI_ADDR_BITS-1:0] AWADDR;            //DM_A
output logic [`AXI_LEN_BITS-1:0] AWLEN;
output logic [`AXI_SIZE_BITS-1:0] AWSIZE;
output logic [1:0] AWBURST;
output logic AWVALID;
input logic AWREADY;

//WRITE DATA channel M1
output logic [`AXI_DATA_BITS-1:0] WDATA;             //DM_DI
output logic [`AXI_STRB_BITS-1:0] WSTRB;
output logic WLAST;
output logic WVALID;
input logic WREADY;

//WRITE RESPONSE
input logic [`AXI_ID_BITS-1:0] BID;
input logic [1:0] BRESP;
input logic BVALID;
output logic BREADY; 

//CPU
input logic w_en;
input logic [31:0] w_addr;
input logic [`AXI_DATA_BITS-1:0] w_data_in;
input logic [31:0] BWEB;
input [`AXI_ID_BITS-1:0]  w_id;    
output logic stall;


logic [3:0] strb;
//BWEB to strb
assign strb = (BWEB == 32'hffff_ffff)? 4'b0000 :
            (BWEB == 32'hffff_ff00)? 4'b0001 :
            (BWEB == 32'hffff_00ff)? 4'b0010 :
            (BWEB == 32'hff00_ffff)? 4'b0100 :
            (BWEB == 32'h00ff_ffff)? 4'b1000 :
            (BWEB == 32'hffff_0000)? 4'b0011 :
            (BWEB == 32'h0000_ffff)? 4'b1100 :
            (BWEB == 32'h0000_0000)? 4'b1111 : 4'b0000;
            


localparam WD_IDLE = 2'b00;
localparam WD_ADDR = 2'b01;
localparam WD_DATA = 2'b10;
localparam WD_RESP = 2'b11;

logic [1:0] w_cs, w_ns;
logic w_shake, b_shake;

//reg
logic [3:0] w_id_r;
logic [31:0] w_addr_r;
logic w_en_r;
logic [31:0] w_data_r;
logic [3:0] w_strb_r;
logic [4:0] burstlen_r;
logic [3:0] awlen_r;



assign w_shake = (WVALID & WREADY)? 1'b1 : 1'b0;
assign b_shake = (BVALID & BREADY)? 1'b1 : 1'b0;

//cs
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if (!ARESETn) 
        w_cs <= WD_IDLE;
    else
        w_cs <= w_ns;
end

//ns
always_comb
begin
    case (w_cs)
    WD_IDLE : begin
                if(AWVALID)begin
                    if(AWREADY) 
                    w_ns = WD_DATA;
                    else 
                    w_ns = WD_ADDR;
                end
                else 
                w_ns = WD_IDLE;
            end  

    WD_ADDR : begin 
                if(AWREADY) 
                    w_ns = WD_DATA;
                else 
                    w_ns = WD_ADDR;
            end 

    WD_DATA : begin
            if (WVALID && WREADY && WLAST)
                w_ns = WD_RESP;
            else
                w_ns = WD_DATA;    
            end    

    WD_RESP : begin
                if(BREADY && BVALID)
                w_ns =  WD_IDLE;
                else
                w_ns =  WD_RESP;  
            end
    endcase
end           

//out
always_comb
begin
    case(w_cs)
    WD_IDLE :begin
            AWID = 4'b0;
            AWADDR = w_addr;
            AWLEN = 4'b0;
            AWSIZE = 3'b010;
            AWBURST = 2'b01;
            AWVALID =  w_en;
            WDATA = 32'b0;
            WSTRB = 4'b0;
            WLAST = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b0;
            stall = 1'b1;  
            end  
    WD_ADDR :begin
            AWID = 4'b0;
            AWADDR = w_addr_r;
            AWLEN = 4'b0;
            AWSIZE = 3'b010;
            AWBURST = 2'b01;
            AWVALID =  w_en_r;
            WDATA = 32'b0;
            WSTRB = 4'b0;
            WLAST = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b0;
            stall = 1'b1;  
            end   
    WD_DATA :begin
            AWID = w_id_r;
            AWADDR = w_addr_r;
            AWLEN = awlen_r;
            AWSIZE = 3'b010;
            AWBURST = 2'b01;
            AWVALID =  1'b0;
            WDATA = w_data_r;
            WSTRB = w_strb_r;
            if (burstlen_r == 5'b1)
                WLAST = 1'b1;
            else
                WLAST = 1'b0;
            WVALID = 1'b1;
            BREADY = 1'b0;
            stall = 1'b1;  
            end 
    WD_RESP :begin
            AWID = w_id_r;
            AWADDR = w_addr_r;
            AWLEN = awlen_r;
            AWSIZE = 3'b010;
            AWBURST = 2'b01;
            AWVALID =  1'b0;
            WDATA = 32'b0;
            WSTRB = 4'b0;
            WLAST = 1'b0;
            WVALID = 1'b0;
            BREADY = 1'b1;
            stall = 1'b0;  
            end        
      endcase
end


//reg
always_ff @(posedge ACLK or negedge ARESETn)
begin
    if (!ARESETn) begin
        w_id_r <= 4'b0;
        w_addr_r <= 32'b0;
        w_en_r <= 1'b0;
        w_data_r <= 32'b0;
        w_strb_r <= 4'b0;
        burstlen_r <= 5'b0;
        awlen_r <= 4'b0;
    end
    else begin        
        case (w_cs)
        WD_IDLE : begin
                 w_id_r <= w_id;
                 w_addr_r <= w_addr;
                 w_en_r <= w_en;
                 w_data_r <= w_data_in;
                 w_strb_r <= strb;
                 burstlen_r <= {1'b0, AWLEN} + 5'b1;
                 awlen_r <= AWLEN;
                 end
        WD_ADDR : begin
                 w_id_r <= w_id_r;
                 w_addr_r <= w_addr_r;
                 w_en_r <= w_en_r;
                 w_data_r <= w_data_r;
                 w_strb_r <= w_strb_r;
                 burstlen_r <= burstlen_r;
                 awlen_r <= awlen_r;
                 end
        WD_DATA : begin
                 w_id_r <= w_id_r;
                 w_addr_r <= w_addr_r;
                 w_data_r <= w_data_r;
                 w_strb_r <= w_strb_r;
                 awlen_r <= 4'b0;
                 if (burstlen_r == 5'b1)
                    burstlen_r <= burstlen_r;
                 else
                    burstlen_r <= burstlen_r - 5'b1;
                 end
        default : ;
        endcase
    end
end    
    
endmodule
