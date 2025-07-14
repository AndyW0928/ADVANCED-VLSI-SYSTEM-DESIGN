// `include "../../../include/AXI_define.svh"
// `include "../include/AXI_define.svh"

module ReadArbiter(
    input clk,
    input rst,

    input ARVALID_M0,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    input ARVALID_M1,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    input ARVALID_M2,
    input [`AXI_ADDR_BITS-1:0] ARADDR_M2,
    output logic ARVALID,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR,
    output logic [`AXI_ID_BITS-1:0] ARID,

    input ARREADY,
    input done,

    output logic [1:0] RADDR_Src,
    output logic [1:0] RDATA_Src
);

    logic state;
    logic next_state;

    logic [`AXI_ADDR_BITS-1:0] ARADDR_reg;
    logic [`AXI_ID_BITS-1:0]   ARID_reg;
    logic [1:0]                RADDR_reg;
    logic [1:0]                RDATA_reg;

    logic                      ARVALID_MUX;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_MUX;
    logic [`AXI_ID_BITS-1:0]   ARID_MUX;
    logic [1:0]                RADDR_MUX;
    logic [1:0]                RDATA_MUX;

    logic [1:0] taking_master, previous_master;
    logic [`AXI_MASTER_num-1:0] ARVALID_Sel;
    
    // assign ARVALID_Sel = {ARVALID_M0 , ARVALID_M1 , 1'b0/*ARVALID_M2*/};
    assign ARVALID_Sel = {ARVALID_M0 , ARVALID_M1 , ARVALID_M2};

    always_comb
    begin
        case (state)
            `IDLE:
            begin
                if (ARREADY)
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

    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= `IDLE;
            ARADDR_reg <= 32'd0;
            ARID_reg <= 4'd0;
            RADDR_reg <= 2'd0;
            RDATA_reg <= 2'd0;
        end
        else
        begin
            state <= next_state;
            ARADDR_reg <= ARADDR_MUX;
            ARID_reg <= ARID_MUX;
            RADDR_reg <= RADDR_MUX;
            RDATA_reg <= RDATA_MUX;
        end
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
                    case(ARVALID_Sel)
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
                    case (RADDR_MUX)
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
        ARVALID_MUX = 1'd0;

        case (state)
            `IDLE: 
                begin
                    case(ARVALID_Sel)
                    `M0_M1_M2:
                            case (previous_master)
                            `M0: begin
                                ARVALID_MUX = ARVALID_M1;
                                ARADDR_MUX = ARADDR_M1;
                                ARID_MUX = {2'b0, `M1};
                                RADDR_MUX = `M1MUX;
                                RDATA_MUX = `M1MUX;
                            end
                            `M1: begin
                                ARVALID_MUX = ARVALID_M2;
                                ARADDR_MUX = ARADDR_M2;
                                ARID_MUX = {2'b0, `M2};
                                RADDR_MUX = `M2MUX;
                                RDATA_MUX = `M2MUX;
                            end
                            `M2: begin
                                ARVALID_MUX = ARVALID_M0;
                                ARADDR_MUX = ARADDR_M0;
                                ARID_MUX = {2'b0, `M0};
                                RADDR_MUX = `M0MUX;
                                RDATA_MUX = `M0MUX;
                            end
                            default: begin
                                ARVALID_MUX = ARVALID_M0;
                                ARADDR_MUX = ARADDR_M0;
                                ARID_MUX = {2'b0, `M0};
                                RADDR_MUX = `M0MUX;
                                RDATA_MUX = `M0MUX;
                            end
                        endcase
                    `M0_nM1_nM2:
                        begin
                            ARVALID_MUX = ARVALID_M0;
                            ARADDR_MUX = ARADDR_M0;
                            ARID_MUX = {2'b0, `M0};
                            RADDR_MUX = `M0MUX;
                            RDATA_MUX = `M0MUX;
                        end
                    `M0_M1_nM2:
                        begin
                            if (previous_master == `M1) begin
                                ARVALID_MUX = ARVALID_M0;
                                ARADDR_MUX = ARADDR_M0;
                                ARID_MUX = {2'b0, `M0};
                                RADDR_MUX = `M0MUX;
                                RDATA_MUX = `M0MUX;
                            end else begin
                                ARVALID_MUX = ARVALID_M1;
                                ARADDR_MUX = ARADDR_M1;
                                ARID_MUX = {2'b0, `M1};
                                RADDR_MUX = `M1MUX;
                                RDATA_MUX = `M1MUX;
                            end
                        end
                    `M0_nM1_M2:
                        begin
                            if (previous_master == `M2) begin
                                ARVALID_MUX = ARVALID_M0;
                                ARADDR_MUX = ARADDR_M0;
                                ARID_MUX = {2'b0, `M0};
                                RADDR_MUX = `M0MUX;
                                RDATA_MUX = `M0MUX;
                            end else begin
                                ARVALID_MUX = ARVALID_M2;
                                ARADDR_MUX = ARADDR_M2;
                                ARID_MUX = {2'b0, `M2};
                                RADDR_MUX = `M2MUX;
                                RDATA_MUX = `M2MUX;
                            end
                        end
                    `nM0_M1_M2:
                        begin
                            if (previous_master == `M2) begin
                                ARVALID_MUX = ARVALID_M1;
                                ARADDR_MUX = ARADDR_M1;
                                ARID_MUX = {2'b0, `M1};
                                RADDR_MUX = `M1MUX;
                                RDATA_MUX = `M1MUX;
                            end else begin
                                ARVALID_MUX = ARVALID_M2;
                                ARADDR_MUX = ARADDR_M2;
                                ARID_MUX = {2'b0, `M2};
                                RADDR_MUX = `M2MUX;
                                RDATA_MUX = `M2MUX;
                            end
                        end
                    `nM0_M1_nM2:
                        begin
                            ARVALID_MUX = ARVALID_M1;
                            ARADDR_MUX = ARADDR_M1;
                            ARID_MUX = {2'b0, `M1};
                            RADDR_MUX = `M1MUX;
                            RDATA_MUX = `M1MUX;
                        end
                    `nM0_nM1_M2:
                        begin
                            ARVALID_MUX = ARVALID_M2;
                            ARADDR_MUX = ARADDR_M2;
                            ARID_MUX = {2'b0, `M2};
                            RADDR_MUX = `M2MUX;
                            RDATA_MUX = `M2MUX;
                        end
                    `nM0_nM1_nM2:
                        begin
                            ARVALID_MUX = 1'd0;
                            ARADDR_MUX = 32'd0;
                            ARID_MUX = 4'b1111;
                            RADDR_MUX = `DEFAULTMMUX;
                            RDATA_MUX = `DEFAULTMMUX;
                        end
                    endcase                    
                end
            `BUSY: 
                begin
                    case(RADDR_MUX)
                        `M0MUX:ARVALID_MUX = ARVALID_M0;
                        `M1MUX:ARVALID_MUX = ARVALID_M1;
                        `M2MUX:ARVALID_MUX = ARVALID_M2;
                        default: ;
                    endcase
                    ARADDR_MUX = ARADDR_reg;
                    ARID_MUX = ARID_reg;
                    RADDR_MUX = RADDR_reg;
                    RDATA_MUX = RDATA_reg;
                end
            default: 
                begin
                    ARVALID_MUX = 1'd0;
                    ARADDR_MUX = 32'd0;
                    ARID_MUX = 4'b1111;
                    RADDR_MUX = `DEFAULTMMUX;
                    RDATA_MUX = `DEFAULTMMUX;
                end
        endcase

        ARVALID = ARVALID_MUX;
        ARADDR = ARADDR_MUX;
        ARID = ARID_MUX;
        RADDR_Src = RADDR_MUX;
        RDATA_Src = RDATA_MUX;
    end
endmodule
