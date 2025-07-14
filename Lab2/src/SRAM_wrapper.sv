`include "../include/AXI_define.svh"
`include "S_READ.sv"
`include "S_WRITE.sv"

module SRAM_wrapper (
  input ACLK,
  input ARESETn, 
  
//WRITE ADDRESS
	input logic [`AXI_IDS_BITS-1:0] AWID_S,
	input logic [`AXI_ADDR_BITS-1:0] AWADDR_S,
	input logic [`AXI_LEN_BITS-1:0] AWLEN_S,
	input logic [`AXI_SIZE_BITS-1:0] AWSIZE_S,
	input logic [1:0] AWBURST_S,
	input logic AWVALID_S,
	output logic AWREADY_S,
	
//WRITE DATA
	input logic [`AXI_DATA_BITS-1:0] WDATA_S,
	input logic [`AXI_STRB_BITS-1:0] WSTRB_S,
	input logic WLAST_S,
	input logic WVALID_S,
	output logic WREADY_S,
	
//WRITE RESPONSE
	output logic [`AXI_IDS_BITS-1:0] BID_S,
	output logic [1:0] BRESP_S,
	output logic BVALID_S,
	input logic BREADY_S,
	
//READ ADDRESS
    input logic [`AXI_IDS_BITS-1:0] ARID_S,
    input logic [`AXI_ADDR_BITS-1:0] ARADDR_S,
    input logic [`AXI_LEN_BITS-1:0] ARLEN_S,
    input logic [`AXI_SIZE_BITS-1:0] ARSIZE_S,
    input logic [1:0] ARBURST_S,
    input logic ARVALID_S,
    output logic ARREADY_S,
	
//READ DATA
    output logic [`AXI_IDS_BITS-1:0] RID_S,
    output logic [`AXI_DATA_BITS-1:0] RDATA_S,
    output logic [1:0] RRESP_S,
    output logic RLAST_S,
    output logic RVALID_S,
    input logic RREADY_S
);

logic CEB;
logic WEB;
logic [31:0] BWEB;
logic [13:0] A;
logic [31:0] DI;
logic [31:0] DO;

logic [31:0] r_addr, w_addr;
logic [31:0] r_data, w_data;
logic [1:0] contr, contr_r;
logic [3:0] w_en_out_M;
logic [31:0] bweb_r;
logic isnot_FREE;

  TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
    .SLP(1'b0),
    .DSLP(1'b0),
    .SD(1'b0),
    .PUDELAY(),
    .CLK(ACLK),
	  .CEB(CEB),
	  .WEB(WEB),
    .A(A),
	  .D(DI),
    .BWEB(BWEB),
    .RTSEL(2'b01),
    .WTSEL(2'b01),
    .Q(DO)
);

S_READ SR(
.ACLK(ACLK), 
.ARESETn(~ARESETn), 
.ARID(ARID_S), 
.ARADDR(ARADDR_S), 
.ARLEN(ARLEN_S), 
.ARSIZE(ARSIZE_S), 
.ARBURST(ARBURST_S), 
.ARVALID(ARVALID_S), 
.ARREADY(ARREADY_S), 
.RID(RID_S), 
.RDATA(RDATA_S), 
.RRESP(RRESP_S), 
.RVALID(RVALID_S), 
.RLAST(RLAST_S), 
.RREADY(RREADY_S),
.r_data(DO), 
.r_addr(r_addr), 
.contr(contr)
);

S_WRITE SW(
.ACLK(ACLK), 
.ARESETn(~ARESETn), 
.AWID(AWID_S), 
.AWADDR(AWADDR_S), 
.AWLEN(AWLEN_S), 
.AWSIZE(AWSIZE_S), 
.AWBURST(AWBURST_S), 
.AWVALID(AWVALID_S), 
.AWREADY(AWREADY_S),
.WDATA(WDATA_S), 
.WSTRB(WSTRB_S), 
.WLAST(WLAST_S), 
.WVALID(WVALID_S), 
.WREADY(WREADY_S), 
.BID(BID_S), 
.BRESP(BRESP_S), 
.BVALID(BVALID_S), 
.BREADY(BREADY_S),
.w_addr(w_addr), 
.w_data(w_data), 
.w_en_out(w_en_out_M), 
.contr(contr),
.state(isnot_FREE)
);


logic [1:0] select;
logic [1:0] select_reg;
 
//sram state
logic sram_cs, sram_ns;
localparam IDLE = 1'b0;
localparam BUSY = 1'b1;

//control signal read/write
localparam ABLE =2'b00;         //available
localparam READ = 2'b01;
localparam WRITE = 2'b10;
localparam ERROR = 2'b11;        //both write and read

//cs
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if (ARESETn) 
        sram_cs <= IDLE;
    else
        sram_cs <= sram_ns;
end

//ns
always_comb
begin
    case(sram_cs)
    IDLE : sram_ns = (AWVALID_S || ARVALID_S)? BUSY : IDLE;
    BUSY : sram_ns = (WLAST_S || RLAST_S)? IDLE : BUSY;
    endcase
end

//out
always_comb
begin
    case(sram_cs)
    IDLE : begin
          if (AWVALID_S)
            contr = (~ARVALID_S)? WRITE : ERROR;
          else if (ARVALID_S)
            contr = (~AWVALID_S)? READ : ERROR;
          else 
            contr = ABLE;
		end
    BUSY : contr = contr_r;   
    endcase
end

//reg
always_ff @(posedge ACLK or posedge ARESETn)
begin
    if (ARESETn) 
        contr_r <= 2'b00;
    else begin
        case(sram_cs)
        IDLE : contr_r <= contr;
        BUSY : contr_r <= contr_r;
        endcase
    end    
end        



assign bweb_r = {{8{~w_en_out_M[3]}},{8{~w_en_out_M[2]}},{8{~w_en_out_M[1]}},{8{~w_en_out_M[0]}}};
assign CEB = 1'b0; 
assign WEB = (isnot_FREE)? 1'b0 : 1'b1;					//isnot_FREE = WRITE
assign BWEB = (isnot_FREE)? bweb_r : 32'hffff_ffff;		//isnot_FREE = WRITE
assign A=(isnot_FREE)? w_addr[13:0] : r_addr[13:0];
assign DI = w_data;

//assign r_data = DO;
//assign A = (contr == READ)? r_addr[15:2] : (contr == WRITE)? w_addr[15:2] : 14'b0;


endmodule
