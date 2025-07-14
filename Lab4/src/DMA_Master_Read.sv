// `include "../include/AXI_define.svh"

module DMA_Master_Read(
    input ACLK,
    input ARESETn,

    // READ ADDRESS
    output logic [`AXI_ID_BITS-1:0] ARID,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR,
    output logic [`AXI_LEN_BITS-1:0] ARLEN,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE,
    output logic [1:0] ARBURST,
    output logic ARVALID,
    input ARREADY,

    // READ DATA
    input  [`AXI_ID_BITS-1:0] RID,
    input  [`AXI_DATA_BITS-1:0] RDATA,
    input  [1:0] RRESP,
    input  RLAST,
    input  RVALID,
    output logic RREADY,

    // SRAM 控制信號
	input [`AXI_ID_BITS-1:0] id_in,
    input reg read_signal,                    // 1 表示啟動讀取
    input reg [`AXI_ADDR_BITS-1:0] A,         // SRAM 地址
    output logic [`AXI_DATA_BITS-1:0] DO,       // SRAM 輸出數據
    output logic stall_CPU_R,                    // CPU stall 訊號
    output logic rvalid_out,
    output logic rlast_out,
    input logic [`AXI_LEN_BITS-1:0] burst_LEN
);

    // 狀態機狀態編碼
    typedef enum logic [1:0] {
        ST_IDLE   = 2'd0,
        ST_WAIT   = 2'd1,
        ST_READ   = 2'd2
    } master_state_t;

    master_state_t state, next_state;
    reg [`AXI_ADDR_BITS-1:0] araddr_reg;
    reg [`AXI_ID_BITS-1:0] arid_reg;
    reg  arvalid_reg;

    logic  [`AXI_DATA_BITS-1:0] rdata_reg;

    // 狀態機控制
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn)
            state <= ST_IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            ST_IDLE: begin
                    next_state = (ARVALID) ? ((ARREADY) ? ST_READ : ST_WAIT) : state;
            end
            ST_WAIT: next_state = (ARREADY) ? ST_READ : state;
            ST_READ: next_state = (RVALID && RLAST && RREADY) ? ST_IDLE : state;
        endcase
    end
		
    always@(*)begin
        case(state)
        ST_IDLE:begin
            begin
                ARID=4'b0;
                ARADDR=A;
                ARVALID=read_signal;
                RREADY=1'b0;
                DO=RDATA;
                stall_CPU_R = (read_signal);
            end
        end
        ST_WAIT:begin
            ARID=4'b0;
            ARADDR=araddr_reg;
            ARVALID=arvalid_reg;
            RREADY=1'b0;
            DO=RDATA;
            stall_CPU_R=1'b1;
        end
        ST_READ:begin
                ARID=arid_reg;
                ARADDR=araddr_reg;
                ARVALID=1'b0;
                RREADY=1'b1;
                DO=RDATA;
                stall_CPU_R = (!RLAST);
        end
        default: begin
            ARID=4'b0;
            ARADDR=32'b0;
            ARVALID=1'b0;
            RREADY=1'b0;
            DO=32'b0;
            stall_CPU_R=1'b0;
        end
        endcase
    end
        
    always_ff@(posedge ACLK or posedge ARESETn) begin
	if(ARESETn)begin
		arid_reg<=4'b0;
		araddr_reg<=32'b0;
		arvalid_reg<=1'b0;
        // rdata_reg<=32'b0;
	end
	else begin
		case(state)
		ST_IDLE: begin
			arid_reg<=id_in;
			araddr_reg<=A;
			arvalid_reg<=read_signal;
		end
        // ST_READ: begin
		// 	rdata_reg<=RDATA;
		// end
		default: 
        begin
			arid_reg<=arid_reg;
			araddr_reg<=araddr_reg;
			arvalid_reg<=arvalid_reg;
		end
		endcase
	end
end

    assign rvalid_out = RVALID;
    assign rlast_out = RLAST;
    
    assign ARLEN    = burst_LEN;
    assign ARSIZE   = `AXI_SIZE_BITS'd2;     // 預設 32 位元
    assign ARBURST  = 2'b01;                 // INCR 模式


endmodule
