// `include "../include/AXI_define.svh"
// `include "../../src/SRAM/SRAM_SlaveRead.sv"
// `include "../../src/SRAM/SRAM_SlaveWrite.sv"
// `include "../../src/SRAM/Slave_Selection.sv"
// `include "src/SRAM/SRAM_SlaveRead.sv"
// `include "src/SRAM/SRAM_SlaveWrite.sv"
// `include "src/SRAM/Slave_Selection.sv"
module SRAM_wrapper (
  input ACLK,
  input ARESETn,
  
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
  input BREADY
);

// BWEB 生成函數
function [31:0] gen_bweb(input [3:0] WSTRB);
    integer i;
    begin
        gen_bweb = 32'hFFFFFFFF; // 默認為不寫入 (全部 FF)
        for (i = 0; i < 4; i = i + 1) begin
            if (WSTRB[i])
                gen_bweb[i*8 +: 8] = 8'h00; // 如果 WSTRB[i] 是 1，設為 00
            else
                gen_bweb[i*8 +: 8] = 8'hFF; // 如果 WSTRB[i] 是 0，設為 FF
        end
    end
endfunction


  // SRAM控制信號
  logic sram_web;
  logic [31:0] sram_bweb;
  logic [`AXI_ADDR_BITS-1:0] sram_read_addr, sram_write_addr;
  logic [`AXI_DATA_BITS-1:0] sram_di, sram_do;

  logic CLK;
  logic RST;
  logic CEB;
  logic WEB;
  logic [3:0] bweb_r;
  logic [13:0] A;
  logic [31:0] DI,DI_out;
  logic [31:0] DO_out;


logic [31:0] bweb;
// logic isnot_writing;
// logic [1:0] select;

logic state;
  logic next_state;
  logic [1:0] select_reg;
  logic [1:0] select;

Slave_Selection Slave_Selection (
    .ACLK(ACLK),
    .ARESETn(ARESETn),
    .ARVALID(ARVALID),
    .AWVALID(AWVALID),
    .RLAST(RLAST),
    .WLAST(WLAST),
    .selection(select)
);



SRAM_SlaveRead SRAM_SlaveRead(.ACLK(ACLK), .ARESETn(ARESETn),
            .ARID(ARID), .ARADDR(ARADDR), .ARLEN(ARLEN), .ARSIZE(ARSIZE), 
            .ARBURST(ARBURST), .ARVALID(ARVALID), .ARREADY(ARREADY),

            .RID(RID), .RDATA(RDATA), .RRESP(RRESP),
            .RLAST(RLAST), .RVALID(RVALID), .RREADY(RREADY),

            .A(sram_read_addr), .DO(DO_out),.is_reading(), .select(select)
            );


SRAM_SlaveWrite SRAM_SlaveWrite(.ACLK(ACLK), .ARESETn(ARESETn),
            .AWID(AWID), .AWADDR(AWADDR), .AWLEN(AWLEN), .AWSIZE(AWSIZE), 
            .AWBURST(AWBURST), .AWVALID(AWVALID), .AWREADY(AWREADY),

            .WDATA(WDATA), .WSTRB(WSTRB), .WLAST(WLAST), .WVALID(WVALID), .WREADY(WREADY),

            .BID(BID), .BRESP(BRESP), .BVALID(BVALID), .BREADY(BREADY),

            .A(sram_write_addr), .DI(DI_out), .BWEB(bweb_r),.isnot_writing(isnot_writing), .select(select)
            );

assign CLK = ACLK;
assign CEB = 1'b0;//恆0
assign bweb = {{8{~bweb_r[3]}},{8{~bweb_r[2]}},{8{~bweb_r[1]}},{8{~bweb_r[0]}}};
// assign BWEB = (isnot_writing)? bweb_r : 32'hffff_ffff;
assign A=(isnot_writing)?sram_read_addr[15:2]:sram_write_addr[15:2];
assign WEB=isnot_writing;
// assign WEB = (isnot_writing)? 1'b0 : 1'b1;	
assign DI = DI_out;
// assign DO_out = DO;
  // SRAM模組實例化
  TS1N16ADFPCLLLVTA512X45M4SWSHOD i_SRAM (
    .SLP(1'b0),
    .DSLP(1'b0),
    .SD(1'b0),
    .PUDELAY(),
    .CLK(CLK),
	  .CEB(CEB),
	  .WEB(WEB),
    .A(A),
	  .D(DI),
    .BWEB(bweb/*gen_bweb(bweb_r)*/),
    .RTSEL(2'b01),
    .WTSEL(2'b01),
    .Q(DO_out)
);

endmodule
