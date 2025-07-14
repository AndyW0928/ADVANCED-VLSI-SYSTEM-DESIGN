// `include "../include/AXI_define.svh"

module WDT_SlaveRead(

	input ACLK,
	input ARESETn,

	//READ ADDRESS
	input [`AXI_IDS_BITS-1:0] ARID,
	input [`AXI_ADDR_BITS-1:0] ARADDR,
	input [`AXI_LEN_BITS-1:0] ARLEN,
	input [`AXI_SIZE_BITS-1:0] ARSIZE,
	input [1:0] ARBURST,
	input ARVALID,
	output logic ARREADY,
	
	//READ DATA
	output logic [`AXI_IDS_BITS-1:0] RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0] RRESP,
	output logic RLAST,
	output logic RVALID,
	input RREADY,

    // SRAM 控制信號
    output reg is_reading, // 1 表示正在讀取
    output reg [`AXI_ADDR_BITS-1:0] A, // SRAM 地址
    input logic [`AXI_DATA_BITS-1:0] DO, // SRAM 輸出數據
    input logic[1:0] select
	
);

    // 狀態機狀態編碼
    typedef enum logic [1:0] {
        ST_IDLE   = 2'd0,
        ST_WAIT   = 2'd1,
        ST_READ   = 2'd2
    } read_state_t;

read_state_t state, next_state ,re_state;

reg     [31:0] araddr_reg;
reg     [3:0]  rdcnt;
reg     [3:0]  arlen_reg;
reg     [`AXI_IDS_BITS-1:0]  arid_reg;
logic [31:0] RDATA_reg;
logic [7:0] RID_reg;




always@(posedge ACLK or posedge ARESETn) begin
    if (ARESETn) begin
        state <= ST_IDLE;
    end else begin
        state <= next_state;
    end
end

always@(posedge ACLK or posedge ARESETn) begin
    if (ARESETn) begin
        re_state <= ST_IDLE;
    end else begin
        re_state <= state;
    end
end


always@(*) begin
    next_state = state;
    case (state)
        ST_IDLE : next_state = (ARREADY & ARVALID) ? ST_WAIT : state;
        ST_WAIT : next_state = ST_READ;
        ST_READ : next_state = (RVALID & RREADY & RLAST) ? ST_IDLE : state;
    endcase
end
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) 
            rdcnt <= 4'd0;
        else if (state == ST_WAIT) 
            rdcnt <= 4'd0;  // Initialize count at start of transfer
        else if (RVALID && RREADY && state == ST_READ)
            rdcnt <= rdcnt + 4'b1;
    end

always@(*)begin
    case(state)
    ST_IDLE:begin
        A=32'b0;
        // RID_reg=ARID;
        RID=8'b0;
        // arlen_reg  = ARLEN;
        RDATA=32'b0;
        RRESP=2'b00;
        RVALID=1'b0;
		ARREADY = (select == 2'd3) ? 1'b0 : 1'b1;
        RLAST=1'b0;
    end
    ST_WAIT:begin
        A=ARADDR;
        RID=RID_reg;
        RDATA=32'b0;
        RRESP=2'b00;
        RVALID=1'b0;
        ARREADY=1'b0;
        RLAST=1'b0;
    end
    ST_READ:begin	
		A=32'b0;
		RID=RID_reg;
		RRESP=2'b00;
		ARREADY=1'b0;
        RVALID=1'b1;
        RDATA   = (re_state == ST_WAIT)? DO : RDATA_reg; 
        RLAST   = RVALID && (rdcnt==arlen_reg);           
	end	
    default: begin
	    A=32'b0;
        RID=8'b0;
        RDATA=32'b0;
        RRESP=2'b00;
        RVALID=1'b0;
        ARREADY=1'b0;
        RLAST=1'b0;
        // RID_reg =8'b0;
    end
    endcase
end


// assign RID_reg   = (state == ST_IDLE)? ARID : 8'b0;
// assign arlen_reg   = (state == ST_IDLE)? ARLEN : 4'b0;
// assign RLAST   = RVALID && (rdcnt==arlen_reg);
// assign RDATA_reg   = (re_state == ST_WAIT)? DO : RDATA_reg;

        // 輸出邏輯
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) begin
            RID_reg <=8'b0;
            arlen_reg <=4'b0;
            RDATA_reg <=32'b0;
        end
        else begin
        case (state)
            ST_IDLE: begin
                RID_reg <=ARID;
                arlen_reg <=ARLEN;
                RDATA_reg <=32'b0;
            end
            ST_WAIT: begin
                RID_reg <=RID_reg;
                arlen_reg <=arlen_reg;
                RDATA_reg <=32'b0;
            end
            ST_READ: begin
                RID_reg <=RID_reg;
                arlen_reg <=arlen_reg;
                // RDATA_reg <=AWID;
                RDATA_reg   <= (re_state == ST_WAIT)? DO : RDATA_reg;
            end
            default: begin
                RID_reg <=8'b0;
                arlen_reg <=4'b0;
                RDATA_reg <=32'b0;
            end
        endcase
        end
    end
assign is_reading = (state == ST_READ) ||(state==ST_WAIT);

endmodule

