// `include "../include/AXI_define.svh"

module DMA_Master_Write(
    input ACLK,
    input ARESETn,

    // Write Address Channel
    output logic [`AXI_ID_BITS-1:0] AWID,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR,
    output logic [`AXI_LEN_BITS-1:0] AWLEN,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE,
    output logic [1:0] AWBURST,   // 只支持 INCR 類型
    output logic AWVALID,
    input AWREADY,

    // Write Data Channel
    output logic [`AXI_DATA_BITS-1:0] WDATA,
    output logic [`AXI_STRB_BITS-1:0] WSTRB,
    output logic WLAST,
    output logic WVALID,
    input WREADY,

    // Write Response Channel
    input [`AXI_ID_BITS-1:0] BID,
    input [1:0] BRESP,
    input BVALID,
    output logic BREADY,

    // SRAM 控制信號
    input reg [`AXI_ADDR_BITS-1:0] A,
    input [`AXI_STRB_BITS-1:0] bweb_in,
    input [`AXI_DATA_BITS-1:0] DI,
    input [`AXI_ID_BITS-1:0] id_in,
    input write_signal,
    input logic [`AXI_LEN_BITS-1:0] burst_LEN,
    output logic stall_CPU_W,
    output logic wvalid_out,
    output logic wlast_out
);

    // 狀態機狀態編碼
    typedef enum logic [1:0] {
        ST_IDLE   = 2'd0,
        ST_WAIT   = 2'd1,
        ST_WRITE  = 2'd2,
        ST_RESP   = 2'd3
    } write_state_t;

    write_state_t state, next_state;
    reg [3:0] wdcnt;
    reg [`AXI_ADDR_BITS-1:0] awaddr_reg;
    reg [`AXI_LEN_BITS-1:0] awlen_reg;
    reg [`AXI_ID_BITS-1:0] awid_reg;
    reg awvalid_reg;
    
    reg [`AXI_DATA_BITS-1:0] wdata_reg;
    reg [`AXI_STRB_BITS-1:0] wstrb_reg;
    reg [`AXI_ID_BITS-1:0] bid_reg;

    assign wvalid_out = (next_state == ST_WRITE);
    assign wlast_out = BVALID && BREADY;
    // 狀態機控制
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn)
            state <= ST_IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        case (state)
            ST_IDLE: begin
                next_state = (write_signal) ? ((AWREADY) ? ST_WRITE : ST_WAIT) : state;
            end
            ST_WAIT: next_state = (AWREADY) ? ST_WRITE : state;
            ST_WRITE: next_state = (WVALID && WREADY && WLAST) ? ST_RESP : state;
            ST_RESP: next_state = (BVALID && BREADY) ? ST_IDLE : state;
        endcase
    end


always@(*)begin
    case(state)
    ST_IDLE:begin
        begin
            AWID=4'b0;
            AWADDR=A;
            AWLEN=4'b0;
            AWVALID=write_signal;
            WDATA=32'b0;
            WSTRB=4'b0;
            WVALID=1'b0;
            BREADY=1'b0;

            stall_CPU_W=1'b1;
        end
    end
    ST_WAIT:begin
        AWID=4'b0;
        AWADDR=awaddr_reg;
        AWLEN=4'b0;
        AWVALID=awvalid_reg;
        WDATA=32'b0;
        WSTRB=4'b0;
        WVALID=1'b0;
        BREADY=1'b0;

        stall_CPU_W=1'b1;
    end
    ST_WRITE:begin
        AWID=awid_reg;
        AWADDR=awaddr_reg;
        AWLEN=awlen_reg;
        AWVALID=1'b0;
        WDATA=DI;
        WSTRB=wstrb_reg;
        WVALID=1'b1;
        BREADY=1'b0;

        stall_CPU_W=1'b1;
    end
    ST_RESP:begin
        AWID=awid_reg;
        AWADDR=awaddr_reg;
        AWLEN=awlen_reg;
        AWVALID=1'b0;
        WDATA=32'b0;
        WSTRB=4'b0;
        WVALID=1'b0;
        BREADY=1'b1;
        stall_CPU_W = (next_state!=ST_IDLE);
    end
    endcase
end

    // 寫入計數器
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn)
            wdcnt <= 4'd0;
        else if (state == ST_IDLE)
            wdcnt <= 4'd0;  // 開始時初始化
        else if (WVALID && WREADY && state == ST_WRITE)
            wdcnt <= wdcnt + 4'b1;
    end

    always_ff@(posedge ACLK or posedge ARESETn) begin
	if(ARESETn)begin
		awid_reg<=4'b0;
		awaddr_reg<=32'b0;
		awvalid_reg<=1'b0;
        awlen_reg<=`AXI_LEN_BITS'd0;
        wdata_reg<=32'b0;
        wstrb_reg<=4'b0;
	end
	else begin
		case(state)
		ST_IDLE: begin
			awid_reg<=id_in;
			awaddr_reg<=A;
			awvalid_reg<=write_signal;
            awlen_reg <= burst_LEN;
            wdata_reg<=DI;
            wstrb_reg<=bweb_in;
		end
		default: 
        begin
			awid_reg<=awid_reg;
			awaddr_reg<=awaddr_reg;
			awvalid_reg<=awvalid_reg;
            awlen_reg<=awlen_reg;
            wdata_reg<=wdata_reg;
            wstrb_reg<=wstrb_reg;
		end
		endcase
	end
end


    // assign awid_reg = (state == ST_IDLE) ? id_in : awid_reg;
    // assign awaddr_reg = (state == ST_IDLE) ? A : awaddr_reg;
    // assign awlen_reg = (state == ST_IDLE) ? AWLEN : awlen_reg;
    assign AWSIZE = 3'b010;
    assign AWBURST = 2'b01;
    assign WLAST   = WVALID && (wdcnt==awlen_reg);
    // assign stall_CPU_W = (state != ST_RESP);



endmodule
