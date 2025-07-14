// `include "../../../include/AXI_define.svh"
// `include "../include/AXI_define.svh"

module WriteDecoder(
    input clk,
	input rst,
    // Arbiter to Decoder
    input AWVALID,
    input [`AXI_ADDR_BITS-1:0] AWADDR,
    // Decoder to Arbiter
    output logic AWREADY,
    output logic done,
    // Master Signal
    input BREADY,
    // Slave Signal
    //input AWREADY_S0,
    input AWREADY_S1,
    input AWREADY_S2,
    input AWREADY_S3,
    input AWREADY_S4,
    input AWREADY_S5,
    input BVALID,
    // Bridge Selection
    output logic [2:0] WADDR_Src,
    output logic [2:0] WDATA_Src,
    output logic [2:0] WRESP_Src
);
    logic state;
    logic next_state;
    logic AWREADY_wire;

    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= `IDLE;
        end 
        else
        begin
            state <= next_state;
        end
    end

    always_comb
    begin
        case (state)
            `IDLE:
            begin
                if (AWREADY_wire) 
                begin
                    next_state = `BUSY;
                end
                else 
                begin
                    next_state = `IDLE;
                end
                done = `FALSE;
            end
            `BUSY:
            begin
                if (BREADY && BVALID)
                begin
                    next_state = `IDLE;
                    done = `TRUE;
                end
                else 
                begin
                    next_state = `BUSY;
                    done = `FALSE;
                end
            end    
            // default: 
            // begin
            //     next_state = `IDLE;
            //     done = `FALSE;
            // end
        endcase
    end

    always_comb 
    begin
        AWREADY_wire = 1'd0;  // 預設 AWREADY 為 0

        case (state)
            `IDLE:
            begin
                if (AWVALID)
                begin
                    // 0x0000_0000 ~ 0x0000_1FFF (ROM)
                    // if (~|(AWADDR[31:13])) 
                    // begin
                    //     AWREADY_wire = AWREADY_S0;
                    // end
                    // else
                    // 0x0001_0000 ~ 0x0001_FFFF (IM SRAM)
                    if ((~|(AWADDR[31:17])) & AWADDR[16])
                    begin
                        AWREADY_wire = AWREADY_S1;
                    end
                    // 0x0002_0000 ~ 0x0002_FFFF (DM SRAM)
                    else if ((~|(AWADDR[31:18])) & AWADDR[17])
                    begin
                        AWREADY_wire = AWREADY_S2;
                    end
                    // 0x1002_0000 ~ 0x1002_0400 (DMA)
                    else if ((AWADDR[31:16] == 16'h1002))
                    begin
                        AWREADY_wire = AWREADY_S3;
                    end
                    // 0x1001_0000 ~ 0x1001_03FF (WDT)
                    else if ((~|(AWADDR[31:29])) & AWADDR[28] & AWADDR[16] & (~|(AWADDR[27:17])) & (~|(AWADDR[15:10]))) 
                    begin
                        AWREADY_wire = AWREADY_S4;                    
                    end
                    // 0x2000_0000 ~ 0x201F_FFFF (DRAM)
                    else if ((~|(AWADDR[31:30])) & AWADDR[29] & (~|(AWADDR[28:21])))
                    begin
                        AWREADY_wire = AWREADY_S5;
                    end
                    // Other
                    else 
                    begin
                        AWREADY_wire = 1'b1; // Default response
                    end
                end
                else 
                begin
                    AWREADY_wire = 1'd0;
                end
                WADDR_Src = `DEFAULTSMUX;
                WDATA_Src = `DEFAULTSMUX;
                WRESP_Src = `DEFAULTSMUX;
            end

            `BUSY:
            begin
                AWREADY_wire = 1'd0;
                // 0x0000_0000 ~ 0x0000_1FFF (ROM)
                // if (~|(AWADDR[31:16])) 
                // begin
                //     WADDR_Src = `S0MUX;
                //     WDATA_Src = `S0MUX;
                //     WRESP_Src = `S0MUX;
                // end
                // else 
                // 0x0001_0000 ~ 0x0001_FFFF (IM SRAM)
                if ((~|(AWADDR[31:17])) & AWADDR[16])
                begin
                    WADDR_Src = `S1MUX;
                    WDATA_Src = `S1MUX;
                    WRESP_Src = `S1MUX;
                end
                // 0x0002_0000 ~ 0x0002_FFFF (DM SRAM)
                else if ((~|(AWADDR[31:18])) & AWADDR[17])
                begin
                    WADDR_Src = `S2MUX;
                    WDATA_Src = `S2MUX;
                    WRESP_Src = `S2MUX;
                end
                // 0x1002_0000 ~ 0x1002_0400 (DMA)
                else if ((AWADDR[31:16] == 16'h1002))
                begin
                    WADDR_Src = `S3MUX;
                    WDATA_Src = `S3MUX;
                    WRESP_Src = `S3MUX;
                end
                // 0x1001_0000 ~ 0x1001_03FF (WDT)
                else if ((~|(AWADDR[31:29])) & AWADDR[28] & AWADDR[16] & (~|(AWADDR[27:17])) & (~|(AWADDR[15:10])))
                begin
                    WADDR_Src = `S4MUX;
                    WDATA_Src = `S4MUX;
                    WRESP_Src = `S4MUX;
                end            
                // 0x2000_0000 ~ 0x201F_FFFF (DRAM)
                else if ((~|(AWADDR[31:30])) & AWADDR[29] & (~|(AWADDR[28:21])))
                begin
                    WADDR_Src = `S5MUX;
                    WDATA_Src = `S5MUX;
                    WRESP_Src = `S5MUX;
                end
                // Other
                else 
                begin
                    WADDR_Src = `WRONGADDRESS;
                    WDATA_Src = `WRONGADDRESS;
                    WRESP_Src = `WRONGADDRESS;
                end
            end

            default:
            begin
                AWREADY_wire = 1'd0;
                WADDR_Src = `DEFAULTSMUX;
                WDATA_Src = `DEFAULTSMUX;
                WRESP_Src = `DEFAULTSMUX;
            end
        endcase
        
        AWREADY = AWREADY_wire;
    end


endmodule
