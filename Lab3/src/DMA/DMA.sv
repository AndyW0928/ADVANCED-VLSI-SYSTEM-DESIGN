module DMA (
input               clk,
input               rst,
input               DMAEN,
input  [31:0]       DMASRC,
input  [31:0]       DMADST,
input  [31:0]       DMALEN,
input               dma_en, 
input               WFI_pc_en,
output logic        interrupt_dma,
output logic [31:0] DMASRC_addr,
output logic [31:0] DMADST_addr
);

localparam  IDLE  = 2'b00,
            WAIT_CYCLE = 2'b01,
            TRANS = 2'b10,
            FINISH  = 2'b11;

logic [1:0] cs, ns;
logic [31:0] DMALEN_r;

//cs
always_ff @(posedge clk or posedge rst) 
begin
    if (rst) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

//ns
always_comb 
begin
    case (cs)
        IDLE: begin
            if (DMAEN && WFI_pc_en) begin
                ns = WAIT_CYCLE;
            end
            else begin
                ns = IDLE;
            end
        end
        WAIT_CYCLE: begin
            ns = TRANS;
        end
        TRANS: begin
            if ($signed(DMALEN_r) > $signed(32'b0)) begin
                ns = TRANS;
            end
            else begin
                ns = FINISH;
            end
                
        end
        FINISH: begin
            if (!DMAEN) begin
                ns = IDLE;
            end
            else begin
                ns = FINISH;
            end
        end
        // default:begin
        //     ns = IDLE;
        // end
    endcase
end



//out
always_comb 
begin
    if (cs == FINISH) begin
        interrupt_dma = 1'b1;
    end
    else begin
        interrupt_dma = 1'b0;
    end
end

//reg
always_ff @(posedge clk or posedge rst) 
begin
    if (rst) begin
        DMASRC_addr <= 32'b0;
        DMADST_addr <= 32'b0;
        DMALEN_r <= 32'b0;
    end 
    else begin
        if (cs == WAIT_CYCLE) begin
            DMASRC_addr      <= DMASRC;
            DMADST_addr      <= DMADST;
            DMALEN_r         <= DMALEN;
        end 
        else if (cs == TRANS && DMALEN_r > 32'd0 && dma_en) begin
            DMASRC_addr      <= DMASRC_addr + 32'd4;
            DMADST_addr      <= DMADST_addr + 32'd4; 
            DMALEN_r         <= DMALEN_r - 32'd4;
        end
     end
end
endmodule