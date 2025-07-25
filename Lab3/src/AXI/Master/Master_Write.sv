// `include "AXI_define.svh"
module Master_Write(
    input                       ACLK, ARESETn,

    output logic [`AXI_ID_BITS-1:0]     AWID,
    output logic [`AXI_ADDR_BITS-1:0]   AWADDR,
    output logic [`AXI_LEN_BITS-1:0]    AWLEN,
    output logic [`AXI_SIZE_BITS-1:0]   AWSIZE,
    output logic [1:0]                  AWBURST, //only INCR type
    output logic                        AWVALID,
    input                       AWREADY,

    output logic [`AXI_DATA_BITS-1:0]   WDATA,
    output logic [`AXI_STRB_BITS-1:0]   WSTRB,
    output logic                        WLAST,
    output logic                        WVALID,
    input                       WREADY, 

    input [`AXI_ID_BITS-1:0]    BID,
    input [1:0]                 BRESP,
    input                       BVALID,
    output logic                BREADY, 

    input [31:0]                address_in, 
    input [3:0]                 w_en,
    input [`AXI_DATA_BITS-1:0]  data_in,          
    input [`AXI_ID_BITS-1:0]  id_in,      
    input write_signal,

    output logic                stall_W,

    output logic [1:0] state,
    output logic [1:0] nstate,

    input  [1:0] MR_state,
    input [1:0] MR_nstate 
        
);

localparam  IDLE=2'd0,
            WAIT_HS=2'd1,
            DATA=2'd2,
            RESP=2'd3;

// logic [1:0] state,nstate;

logic [3:0] AWID_reg, BID_reg;
logic [31:0] AWADDR_reg;
logic [31:0] WDATA_reg;
logic [3:0] WSTRB_reg;
logic [3:0] awlen_reg;
logic [4:0] burstlen_reg;

logic AWVALID_reg;

//Current state register
always_ff@(posedge ACLK or posedge ARESETn) begin
    if(ARESETn) state<=IDLE;
    else state<=nstate;
end

//next state logic(comb)
always@(*)begin
    case(state)
    IDLE:begin
        if(MR_state!=2'b0)begin
            nstate=IDLE;
        end
        else begin
            if(AWVALID)begin
                if(AWREADY) nstate=DATA;
                else nstate=WAIT_HS;
            end
            else nstate=IDLE;
        end
    end
    WAIT_HS:begin
        if(AWREADY) nstate=DATA;
        else nstate=WAIT_HS;
    end
    DATA: begin
        if(WLAST && WVALID && WREADY) nstate=RESP;
        else nstate=DATA;
    end
    RESP:begin
        if(BREADY && BVALID) nstate=IDLE;
        else nstate=RESP;
    end
    endcase
end

//output logic
always@(*)begin
    case(state)
    IDLE:begin
        if(MR_state!=2'b0)begin
            AWID=4'b0;
            AWADDR=32'b0;
            AWLEN=4'b0;
            AWSIZE=3'b010;
            AWBURST=2'b01;

            AWVALID=1'b0;
            WDATA=32'b0;
            WSTRB=4'b0;
            WLAST=1'b0;
            WVALID=1'b0;

            BREADY=1'b0;

            stall_W=1'b1;
        end
        else begin
            AWID=4'b0;
            AWADDR=address_in;
            AWLEN=4'b0;
            AWSIZE=3'b010;
            AWBURST=2'b01;

            AWVALID=write_signal;
            WDATA=32'b0;
            WSTRB=4'b0;
            WLAST=1'b0;
            WVALID=1'b0;

            BREADY=1'b0;

            stall_W=1'b1;
        end
    end
    WAIT_HS:begin
        AWID=4'b0;
        AWADDR=AWADDR_reg;
        AWLEN=4'b0;
        AWSIZE=3'b010;
        AWBURST=2'b01;

        AWVALID=AWVALID_reg;
        WDATA=32'b0;
        WSTRB=w_en;//4'b0;
        WLAST=1'b0;
        WVALID=1'b0;

        BREADY=1'b0;

        stall_W=1'b1;
    end
    DATA:begin
        AWID=AWID_reg;
        AWADDR=AWADDR_reg;
        AWLEN=awlen_reg;
        AWSIZE=3'b010;
        AWBURST=2'b01;

        AWVALID=1'b0;
        WDATA=WDATA_reg;
        WSTRB=WSTRB_reg;

        if(burstlen_reg==5'b1) WLAST=1'b1;
        else WLAST=1'b0;

        WVALID=1'b1;

        BREADY=1'b0;

        stall_W=1'b1;
    end
    RESP:begin
        AWID=AWID_reg;
        AWADDR=AWADDR_reg;
        AWLEN=awlen_reg;
        AWSIZE=3'b010;
        AWBURST=2'b01;

        AWVALID=1'b0;
        WDATA=32'b0;
        WSTRB=4'b0;

        WLAST=1'b0;
        WVALID=1'b0;

        BREADY=1'b1;
        if(MR_state!=2'b0 && MR_nstate!=2'b0) stall_W=1'b1;
        else begin
            if(nstate==IDLE) stall_W=1'b0;
            else stall_W=1'b1;
        end
    end
    endcase
end

always_ff@(posedge ACLK or posedge ARESETn)begin
    if(ARESETn)begin
            AWID_reg<=4'b0;
            AWADDR_reg<=32'b0;
            WDATA_reg<=32'b0;
            WSTRB_reg<=4'b0;
            BID_reg<=4'b0;
            awlen_reg<=4'b0;
            burstlen_reg<=5'b0;

            AWVALID_reg<=1'b0;
    end
    else begin
        case(state)
        IDLE: begin
            AWID_reg<=id_in;
            AWADDR_reg<=address_in;
            WDATA_reg<=data_in;
            WSTRB_reg<=w_en;
            BID_reg<=id_in;
            awlen_reg<=AWLEN;
            burstlen_reg<={1'b0,AWLEN}+5'b1;
            AWVALID_reg<=write_signal;
        end
        WAIT_HS: begin
            AWID_reg<=AWID_reg;
            AWADDR_reg<=AWADDR_reg;
            WDATA_reg<=WDATA_reg;
            WSTRB_reg<=WSTRB_reg;
            BID_reg<=BID_reg;
            awlen_reg<=awlen_reg;
            burstlen_reg<=burstlen_reg;
            AWVALID_reg<=AWVALID_reg;

        end
        DATA: begin
            AWID_reg<=AWID_reg;
            AWADDR_reg<=AWADDR_reg;
            WDATA_reg<=WDATA_reg;
            WSTRB_reg<=WSTRB_reg;
            BID_reg<=BID_reg;

            awlen_reg<=4'b0; 

            if(burstlen_reg==5'b1)begin
                burstlen_reg<=burstlen_reg;
            end
            else begin
                burstlen_reg<=burstlen_reg-5'b1;
            end
        end
        default: ;
        endcase
    end
end


endmodule
