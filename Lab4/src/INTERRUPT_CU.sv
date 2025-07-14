`define INTR_STATE_BITS 2
`define MRET    (32'b0011000_00010_00000_000_00000_1110011)
`define WFI     (32'b0001000_00101_00000_000_00000_1110011)

module INTERRUPT_CU(
    input logic clk, 
    input logic rst,
    input logic [31:0] inst,
    input logic mie_in, mtie_in, meie_in,
    input logic AXI_stall,    
    input logic inter_DMA, inter_WDT,       // interrupt signal from DMA and WDT
    output logic MEIP_en, MEIP_end,        // external interrupt (DMA) begin/end
    output logic MTIP_en, MTIP_end,        // timer interrupt (WDT) begin/end
    output logic WFI_out,                 // for CSR to decide PC
    output logic WFI_pc_en                // enable PC for WFI
);

// logic MRET_en, WFI_en; // Detect MRET and WFI instructions

// CSR signals
// assign MRET_en = (inst == `MRET)?1'b1:1'b0;
// assign WFI_en =  (inst == `WFI)?1'b1:1'b0;

// State definition for the interrupt control unit
typedef enum logic[`INTR_STATE_BITS - 1:0] {
    IDLE    = 2'b00, 
    WFI     = 2'b01, 
    TRAP    = 2'b11, 
    TIMEOUT = 2'b10
} INTER_state;
INTER_state inter_cs, inter_ns;

// Current state register
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        inter_cs <= IDLE;
    else
        inter_cs <= inter_ns;
end

// Next state logic
always_comb begin
    inter_ns = inter_cs;
    case (inter_cs)
        IDLE: begin
            if (~AXI_stall) begin
                if (inter_DMA && meie_in && mie_in)
                    inter_ns = TRAP;
                else if (inter_WDT && mtie_in && mie_in)
                    inter_ns = TIMEOUT;
                else if ((inst == `WFI))
                    inter_ns = WFI;
            end
        end
        WFI: begin
            if (~AXI_stall) begin
                if (inter_DMA && meie_in && mie_in)
                    inter_ns = TRAP;
                else if (inter_WDT && mtie_in && mie_in)
                    inter_ns = TIMEOUT;
            end
        end
        TRAP: begin
            if (~AXI_stall && (inst == `MRET))
                inter_ns = IDLE;
        end
        TIMEOUT: begin
            if (~AXI_stall && ~inter_WDT)
                inter_ns = IDLE;
        end
    endcase
end

// always@(posedge clk or posedge rst)begin
//     if(rst) begin
//         WFI_out<=1'b0;
//     end
//     else begin
//         WFI_out<=WFI_pc_en;
//     end
// end

// Output logic
always_comb begin
    MEIP_en = 1'b0;
    MEIP_end = 1'b0;
    MTIP_en = 1'b0;
    MTIP_end = 1'b0;
    WFI_out = 1'b0;
    WFI_pc_en = 1'b0;

    case (inter_cs)
        IDLE: begin
            if (inter_ns == TRAP) begin
                MEIP_en = 1'b1;
            end else if (inter_ns == TIMEOUT) begin
                MTIP_en = 1'b1;
            end else if (inter_ns == WFI) begin
                WFI_pc_en = 1'b1;
            end
        end
        WFI: begin
            WFI_out = 1'b1;
            if (inter_ns == TRAP) begin
                MEIP_en = 1'b1;
                WFI_pc_en = 1'b0;
            end else if (inter_ns == TIMEOUT) begin
                MTIP_en = 1'b1;
            end else begin
                WFI_pc_en = 1'b1;
            end
        end
        TRAP: begin
            if (inter_ns == IDLE) begin
                MEIP_en = 1'b0;
                MEIP_end = 1'b1;
            end
        end
        TIMEOUT: begin
            if (inter_ns == IDLE) begin
                MTIP_end = 1'b1;
            end
        end
    endcase
end

endmodule
