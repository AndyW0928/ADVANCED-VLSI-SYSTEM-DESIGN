module DMA_controller(
    input  logic clk,
    input  logic rst,

    // Control signals
    input  logic DMAEN,
    input  logic [31:0] DMASRC,
    input  logic [31:0] DMADST,
    input  logic [31:0] DMALEN,
    input  logic WFI_pc_en,
    input  logic read_ready,
    input  logic write_ready,

    // FIFO status
    input  logic fifo_full,
    input  logic fifo_empty,

    // AXI signals
    output logic [31:0] DMASRC_addr,
    output logic [31:0] DMADST_addr,
    output logic master_read,
    output logic master_write,
    input  logic read_complete,
    input  logic write_complete,

    // Interrupt
    output logic interrupt
);

    // Internal registers and wires
    logic [31:0] current_addr;
    logic [31:0] end_address;

    assign end_address = DMADST + (DMALEN << 2);
    assign DMASRC_addr = current_addr + DMASRC;
    assign DMADST_addr = current_addr + DMADST;

    // State encoding
    typedef enum logic [2:0] {
        IDLE  = 3'b000,
        READ  = 3'b010,
        WAIT  = 3'b110,
        WRITE = 3'b100,
        RET   = 3'b101,
        DONE  = 3'b111
    } state_t;

    state_t state, nstate;

    // State transition logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= nstate;
    end

    // Next-state logic
    always_comb begin
        nstate = state;
        case (state)
            IDLE: if (DMAEN && WFI_pc_en) nstate = READ;
            READ: if (read_complete || fifo_full) nstate = WAIT;
            WAIT: if (write_ready) nstate = WRITE;
            WRITE: if (write_complete || fifo_empty) nstate = RET;
            RET: if ((current_addr + 32'd64) < DMALEN) nstate = READ; else nstate = DONE;
            DONE: if (!(DMAEN && WFI_pc_en)) nstate = IDLE;
            default: nstate = IDLE;
        endcase
    end

    // Address update logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            current_addr <= 32'b0;
        else begin
            case (state)
                IDLE: current_addr <= 32'b0;
                RET: current_addr <= current_addr + 32'd64;
                default: current_addr <= current_addr;
            endcase
        end
    end

    // Output control signals
    always_comb begin
        master_read  = 1'b0;
        master_write = 1'b0;
        interrupt    = 1'b0;
        case (state)
            IDLE: interrupt = 1'b0;
            READ: master_read = 1'b1;
            WAIT: master_write = 1'b1;
            WRITE: master_write = 1'b1;
            RET: ;
            DONE: interrupt = 1'b1; // Signal interrupt when done
            default: ;
        endcase
    end

endmodule
