// `include "../include/AXI_define.svh"

module SRAM_SlaveWrite (
    input wire ACLK,
    input wire ARESETn,

    // Write Address Channel
    input wire [`AXI_IDS_BITS-1:0] AWID,
    input wire [`AXI_ADDR_BITS-1:0] AWADDR,
    input wire [`AXI_LEN_BITS-1:0] AWLEN,
    input wire [`AXI_SIZE_BITS-1:0] AWSIZE,
    input wire [1:0] AWBURST,
    input wire AWVALID,
    output reg AWREADY,

    // Write Data Channel
    input wire [`AXI_DATA_BITS-1:0] WDATA,
    input wire [`AXI_STRB_BITS-1:0] WSTRB,
    input wire WLAST,
    input wire WVALID,
    output reg WREADY,

    // Write Response Channel
    output reg [`AXI_IDS_BITS-1:0] BID,
    output reg [1:0] BRESP,
    output reg BVALID,
    input wire BREADY,

    // SRAM 控制信號
    output reg isnot_writing,
    output reg [`AXI_ADDR_BITS-1:0] A,
    output reg [`AXI_DATA_BITS-1:0] DI,
    output reg [`AXI_STRB_BITS-1:0] BWEB, // Byte Write Enable, active low
    input logic [1:0] select
);
    // 狀態機狀態編碼
    typedef enum logic [1:0] {
        ST_IDLE   = 2'd0,
        ST_WRITE  = 2'd1,
        ST_RESP   = 2'd2
    } write_state_t;

    write_state_t state, next_state;
    reg [`AXI_IDS_BITS-1:0] awid_reg;
    reg [`AXI_LEN_BITS-1:0] burst_cnt;
    reg [`AXI_ADDR_BITS-1:0] write_addr;
    reg [2:0] awsize_reg;

    // 狀態機的現態
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn)
            state <= ST_IDLE;
        else
            state <= next_state;
    end

    // 狀態轉移邏輯
    always_comb begin
        next_state = state;
        case (state)
            ST_IDLE  : next_state = (AWVALID && AWREADY) ? ST_WRITE : state;
            ST_WRITE : next_state = (WVALID && WREADY && (/*burst_cnt == 0 */WLAST)) ? ST_RESP : state;
            ST_RESP  : next_state = (BVALID && BREADY) ? ST_IDLE : state;
        endcase
    end

    // 計數器與地址自增邏輯
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) begin
            burst_cnt <= 4'b0;
            write_addr <= 32'b0;
            awsize_reg <= 3'b0;
            awid_reg <= 8'b0;
        end else if (state == ST_IDLE && AWVALID && AWREADY) begin
            burst_cnt <= AWLEN;
            write_addr <= AWADDR;
            awsize_reg <= AWSIZE;
            awid_reg   <= AWID;
        end else if (state == ST_WRITE && WVALID && WREADY) begin
            if (burst_cnt > 4'b0)
                burst_cnt <= burst_cnt - 4'd1;
            /*
            case (AWBURST)
                2'b00: write_addr <= write_addr; // 固定地址
                2'b01: write_addr <= write_addr + (1 << awsize_reg); // 遞增地址
                default: write_addr <= write_addr; // 不支援其他模式
            endcase
            */
            write_addr <= write_addr + (1 << awsize_reg);
        end
    end

    // 輸出邏輯
    always_comb  begin
        
            AWREADY = 1'b0;
            WREADY = 1'b0;
            BID = 8'd0;
            BRESP = 2'b00;
            BVALID = 1'b0;
            DI = 32'd0;
            A = 32'd0;
            BWEB = 4'd0;
            
            isnot_writing = 1'b1;
        
            case (state)
                ST_IDLE: begin
                    AWREADY = (select == 2'd3) ? 1'b0 : 1'b1;
                    WREADY = 1'b0;
                    BID = AWID;
                    BRESP = 2'b00;
                    BVALID = 1'b0;
                    DI = 32'd0;
                    A = 32'd0;
                    BWEB = 4'd0;
                    isnot_writing = 1'b1;
                end
                ST_WRITE: begin
                    AWREADY = 1'b0;
                    WREADY = 1'b1;
                    BID = awid_reg;
                    BRESP = 2'b00;
                    BVALID = 1'b0;
                    DI = WDATA;
                    A = write_addr;
                    BWEB = WSTRB;
                    
                    isnot_writing = 1'b0;
                end
                ST_RESP: begin
                    AWREADY = 1'b0;
                    WREADY = 1'b0;
                    BID = awid_reg;
                    BRESP = 2'b00; // 可以根據實際需求修改
                    BVALID = 1'b1;
                    DI = 32'd0;
                    A = 32'd0;
                    BWEB = 4'd0;
                    isnot_writing = 1'b1;
                end
                default: begin
                    AWREADY = 1'b0;
                    WREADY = 1'b0;
                    BID = 8'd0;
                    BRESP = 2'b00;
                    BVALID = 1'b0;
                    DI = 32'd0;
                    A = 32'd0;
                    BWEB = 4'd0;
                    isnot_writing = 1'b1;
                end
            endcase
        end
    
endmodule
