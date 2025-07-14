module CSR (
    input logic clk, rst,
    input logic [31:0] pc_c,              // Current PC
    input logic [31:0] pc_E,              // EXE cycle PC
    input logic [31:0] rs1_data,          // RS1 data for CSR instructions
    input logic [31:0] inst,
    input logic stall, AXI_stall,
    input logic MEIP_en, MEIP_end,        // External interrupt (DMA) begin/end
    input logic MTIP_en, MTIP_end,        // Timer interrupt (WDT) begin/end
    input logic WFI_in,                   // Wait-for-interrupt signal
    output logic [31:0] csr_data,
    output logic [31:0] pc_CSR,           // PC for interrupt
    output logic mie_out, mtie_out, meie_out
);

// Machine-mode CSR addresses
localparam MSTATUS = 12'h300;
localparam MIE     = 12'h304;
localparam MIP     = 12'h344;
localparam MTVEC   = 12'h305;
localparam MEPC    = 12'h341;

localparam RDINSTRET  = 12'hc02;
localparam RDINSTRETH = 12'hc82;
localparam RDCYCLE    = 12'hc00;
localparam RDCYCLEH   = 12'hc80;

// CSR instruction types
localparam CSRRW  = 3'b001;
localparam CSRRS  = 3'b010;
localparam CSRRC  = 3'b011;
localparam CSRRWI = 3'b101;
localparam CSRRSI = 3'b110;
localparam CSRRCI = 3'b111;

// Internal registers
logic [63:0] csr_inst, csr_cycle;
logic [31:0] mstatus_r, mie_r, mip_r, mtvec_r, mepc_r;

// Decoding fields
logic [11:0] csr_imm;
logic [4:0] rs1;
logic [31:0] uimm;
logic [2:0] func3;
logic [4:0] rd;
logic [6:0] op;
logic csr_func3, csr_en;

