// `include "../../../include/AXI_define.svh"
// `include "../include/AXI_define.svh"

module WriteArbiter(
    input clk,
	input rst,
    // Master Write Signal
    input AWVALID_M1,
    input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
    input AWVALID_M2,
    input [`AXI_ADDR_BITS-1:0] AWADDR_M2,
    // Signal to AXI & Siganl to Decoder
    output logic AWVALID,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR,
    output logic [`AXI_ID_BITS-1:0] AWID,
    // Decoder to Arbiter
    input AWREADY,
    input done,
    // Bridge Selection
    output logic [1:0] WADDR_Src,
    output logic [1:0] WDATA_Src,
    output logic [1:0] WRESP_Src
);
    logic state;
    logic next_state;

    logic [`AXI_ADDR_BITS-1:0] AWADDR_reg;
    logic [`AXI_ID_BITS-1:0]   AWID_reg;
    logic [1:0]                WADDR_reg;
    logic [1:0]                WDATA_reg;
    logic [1:0]                WRESP_reg;

    logic                      AWVALID_MUX;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_MUX;
    logic [`AXI_ID_BITS-1:0]   AWID_MUX;
    logic [1:0]                WADDR_MUX;
    logic [1:0]                WDATA_MUX;
    logic [1:0]                WRESP_MUX;

    logic [1:0] taking_master, previous_master;
    logic [`AXI_MASTER_num-1:0] AWVALID_Sel;

    // assign AWVALID_Sel = {1'b0/*AWVALID_M0*/ , AWVALID_M1 , 1'b0/*ARVALID_M2*/};
    assign AWVALID_Sel = {1'b0/*AWVALID_M0*/ , AWVALID_M1 , AWVALID_M2};

    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= `IDLE;
            AWADDR_reg <= 32'd0;
            AWID_reg <= 4'd0;
            WADDR_reg <= 2'd0;
            WDATA_reg <= 2'd0;
            WRESP_reg <= 2'd0;
        end
        else
        begin
            state <= next_state;
            AWADDR_reg <= AWADDR_MUX;
            AWID_reg <= AWID_MUX;
            WADDR_reg <= WADDR_MUX;
            WDATA_reg <= WDATA_MUX;
            WRESP_reg <= WRESP_MUX;
        end
    end

    always_comb
    begin
        case (state)
            `IDLE:
            begin
                if (AWREADY) 
                begin
                    next_state = `BUSY;
                end
                else 
                begin
                    next_state = `IDLE;
                end
            end
            `BUSY:
            begin
                if (done)
                begin
                    next_state = `IDLE;
                end
                else 
                begin
                    next_state = `BUSY;
                end
            end    
            // default: 
            // begin
            //     next_state = `IDLE;
            // end
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
            if (rst) begin
                previous_master <= `M0; 
            end 
            else if (next_state == `BUSY) begin
                previous_master <= taking_master; 
            end
            else previous_master <= previous_master;
    end

    always_comb begin
        case (state)
            `IDLE: 
                begin
                    case(AWVALID_Sel)
                    `M0_M1_M2:
                            case (previous_master)
                                `M0: taking_master = `M1;
                                `M1: taking_master = `M2;
                                `M2: taking_master = `M0;
                                default: taking_master = `M0;
                            endcase
                    `M0_nM1_nM2:taking_master = `M0;
                    `M0_M1_nM2:taking_master = (previous_master == `M1) ? `M0 : `M1;
                    `M0_nM1_M2:taking_master = (previous_master == `M2) ? `M0 : `M2;
                    `nM0_M1_M2:taking_master = (previous_master == `M2) ? `M1 : `M2;
                    `nM0_M1_nM2:taking_master = `M1;
                    `nM0_nM1_M2:taking_master = `M2;
                    `nM0_nM1_nM2:taking_master = `M0;
                    endcase  
                end
            `BUSY: 
                begin
                    case (WADDR_MUX)
                        `M0MUX: taking_master = `M0;
                        `M1MUX: taking_master = `M1;
                        `M2MUX: taking_master = `M2;
                        default: taking_master = `M0; 
                    endcase
                end
            default: 
                begin
                    taking_master = `M0;
                end
        endcase
    end

    always_comb
    begin
        AWVALID_MUX = 1'd0;
        
        case (state)
            `IDLE: 
                begin
                    case(AWVALID_Sel)
                    // `M0_M1_M2:
                    // `M0_nM1_nM2:
                    // `M0_M1_nM2:
                    // `M0_nM1_M2:
                    // `nM0_nM1_nM2:
                    `nM0_M1_M2:
                        begin
                            if (previous_master == `M2) 
                            begin
                                AWVALID_MUX = AWVALID_M1;
                                AWADDR_MUX = AWADDR_M1;
                                AWID_MUX = {2'b0, `M1};
                                WADDR_MUX = `M1MUX;
                                WDATA_MUX = `M1MUX;
                                WRESP_MUX = `M1MUX;
                            end
                            else begin
                                AWVALID_MUX = AWVALID_M2;
                                AWADDR_MUX = AWADDR_M2;
                                AWID_MUX = {2'b0, `M2};
                                WADDR_MUX = `M2MUX;
                                WDATA_MUX = `M2MUX;
                                WRESP_MUX = `M2MUX;
                            end
                        end
                    `nM0_M1_nM2:
                        begin
                            AWVALID_MUX = AWVALID_M1;
                            AWADDR_MUX = AWADDR_M1;
                            AWID_MUX = {2'b0, `M1};
                            WADDR_MUX = `M1MUX;
                            WDATA_MUX = `M1MUX;
                            WRESP_MUX = `M1MUX;
                        end
                    `nM0_nM1_M2:
                        begin
                            AWVALID_MUX = AWVALID_M2;
                            AWADDR_MUX = AWADDR_M2;
                            AWID_MUX = {2'b0, `M2};
                            WADDR_MUX = `M2MUX;
                            WDATA_MUX = `M2MUX;
                            WRESP_MUX = `M2MUX;
                        end
                    default:
                        begin
                            AWVALID_MUX = 1'd0;
                            AWADDR_MUX = 32'd0;
                            AWID_MUX = 4'b1111;
                            WADDR_MUX = `DEFAULTMMUX;
                            WDATA_MUX = `DEFAULTMMUX;
                            WRESP_MUX = `DEFAULTMMUX;
                        end
                    endcase                    
                end
            `BUSY: 
                begin
                    case(WADDR_MUX)
                        // `M0MUX:AWADDR_MUX = AWADDR_M0;
                        `M1MUX:begin 
                            AWVALID_MUX = AWVALID_M1;
                        end
                        `M2MUX:begin 
                            AWVALID_MUX = AWVALID_M2;
                        end
                        default: ;
                    endcase
                    AWADDR_MUX = AWADDR_reg;
                    AWID_MUX = AWID_reg;
                    WADDR_MUX = WADDR_reg;
                    WDATA_MUX = WDATA_reg;
                    WRESP_MUX = WRESP_reg;
                    
                end
            default: 
                begin
                    AWVALID_MUX = 1'd0;
                    AWADDR_MUX = 32'd0;
                    AWID_MUX = 4'b1111;
                    WADDR_MUX = `DEFAULTMMUX;
                    WDATA_MUX = `DEFAULTMMUX;
                    WRESP_MUX = `DEFAULTMMUX;
                end
        endcase

        AWVALID = AWVALID_MUX;
        AWADDR = AWADDR_MUX;
        AWID = AWID_MUX;
        WADDR_Src = WADDR_MUX;
        WDATA_Src = WDATA_MUX;
        WRESP_Src = WRESP_MUX;
    end

endmodule
