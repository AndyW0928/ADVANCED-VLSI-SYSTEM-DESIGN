// `include "../include/AXI_define.svh"

module SRAM_SlaveRead(

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

    read_state_t state, next_state;

    reg [3:0]  rdcnt;
    reg [3:0]  arlen_reg;
    reg [31:0] araddr_reg;
    reg [`AXI_IDS_BITS-1:0] arid_reg;
    reg [2:0] arsize_reg;

    // 狀態遷移邏輯
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) begin
            state <= ST_IDLE;
            rdcnt <= 4'd0;
            araddr_reg <= 32'b0;
            arlen_reg <= 4'b0;
            arsize_reg <= 3'b0;
        end else begin
            state <= next_state;

            if (state == ST_READ && RVALID && RREADY) begin
                rdcnt <= rdcnt + 4'd1;
                if (rdcnt < arlen_reg) begin
                    araddr_reg <= araddr_reg + (32'd1 << arsize_reg);
                end
            end else if (state == ST_IDLE) begin
                rdcnt <= 4'd0;
            end

            if (state == ST_IDLE) begin
                araddr_reg <= ARADDR;
                arlen_reg <= ARLEN;
                arsize_reg <= ARSIZE;
            end
        end
    end

    // 下一狀態邏輯
    always_comb begin
        next_state = state;
        case (state)
            ST_IDLE: begin
                if (ARVALID && ARREADY) begin
                    next_state = ST_WAIT;
                end
            end
            ST_WAIT: begin
                next_state = ST_READ; // SRAM 延遲 1 cycle
            end
            ST_READ: begin
                if (RVALID && RREADY && RLAST) begin
                    next_state = ST_IDLE;
                end
            end
        endcase
    end

    // 輸出邏輯
    always_comb begin
        case (state)
            ST_IDLE: begin
                ARREADY = (select != 2'd3);
                RVALID  = 1'b0;
                RLAST   = 1'b0;
                RDATA   = 32'b0;
                A       = 32'b0;
                is_reading = 1'b0;
            end
            ST_WAIT: begin
                ARREADY = 1'b0;
                RVALID  = 1'b0;
                RLAST   = 1'b0;
                RDATA   = 32'b0;
                A       = araddr_reg; // 設定 SRAM 地址
                is_reading = 1'b1;
            end
            ST_READ: begin
                ARREADY = 1'b0;
                RVALID  = 1'b1;
                RLAST   = (rdcnt == arlen_reg);
                RDATA   = DO; // SRAM 輸出數據
                A       = araddr_reg + 32'd4; // SRAM 地址自動遞增
                is_reading = 1'b1;
            end
            default: begin
                ARREADY = 1'b0;
                RVALID  = 1'b0;
                RLAST   = 1'b0;
                RDATA   = 32'b0;
                A       = 32'b0;
                is_reading = 1'b0;
            end
        endcase
    end

endmodule
