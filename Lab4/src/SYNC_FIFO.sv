module SYNC_FIFO #(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 16
)(
    input logic clk,
    input logic rst,
    input logic wpush,
    input logic [DATA_WIDTH-1:0] wdata,
    output logic wfull,
    input logic rpop,
    output logic [DATA_WIDTH-1:0] rdata,
    output logic rempty
);
    logic [$clog2(FIFO_DEPTH):0] data_count;
    logic [$clog2(FIFO_DEPTH)-1:0] wr_ptr, rd_ptr;
    logic [DATA_WIDTH-1:0] FIFO [0:FIFO_DEPTH-1];
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 4'b0;
        end else if (wpush && !wfull) begin
            FIFO[wr_ptr] <= wdata;
            wr_ptr <= (wr_ptr == FIFO_DEPTH - 32'b1) ? 4'b0 : wr_ptr + 4'd1;
        end
    end
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 4'b0;
            rdata  <= {DATA_WIDTH{1'b0}};
        end else if (rpop && !rempty) begin
            rdata <= FIFO[rd_ptr];
            rd_ptr <= (rd_ptr == FIFO_DEPTH - 32'b1) ? 4'b0 : rd_ptr + 4'd1;
        end
    end
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_count <= 5'b0;
        end else begin
            case ({wpush, rpop})
                2'b10: data_count <= data_count + 5'd1;
                2'b01: data_count <= data_count - 5'd1;
                default: data_count <= data_count;
            endcase
        end
    end
    assign wfull  = (data_count == FIFO_DEPTH);
    assign rempty = (data_count == 5'b0);
endmodule