// Decode instruction fields
assign csr_imm = inst[31:20];
assign rs1 = inst[19:15];
assign uimm = {27'b0, rs1};
assign func3 = inst[14:12];
assign rd = inst[11:7];
assign op = inst[6:0];

assign csr_func3 = (func3 != 3'b000 && func3 != 3'b100);
assign csr_en = (csr_func3 && (op == 7'b1110011));

// CSR outputs for interrupt control
assign mie_out = mstatus_r[3];
assign mtie_out = mie_r[7];
assign meie_out = mie_r[11];

// CSR data read logic
always_comb begin
    if (rd != 5'b0) begin
        case (csr_imm)
            RDINSTRET:  csr_data = csr_inst[31:0];
            RDINSTRETH: csr_data = csr_inst[63:32];
            RDCYCLE:    csr_data = csr_cycle[31:0];
            RDCYCLEH:   csr_data = csr_cycle[63:32];
            MSTATUS:    csr_data = mstatus_r;
            MIE:        csr_data = mie_r;
            MIP:        csr_data = mip_r;
            MTVEC:      csr_data = mtvec_r;
            MEPC:       csr_data = mepc_r;
            default:    csr_data = 32'b0;
        endcase
    end else begin
        csr_data = 32'b0;
    end
end

// Hardcoded CSR values
assign mtvec_r = 32'h0001_0000;   // IM address
assign mip_r = {20'b0, MEIP_en, 3'b0, MTIP_en, 7'b0};

// CSR register updates
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        mstatus_r <= 32'b0;
        mie_r <= 32'b0;
        mepc_r <= 32'b0;
    end else if (AXI_stall) begin
        // Hold values during stall
        mstatus_r <= mstatus_r;
        mie_r <= mie_r;
        mepc_r <= mepc_r;
    end else begin
        if (csr_en) begin
            case (csr_imm)
                MSTATUS: mstatus_r <= csr_write_logic_A(mstatus_r, rs1_data, uimm, func3, rs1);
                MIE:     mie_r <= csr_write_logic_A(mie_r, rs1_data, uimm, func3, rs1);
                MEPC:    mepc_r <= csr_write_logic_B(mepc_r, rs1_data, uimm, func3, rs1);
            endcase
        end else begin
            if (MEIP_en || MTIP_en) begin
                // Interrupt handling
                mstatus_r[7] <= mstatus_r[3];
                mstatus_r[12:11] <= 2'b11;
                mstatus_r[3] <= 1'b0;
                mepc_r <= WFI_in ? pc_c - 32'd4 : pc_E;
            end else if (MEIP_end || MTIP_end) begin
                // Interrupt end handling
                mstatus_r[3] <= mstatus_r[7];
                mstatus_r[7] <= 1'b1;
                mepc_r <= 32'b0;
            end
            else begin
                    mstatus_r <= mstatus_r;
                    mepc_r <= mepc_r;
                end
        end
    end
end

// Program Counter logic for CSR
always_comb begin
    if (MEIP_en || MTIP_en)
        pc_CSR = mtvec_r;
    else if (MEIP_end || MTIP_end)
        pc_CSR = mepc_r;
    else
        pc_CSR = 32'b0;
end

// Instruction retirement counter
always_ff @(posedge clk or posedge rst) begin : CSR_instrets
        if (rst) begin 
            csr_inst <= 64'b0;  // Reset instruction count to 0
        end 
        else if (csr_cycle == 64'd1) begin
            csr_inst <= 64'd1;   // Initialize instruction count to 1 on first cycle
        end
        else if (pc_E != 32'b0 && ~AXI_stall)
            csr_inst <= csr_inst + 64'b1;        
    end

// Cycle counter
always_ff @(posedge clk or posedge rst) begin
    if (rst)
        csr_cycle <= 64'b0;
    else
        csr_cycle <= csr_cycle + 64'd1;
end

// CSR Write Logic
function automatic logic [31:0] csr_write_logic_A (
    input logic [31:0] csr, rs1_data, uimm,
    input logic [2:0] func3,
    input logic [4:0] rs1
);
    case (func3)
        CSRRW:  csr_write_logic_A = (rs1 == 5'b0) ? 32'b0 : {19'b0,rs1_data[12:11],3'b0,rs1_data[7],3'b0,rs1_data[3],3'b0};
        CSRRS:  csr_write_logic_A = (rs1 == 5'b0) ? 32'b0 : csr | {19'b0,rs1_data[12:11],3'b0,rs1_data[7],3'b0,rs1_data[3],3'b0};
        CSRRC:  csr_write_logic_A = (rs1 == 5'b0) ? 32'b0 : csr & ~{19'b0,rs1_data[12:11],3'b0,rs1_data[7],3'b0,rs1_data[3],3'b0};
        CSRRWI: csr_write_logic_A = (rs1 == 5'b0) ? 32'b0 : {19'b0,uimm[12:11],3'b0,uimm[7],3'b0,uimm[3],3'b0};
        CSRRSI: csr_write_logic_A = (rs1 == 5'b0) ? 32'b0 : csr | {19'b0,uimm[12:11],3'b0,uimm[7],3'b0,uimm[3],3'b0};
        CSRRCI: csr_write_logic_A = (rs1 == 5'b0) ? 32'b0 : csr & ~{19'b0,uimm[12:11],3'b0,uimm[7],3'b0,uimm[3],3'b0};
        default: csr_write_logic_A = 32'b0;
    endcase
endfunction

function automatic logic [31:0] csr_write_logic_B (
    input logic [31:0] csr, rs1_data, uimm,
    input logic [2:0] func3,
    input logic [4:0] rs1
);
    case (func3)
        CSRRW:  csr_write_logic_B = (rs1 == 5'b0) ? 32'b0 : rs1_data;
        CSRRS:  csr_write_logic_B = (rs1 == 5'b0) ? 32'b0 : csr | rs1_data;
        CSRRC:  csr_write_logic_B = (rs1 == 5'b0) ? 32'b0 : csr & ~ rs1_data;
        CSRRWI: csr_write_logic_B = (rs1 == 5'b0) ? 32'b0 : uimm;
        CSRRSI: csr_write_logic_B = (rs1 == 5'b0) ? 32'b0 : csr | uimm;
        CSRRCI: csr_write_logic_B = (rs1 == 5'b0) ? 32'b0 : csr & ~ uimm;
        default: csr_write_logic_B = 32'b0;
    endcase
endfunction

endmodule