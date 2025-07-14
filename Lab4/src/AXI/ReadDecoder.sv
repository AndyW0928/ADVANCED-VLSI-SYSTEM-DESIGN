// `include "../../../include/AXI_define.svh"
// `include "../include/AXI_define.svh"

module ReadDecoder(
    input clk,
    input rst,
    input ARVALID,
    input [`AXI_ADDR_BITS-1:0] ARADDR,
    output logic ARREADY,
    output logic done,
    input RREADY,

    input ARREADY_S0,
    input ARREADY_S1,
    input ARREADY_S2,
    input ARREADY_S3,
    input ARREADY_S4,
    input ARREADY_S5,        
    input RVALID,
    input RLAST,

    output logic [2:0] RADDR_Src,
    output logic [2:0] RDATA_Src
);
    logic state;
    logic next_state;
    logic ARREADY_wire;

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
                if (ARREADY_wire) 
                begin
                    next_state = `BUSY;
                end
                else 
                begin
                    next_state = `IDLE;
                end
                done = 1'b0;
            end
            `BUSY:
            begin
                if (RREADY && RVALID && RLAST)
                begin
                    next_state = `IDLE;
                    done = 1'b1;
                end
                else 
                begin
                    next_state = `BUSY;
                    done = 1'b0;
                end
            end    
            // default: 
            // begin
            //     next_state = `IDLE;
            //     done = 1'b0;
            // end
        endcase
    end
    always_comb 
begin
    case (state)
        `IDLE:
        begin
            if (ARVALID)
            begin
                // Default ready signal
                ARREADY_wire = 1'b0;

                // 0x0000_0000 ~ 0x0000_1FFF (ROM)
                if (~|(ARADDR[31:13])) 
                begin
                    ARREADY_wire = ARREADY_S0;
                end
                // 0x0001_0000 ~ 0x0001_FFFF (IM SRAM)
                else if ((~|(ARADDR[31:17])) & ARADDR[16])
                begin
                    ARREADY_wire = ARREADY_S1;
                end
                // 0x0002_0000 ~ 0x0002_FFFF (DM SRAM)
                else if ((~|(ARADDR[31:18])) & ARADDR[17])
                begin
                    ARREADY_wire = ARREADY_S2;
                end
                // 0x1002_0000 ~ 0x1002_0400 (DMA)
                else if ((ARADDR[31:16] == 16'h1002))
                begin
                    ARREADY_wire = ARREADY_S3;
                end
                // 0x1001_0000 ~ 0x1001_03FF (WDT)
                else if ((~|(ARADDR[31:29])) & ARADDR[28] & ARADDR[16] & (~|(ARADDR[15:10])))
                begin
                    ARREADY_wire = ARREADY_S4;
                end
                // 0x2000_0000 ~ 0x201F_FFFF (DRAM)
                else if ((~|(ARADDR[31:30])) & ARADDR[29] & (~|(ARADDR[28:21])))
                begin
                    ARREADY_wire = ARREADY_S5;
                end
                else 
                begin
                    ARREADY_wire = 1'b1;
                end
            end
            else 
            begin
                ARREADY_wire = 1'd0;
            end
            RADDR_Src = `DEFAULTSMUX;
            RDATA_Src = `DEFAULTSMUX;
        end

        `BUSY:
        begin
            ARREADY_wire = 1'd0;

            // 0x0000_0000 ~ 0x0000_1FFF (ROM)
            if (~|(ARADDR[31:13])) 
            begin
                RADDR_Src = `S0MUX;
                RDATA_Src = `S0MUX;
            end
            // 0x0001_0000 ~ 0x0001_FFFF (IM SRAM)
            else if ((~|(ARADDR[31:17])) & ARADDR[16])
            begin
                RADDR_Src = `S1MUX;
                RDATA_Src = `S1MUX;
            end
            // 0x0002_0000 ~ 0x0002_FFFF (DM SRAM)
            else if ((~|(ARADDR[31:18])) & ARADDR[17])
            begin
                RADDR_Src = `S2MUX;
                RDATA_Src = `S2MUX;
            end
            // 0x1002_0000 ~ 0x1002_0400 (DMA)
            else if ((ARADDR[31:16] == 16'h1002))
            begin
                RADDR_Src = `S3MUX;
                RDATA_Src = `S3MUX;
            end
            // 0x1001_0000 ~ 0x1001_03FF (WDT)
            else if ((~|(ARADDR[31:29])) & ARADDR[28] & ARADDR[16] & (~|(ARADDR[15:10]))) 
            begin
                RADDR_Src = `S4MUX;
                RDATA_Src = `S4MUX;                 
            end
            // 0x2000_0000 ~ 0x201F_FFFF (DRAM)
            else if ((~|(ARADDR[31:30])) & ARADDR[29] & (~|(ARADDR[28:21])))
            begin
                RADDR_Src = `S5MUX;
                RDATA_Src = `S5MUX;
            end
            else 
            begin
                RADDR_Src = `WRONGADDRESS;
                RDATA_Src = `WRONGADDRESS;
            end
        end

        default:
        begin
            ARREADY_wire = 1'd0;
            RADDR_Src = `DEFAULTSMUX;
            RDATA_Src = `DEFAULTSMUX;
        end
    endcase

    ARREADY = ARREADY_wire;
end

endmodule
