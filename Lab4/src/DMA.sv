`define DMAEN          32'h10020100
`define DMASRC         32'h10020200
`define DMADST         32'h10020300
`define DMALEN         32'h10020400
`define DATA_WIDTH     32
`define BURST_LEN      16
// `include "../../src/DMA/DMA_controller.sv"
// `include "../../src/DMA/SYNC_FIFO.sv"

module DMA (
    input logic clk,
    input logic rst,
    input logic [31:0] DMA_SlaveWrite_addr,
    input logic [31:0] DMA_SlaveWrite_data,
    input logic slave_write,
    input logic WFI_pc_en,
    input logic read_ready,
    input logic write_ready,
    output logic [31:0] DMASRC_addr,
    output logic [31:0] DMADST_addr,
    output logic master_read,
    output logic master_write,
    input logic [31:0] read_data,
    output logic [3:0] burst_LEN,
    output logic [31:0] write_data,
    input logic read_complete,
    input logic read_valid,
    input logic write_valid,
    input logic write_complete,
    output logic interrupt
);
    assign burst_LEN = 4'd15;

    logic fifo_empty, fifo_full;
    logic DMAEN;
    logic [31:0] DMASRC, DMADST, DMALEN;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            DMAEN  <= 1'b0;
            DMASRC <= 32'd0;
            DMADST <= 32'd0;
            DMALEN <= 32'd0;
        end else if (interrupt) begin
            DMAEN  <= 1'b0;
            DMASRC <= 32'd0;
            DMADST <= 32'd0;
            DMALEN <= 32'd0;
        end else if (slave_write) begin
            case (DMA_SlaveWrite_addr)
                `DMAEN:  DMAEN  <= DMA_SlaveWrite_data[0];
                `DMASRC: DMASRC <= DMA_SlaveWrite_data;
                `DMADST: DMADST <= DMA_SlaveWrite_data;
                `DMALEN: DMALEN <= DMA_SlaveWrite_data;
                default: ;
            endcase
        end
    end
    DMA_controller controller (
        .clk(clk),
        .rst(rst),
        .DMAEN(DMAEN),
        .DMASRC(DMASRC),
        .DMADST(DMADST),
        .DMALEN(DMALEN),
        .WFI_pc_en(WFI_pc_en),
        .read_ready(read_ready),
        .write_ready(write_ready),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .DMASRC_addr(DMASRC_addr),
        .DMADST_addr(DMADST_addr),
        .master_read(master_read),
        .master_write(master_write),
        .read_complete(read_complete),
        .write_complete(write_complete),
        .interrupt(interrupt)
    );
    SYNC_FIFO #(
        .DATA_WIDTH(`DATA_WIDTH),
        .FIFO_DEPTH(`BURST_LEN)
    ) fifo (
        .clk(clk),
        .rst(rst),
        .wpush(read_valid),
        .wdata(read_data),
        .rpop(write_valid),
        .rdata(write_data),
        .wfull(fifo_full),
        .rempty(fifo_empty)
    );
endmodule