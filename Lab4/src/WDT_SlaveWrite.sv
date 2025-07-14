// `include "../include/AXI_define.svh"

module WDT_SlaveWrite (
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
    // logic [7:0] B1,B2,B3,B4;

    // assign isnot_writing = (state == ST_WRITE);
    // assign isnot_writing=state[0];
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
            ST_IDLE  : next_state = (AWVALID) ? ST_WRITE : state;
            ST_WRITE : next_state = (WVALID & WREADY & WLAST) ? ST_RESP : state;
            ST_RESP  : next_state = (BVALID & BREADY) ? ST_IDLE : state;
        endcase
    end

    // 輸出邏輯
    always @(*) begin
        case (state)
            ST_IDLE: begin
                AWREADY = (select == 2'd3) ? 1'b0 : 1'b1;
                WREADY = 1'b0;
                BID = AWID;
                BRESP = 2'b00;
                BVALID = 1'b0;
                DI = 32'b0;
                A = 32'b0;
                BWEB = 4'd0;
                // isnot_writing=1'b1;
            end
            ST_WRITE: begin
                AWREADY = 1'b1;
                WREADY = 1'b1;
                BID = awid_reg;
                BRESP = 2'b00;
                BVALID = 1'b0;
                DI = WDATA;
                A = AWADDR;
                BWEB = WSTRB;
                // isnot_writing=1'b0;
            end
            ST_RESP: begin
                AWREADY = 1'b1;
                WREADY = 1'b1;
                BID = awid_reg;
                BRESP = 2'b00;
                BVALID = 1'b1;
                DI = 32'b0;
                A = 32'b0;
                BWEB = 4'd0;
                // isnot_writing=1'b1;
            end
            default: begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'b0;
                BRESP = 2'b0;
                BVALID = 1'b0;
                DI = 32'b0;
                A = 32'b0;
                BWEB = 4'd0;
                // isnot_writing=1'b1;
            end
        endcase
    end

    // assign awid_reg = (state == ST_IDLE) ? AWID : awid_reg;
        // 輸出邏輯
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) begin
            isnot_writing <= 1'd0;
        end
        else if(next_state == ST_WRITE) begin
            isnot_writing<=1'b0;
        end
        else begin
            isnot_writing<=1'b1;
        end

    end
  
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) begin
            awid_reg <= 8'd0;
        end
        else begin
        case (state)
            ST_IDLE: begin
                awid_reg <=AWID;
            end
            ST_WRITE: begin
                awid_reg <=awid_reg;
            end
            ST_RESP: begin
                awid_reg <=awid_reg;
            end
            default: begin
                awid_reg <=awid_reg;
            end
        endcase
        end
    end

endmodule
