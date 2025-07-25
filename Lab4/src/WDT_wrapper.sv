// `include "../../src/WDT/WDT.sv"
// // `include "../../src/CDC/CDC_1bit.sv"
// `include "../../src/CDC/CDC_32bit.sv"

// `include "../../src/WDT/WDT_SlaveRead.sv"
// `include "../../src/WDT/WDT_SlaveWrite.sv"


module WDT_wrapper (
    input clk,
	input rst,
    input clk2,
    input rst2,
    // READ ADDRESS
	input [`AXI_IDS_BITS-1:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
	output ARREADY,
	// READ DATA
	output [`AXI_IDS_BITS-1:0] RID,
	output [`AXI_DATA_BITS-1:0] RDATA,
	output [1:0] RRESP,
	output RLAST,
	output RVALID,
	input RREADY,
    // WRITE ADDRESS
	input [`AXI_IDS_BITS-1:0] AWID,
	input [`AXI_ADDR_BITS-1:0] AWADDR,
	input [`AXI_LEN_BITS-1:0] AWLEN,
	input [`AXI_SIZE_BITS-1:0] AWSIZE,
	input [1:0] AWBURST,
	input AWVALID,
	output AWREADY,
	// WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA,
	input [`AXI_STRB_BITS-1:0] WSTRB,
	input WLAST,
	input WVALID,
	output WREADY,
	// WRITE RESPONSE
	output [`AXI_IDS_BITS-1:0] BID,
	output [1:0] BRESP,
	output BVALID,
	input BREADY,

    output interrupt_t
);

logic WDEN, WDLIVE, WTO;
logic [31:0] WTOCNT;
    
logic [31:0] address_write;

logic WDEN_out,WDLIVE_out,WTO_out;
logic [31:0] WTOCNT_out;

logic [31:0] WTOCNT_reg;
logic [4:0] WTOCNT_counter;
logic [2:0] WTOCNT_en_counter;
logic WTOCNT_en, WTOCNT_en_reg;

logic WDEN_reg;
logic [4:0] WDEN_counter;
logic WDEN_en, WDEN_en_reg;

logic WDLIVE_reg;
logic [4:0] WDLIVE_counter;
logic WDLIVE_en, WDLIVE_en_reg;

assign interrupt_t = WTO_out;
assign WTOCNT_en=(WVALID && AWADDR == 32'h10010300)?1'b1:1'b0;
assign WDLIVE_en=(WDATA != 32'b0 && WVALID && AWADDR == 32'h10010200)?1'b1:1'b0;
assign WDEN_en=(WVALID && AWADDR == 32'h10010100)?1'b1:1'b0;

        


//WTOCNT
always_ff @(posedge clk or posedge rst)
begin
    if(rst)begin
        WTOCNT_counter<=5'b0;
        WTOCNT_reg<=32'b0;
        WTOCNT_en_reg<=1'b0;
    end
    else begin
        if(WTOCNT_en && WTOCNT_counter == 5'b0 && ~WTOCNT_en_reg)begin
            WTOCNT_counter<=WTOCNT_counter+5'b1;
            WTOCNT_reg<=WDATA;
            WTOCNT_en_reg<=WTOCNT_en;
        end
        else begin
            if(WTOCNT_counter == 5'b0) begin
                WTOCNT_counter<=WTOCNT_counter;
                WTOCNT_reg<=WTOCNT_reg;
                WTOCNT_en_reg<=WTOCNT_en_reg;
            end
            else begin
                WTOCNT_counter<=WTOCNT_counter+5'b1;
                WTOCNT_reg<=WTOCNT_reg;
                WTOCNT_en_reg<=WTOCNT_en_reg;
            end
        end
    end
end

//WDEN	
always_ff @(posedge clk or posedge rst)
begin
    if(rst)begin
        WDEN_counter<=5'b0;
        WDEN_reg<=1'b0;
        WDEN_en_reg<=1'b0;
    end
    else begin
        if(WDEN_en)begin
            WDEN_counter<=WDEN_counter+5'b1;
            WDEN_reg<=WDATA[0];
            WDEN_en_reg<=WDEN_en;
        end
        else begin
            if(WDEN_counter == 5'b0) begin
                WDEN_counter<=WDEN_counter;
                WDEN_reg<=WDEN_reg;
                WDEN_en_reg<=WDEN_en_reg;
            end
            else begin
                WDEN_counter<=WDEN_counter+5'b1;
                WDEN_reg<=WDEN_reg;
                WDEN_en_reg<=WDEN_en_reg;
            end
        end
    end
end

//WDLIVE	
always_ff @(posedge clk or posedge rst)
begin
    if(rst)begin
        WDLIVE_counter<=5'b0;
        WDLIVE_reg<=1'b0;
        WDLIVE_en_reg<=1'b0;
    end
    else begin
        if(WDLIVE_en)begin
            WDLIVE_counter<=WDLIVE_counter+5'b1;
            WDLIVE_reg<=WDATA[0];
            WDLIVE_en_reg<=WDLIVE_en;
        end
        else begin
            if(WDLIVE_counter==5'b0) begin
                WDLIVE_counter<=WDLIVE_counter;
                WDLIVE_reg<=WDLIVE_reg;
                WDLIVE_en_reg<=WDLIVE_en_reg;
            end
            else begin
                WDLIVE_counter<=WDLIVE_counter+5'b1;
                WDLIVE_reg<=WDLIVE_reg;
                WDLIVE_en_reg<=WDLIVE_en_reg;
            end
        end
    end
end

//*************************************************************//
WDT_SlaveRead WDT_SlaveRead(
.ACLK(clk), 
.ARESETn(rst),
.ARID(ARID), 
.ARADDR(ARADDR), 
.ARLEN(ARLEN), 
.ARSIZE(ARSIZE), 
.ARBURST(ARBURST), 
.ARVALID(ARVALID), 
.ARREADY(ARREADY),

.RID(RID), 
.RDATA(RDATA), 
.RRESP(RRESP),
.RLAST(RLAST), 
.RVALID(RVALID), 
.RREADY(RREADY),

.A(), 
.DO(32'b0),
.is_reading(),
.select(2'b0)
);

WDT_SlaveWrite SW(
.ACLK(clk), 
.ARESETn(rst),
.AWID(AWID), 
.AWADDR(AWADDR), 
.AWLEN(AWLEN), 
.AWSIZE(AWSIZE), 
.AWBURST(AWBURST), 
.AWVALID(AWVALID), 
.AWREADY(AWREADY),

.WDATA(WDATA), 
.WSTRB(WSTRB), 
.WLAST(WLAST), 
.WVALID(WVALID), 
.WREADY(WREADY),

.BID(BID), 
.BRESP(BRESP), 
.BVALID(BVALID), 
.BREADY(BREADY),

.DI(), 
.A(), 
.BWEB(), 
.isnot_writing(), 
.select(2'b0)
);

//**************************************************************//
//CDC
/*
CDC_1bit CDC_WDEN(
.clk(clk), 
.rst(rst), 
.clk2(clk2), 
.rst2(rst2), 
.data_en_A(WDEN_en_reg), 
.data_bus(WDEN_reg),
.data_out(WDEN_out)
);
*/
/*
CDC_1bit CDC_WDLIVE(
.clk(clk), 
.rst(rst), 
.clk2(clk2), 
.rst2(rst2), 
.data_en_A(WDLIVE_en_reg), 
.data_bus(WDLIVE_reg),
.data_out(WDLIVE_out)
);    
*/

//********************************************//
//WDLIVE
//DFF1_data enable
/*
logic WDEN_wire1;

always_ff @(posedge clk or posedge rst)
begin
    if (rst)
        WDEN_wire1 <= 1'b0;
    else
        WDEN_wire1 <= WDEN_reg;    
end
*/
//DFF2_ data enable
logic WDEN_wire2;       
/*
always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        WDEN_wire2 <= 1'b0;
    else
        WDEN_wire2 <= WDEN_wire1;    
end        
*/
//DFF3_ data enable
//logic WDEN_out;       

always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2) begin
        WDEN_out <= 1'b0;
        WDEN_wire2 <= 1'b0;
    end    
    else begin
        WDEN_wire2 <= WDEN_reg; 
        WDEN_out <= WDEN_wire2;    
    end    
end   

//********************************************//
//WDLIVE
//DFF1_data enable
/*
logic WDLIVE_wire1;

always_ff @(posedge clk or posedge rst)
begin
    if (rst)
        WDLIVE_wire1 <= 1'b0;
    else
        WDLIVE_wire1 <= WDLIVE_reg;    
end
*/
//DFF2_ data enable
logic WDLIVE_wire2;       
/*
always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        WDLIVE_wire2 <= 1'b0;
    else
        WDLIVE_wire2 <= WDLIVE_wire1;    
end        
*/
//DFF3_ data enable
//logic WDLIVE_out;       

always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2) begin
        WDLIVE_wire2 <= 1'b0;
        WDLIVE_out <= 1'b0;
    end    
    else begin
        WDLIVE_wire2 <= WDLIVE_reg; 
        WDLIVE_out <= WDLIVE_wire2;   
    end     
end   

//********************************************//


CDC_32bit CDC_WTOCNT(
.clk(clk), 
.rst(rst), 
.clk2(clk2), 
.rst2(rst2), 
.data_en_A(WTOCNT_en_reg), 
.data_bus_32(WTOCNT_reg),
.data_out(WTOCNT_out)
);    

//**************************************************************//            
WDT WDT(
.clk(clk), 
.rst(rst), 
.clk2(clk2), 
.rst2(rst2), 
.WDEN(WDEN_out), 
.WDLIVE(WDLIVE_out), 
.WTOCNT(WTOCNT_out), 
.WTO(WTO)
);

logic WTO_t;

always_ff @(posedge clk or posedge rst)
begin
    if(rst) begin
        WTO_t <= 1'b0;
        WTO_out <= 1'b0;
    end
    else begin
        WTO_t <= WTO;
        WTO_out <= WTO_t;
    end
end        
        
    
endmodule    