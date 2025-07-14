// `include "../../src/AXI/ReadChannel/ReadArbiter.sv"
// `include "../../src/AXI/ReadChannel/ReadDecoder.sv"
// `include "../../src/AXI/ReadArbiter.sv"
// `include "../../src/AXI/ReadDecoder.sv"

module ReadAXI(
    input clk,
	input rst,

    // ======= Master =======

	// READ ADDRESS M0 (Instruction)
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic ARREADY_M0,
	// READ DATA M0 (Instruction)
	output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,

	// READ ADDRESS M1 (Data)
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic ARREADY_M1,
	// READ DATA M1 (Data)
	output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,

	//READ ADDRESS M2 (DMA)
	input [`AXI_ID_BITS-1:0] ARID_M2,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M2,
	input [`AXI_LEN_BITS-1:0] ARLEN_M2,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M2,
	input [1:0] ARBURST_M2,
	input ARVALID_M2,
	output logic ARREADY_M2,
	
	//READ DATA M2 (DMA)
	output logic [`AXI_ID_BITS-1:0] RID_M2,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M2,
	output logic [1:0] RRESP_M2,
	output logic RLAST_M2,
	output logic RVALID_M2,
	input RREADY_M2,
    // ======= Slave =======

    // READ ADDRESS S0 (ROM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	// READ DATA S0 (ROM)
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,

	// READ ADDRESS S1 (IM SRAM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	// READ DATA S1 (IM SRAM)
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1,
	
	// READ ADDRESS S2 (DM SRAM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S2,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
	output logic [1:0] ARBURST_S2,
	output logic ARVALID_S2,
	input ARREADY_S2,
	// READ DATA S2 (DM SRAM)
	input [`AXI_IDS_BITS-1:0] RID_S2,
	input [`AXI_DATA_BITS-1:0] RDATA_S2,
	input [1:0] RRESP_S2,
	input RLAST_S2,
	input RVALID_S2,
	output logic RREADY_S2,

	// READ ADDRESS S3 (DMA)
	output logic [`AXI_IDS_BITS-1:0] ARID_S3,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
	output logic [1:0] ARBURST_S3,
	output logic ARVALID_S3,
	input ARREADY_S3,
	// READ DATA S3 (DMA)
	input [`AXI_IDS_BITS-1:0] RID_S3,
	input [`AXI_DATA_BITS-1:0] RDATA_S3,
	input [1:0] RRESP_S3,
	input RLAST_S3,
	input RVALID_S3,
	output logic RREADY_S3,

	///// READ ADDRESS S4 (WDT)/////
	output logic [`AXI_IDS_BITS-1:0] ARID_S4,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4,
	output logic [1:0] ARBURST_S4,
	output logic ARVALID_S4,
	input ARREADY_S4,
	// READ DATA S4
	input [`AXI_IDS_BITS-1:0] RID_S4,
	input [`AXI_DATA_BITS-1:0] RDATA_S4,
	input [1:0] RRESP_S4,
	input RLAST_S4,
	input RVALID_S4,
	output logic RREADY_S4,
	///// READ ADDRESS S5 (DRAM)/////
	output logic [`AXI_IDS_BITS-1:0] ARID_S5,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
	output logic [1:0] ARBURST_S5,
	output logic ARVALID_S5,
	input ARREADY_S5,
	// READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S5,
	input [`AXI_DATA_BITS-1:0] RDATA_S5,
	input [1:0] RRESP_S5,
	input RLAST_S5,
	input RVALID_S5,
	output logic RREADY_S5  
);
    logic addr_done_reg;
    logic [`AXI_IDS_BITS-1:0] ARIDS_reg;
    logic [`AXI_LEN_BITS-1:0] ARLEN_reg;
    logic addr_done;

    // Read Arbiter
    logic                      ARVALID_wire;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_wire;
    logic [`AXI_ID_BITS-1:0]   ARID_wire;
    logic [1:0]                Master_RADDR_Src;
    logic [1:0]                Master_RDATA_Src;
    // Read Decoder
    logic       ARREADY_wire;
    logic       done_wire;
    logic [2:0] Slave_RADDR_Src;
    logic [2:0] Slave_RDATA_Src;
    // Bridge
    // Read Address Channel 
    logic [`AXI_IDS_BITS-1:0] ARIDS;
	logic [`AXI_ADDR_BITS-1:0] ARADDR;
	logic [`AXI_LEN_BITS-1:0] ARLEN;
	logic [`AXI_SIZE_BITS-1:0] ARSIZE;
	logic [1:0] ARBURST;
	logic ARVALID;
	logic ARREADY;
	// Read Data Channel 
	logic [`AXI_ID_BITS-1:0] RID;
	logic [`AXI_DATA_BITS-1:0] RDATA;
	logic [1:0] RRESP;
	logic RLAST;
	logic RVALID;
	logic RREADY;

    // Module
    ReadArbiter readArbiter
    (
        .clk(clk),
        .rst(rst),
        // Master Read Signal
        .ARVALID_M0(ARVALID_M0),
        .ARADDR_M0(ARADDR_M0),
        .ARVALID_M1(ARVALID_M1),
        .ARADDR_M1(ARADDR_M1),
        .ARVALID_M2(ARVALID_M2),
        .ARADDR_M2(ARADDR_M2),
        // Signal to AXI & Siganl to Decoder
        .ARVALID(ARVALID_wire),
        .ARADDR(ARADDR_wire),
        .ARID(ARID_wire),
        // Decoder to Arbiter
        .ARREADY(ARREADY_wire),
        .done(done_wire),
        // Bridge Selection
        .RADDR_Src(Master_RADDR_Src),
        .RDATA_Src(Master_RDATA_Src)
    );
    ReadDecoder readDecoder
    (
        .clk(clk),
        .rst(rst),
        // Arbiter to Decoder
        .ARVALID(ARVALID_wire),
        .ARADDR(ARADDR_wire),
        // Decoder to Arbiter
        .ARREADY(ARREADY_wire),
        .done(done_wire),
        // Master Signal
        .RREADY(RREADY),
        // Slave Signal
        .ARREADY_S0(ARREADY_S0),
        .ARREADY_S1(ARREADY_S1),
        .ARREADY_S2(ARREADY_S2),
        .ARREADY_S3(ARREADY_S3),
        .ARREADY_S4(ARREADY_S4),
        .ARREADY_S5(ARREADY_S5),                
        .RVALID(RVALID),
        .RLAST(RLAST),
        // Bridge Selection
        .RADDR_Src(Slave_RADDR_Src),
        .RDATA_Src(Slave_RDATA_Src)
    );

    // Wrong Address State Machine
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            addr_done_reg <= 1'b0;
            ARIDS_reg <= 8'd0;
            ARLEN_reg <= 4'd0;
        end
        else if (done_wire)
        begin
            addr_done_reg <= 1'b0;
            ARIDS_reg <= 8'd0;
            ARLEN_reg <= 4'd0;
        end
        else if (Slave_RADDR_Src == `WRONGADDRESS || 
                 Slave_RDATA_Src == `WRONGADDRESS)
        begin
            if (addr_done_reg == 1'b0 && addr_done == 1'b1)
            begin
                addr_done_reg <= 1'b1;
                ARIDS_reg <= ARIDS;
                ARLEN_reg <= ARLEN;
            end
            else 
            begin
                addr_done_reg <= addr_done_reg;
                if (ARLEN_reg != 4'd0 && RREADY)
                begin
                    ARLEN_reg <= ARLEN_reg - 4'b1;
                end
                else 
                begin
                    ARLEN_reg <= ARLEN_reg;
                end
            end
        end
        else 
        begin
            addr_done_reg <= 1'b0;
            ARIDS_reg <= 8'd0;
            ARLEN_reg <= 4'd0;
        end
    end

    // Read Address Channel
    always_comb
    begin
        // Default values
        ARIDS = 8'd0;
        ARADDR = 32'd0;
        ARLEN = 4'd0;
        ARSIZE = 3'd0;
        ARBURST = 2'd0;
        ARVALID = 1'd0;
        ARREADY_M0 = 1'd0;
        ARREADY_M1 = 1'd0;
        ARREADY_M2 = 1'd0;

        case (Master_RADDR_Src)
            `M0MUX:
            begin
                ARIDS = {ARID_wire, ARID_M0};
                ARADDR = ARADDR_wire;
                ARLEN = ARLEN_M0;
                ARSIZE = ARSIZE_M0;
                ARBURST = ARBURST_M0;
                ARVALID = ARVALID_wire;
                ARREADY_M0 = ARREADY;
            end

            `M1MUX:
            begin
                ARIDS = {ARID_wire, ARID_M1};
                ARADDR = ARADDR_wire;
                ARLEN = ARLEN_M1;
                ARSIZE = ARSIZE_M1;
                ARBURST = ARBURST_M1;
                ARVALID = ARVALID_wire;
                ARREADY_M1 = ARREADY;
            end

            `M2MUX:
            begin
                ARIDS = {ARID_wire, ARID_M2};
                ARADDR = ARADDR_wire;
                ARLEN = ARLEN_M2;
                ARSIZE = ARSIZE_M2;
                ARBURST = ARBURST_M2;
                ARVALID = ARVALID_wire;
                ARREADY_M2 = ARREADY;
            end
            default:
            begin
                ARIDS = 8'd0;
                ARADDR = 32'd0;
                ARLEN = 4'd0;
                ARSIZE = 3'd0;
                ARBURST = 2'd0;
                ARVALID = 1'd0;
                ARREADY_M0 = 1'd0;
                ARREADY_M1 = 1'd0;
                ARREADY_M2 = 1'd0;
            end
        endcase
    end

    // Read Address Channel
    always_comb
    begin
        // READ S0 (ROM)
        ARID_S0 = 8'd0;
        ARADDR_S0 = 32'd0;
        ARLEN_S0 = 4'd0;
        ARSIZE_S0 = 3'd0;
        ARBURST_S0 = 2'd0;
        ARVALID_S0 = 1'd0;
        // READ S1 (IM SRAM)
        ARID_S1 = 8'd0;
        ARADDR_S1 = 32'd0;
        ARLEN_S1 = 4'd0;
        ARSIZE_S1 = 3'd0;
        ARBURST_S1 = 2'd0;
        ARVALID_S1 = 1'd0;
        // READ S2 (DM SRAM)
        ARID_S2 = 8'd0;
        ARADDR_S2 = 32'd0;
        ARLEN_S2 = 4'd0;
        ARSIZE_S2 = 3'd0;
        ARBURST_S2 = 2'd0;
        ARVALID_S2 = 1'd0;
        // READ S3 (DMA)
        ARID_S3 = 8'd0;
        ARADDR_S3 = 32'd0;
        ARLEN_S3 = 4'd0;
        ARSIZE_S3 = 3'd0;
        ARBURST_S3 = 2'd0;
        ARVALID_S3 = 1'd0;
        // READ S4 (WDT)
        ARID_S4 = 8'd0;
        ARADDR_S4 = 32'd0;
        ARLEN_S4 = 4'd0;
        ARSIZE_S4 = 3'd0;
        ARBURST_S4 = 2'd0;
        ARVALID_S4 = 1'd0;
        // READ S5 (DRAM)
        ARID_S5 = 8'd0;
        ARADDR_S5 = 32'd0;
        ARLEN_S5 = 4'd0;
        ARSIZE_S5 = 3'd0;
        ARBURST_S5 = 2'd0;
        ARVALID_S5 = 1'd0;        
        // Default ARREADY
        ARREADY = `FALSE;
        // Default Address Done
        addr_done = `FALSE;

        case (Slave_RADDR_Src)
            `S0MUX:
            begin
                ARID_S0 = ARIDS;
                ARADDR_S0 = ARADDR;
                ARLEN_S0 = ARLEN;
                ARSIZE_S0 = ARSIZE;
                ARBURST_S0 = ARBURST;
                ARVALID_S0 = ARVALID;
                ARREADY = ARREADY_S0;
            end

            `S1MUX:
            begin
                ARID_S1 = ARIDS;
                ARADDR_S1 = ARADDR;
                ARLEN_S1 = ARLEN;
                ARSIZE_S1 = ARSIZE;
                ARBURST_S1 = ARBURST;
                ARVALID_S1 = ARVALID;
                ARREADY = ARREADY_S1;
            end

            `S2MUX:
            begin
                ARID_S2 = ARIDS;
                ARADDR_S2 = ARADDR;
                ARLEN_S2 = ARLEN;
                ARSIZE_S2 = ARSIZE;
                ARBURST_S2 = ARBURST;
                ARVALID_S2 = ARVALID;
                ARREADY = ARREADY_S2;
            end

            `S3MUX:
            begin
                ARID_S3 = ARIDS;
                ARADDR_S3 = ARADDR;
                ARLEN_S3 = ARLEN;
                ARSIZE_S3 = ARSIZE;
                ARBURST_S3 = ARBURST;
                ARVALID_S3 = ARVALID;
                ARREADY = ARREADY_S3;
            end

            `S4MUX:
            begin
                ARID_S4 = ARIDS;
                ARADDR_S4 = ARADDR;
                ARLEN_S4 = ARLEN;
                ARSIZE_S4 = ARSIZE;
                ARBURST_S4 = ARBURST;
                ARVALID_S4 = ARVALID;
                ARREADY = ARREADY_S4;
            end

            `S5MUX:
            begin
                ARID_S5 = ARIDS;
                ARADDR_S5 = ARADDR;
                ARLEN_S5 = ARLEN;
                ARSIZE_S5 = ARSIZE;
                ARBURST_S5 = ARBURST;
                ARVALID_S5 = ARVALID;
                ARREADY = ARREADY_S5;
            end

            `WRONGADDRESS:
            begin
                // Address Channel Handshake
                if (addr_done_reg == `FALSE)
                begin
                    ARREADY = `TRUE;
                    addr_done = (ARVALID) ? `TRUE : `FALSE;
                end
                else
                begin
                    ARREADY = `FALSE;
                    addr_done = `FALSE;
                end
            end

            default:
            begin
                // Defaults are already applied at the beginning of the block
            end
        endcase
    end

// Read Data Channel
    // Slave MUX
    always_comb 
    begin
        // Default RID
        RID = 4'd0;
        // Default RDATA
        RDATA = 32'd0;
        // Default RRESP
        RRESP = `AXI_RESP_OKAY;
        // Default RLAST
        RLAST = `FALSE;
        // Default RVALID
        RVALID = `FALSE;
        // READ S0 (ROM)
        RREADY_S0 = `FALSE;
        // READ S1 (IM SRAM)
        RREADY_S1 = `FALSE;
        // READ S2 (DM SRAM)
        RREADY_S2 = `FALSE;
        // READ S3 (DMA)
        RREADY_S3 = `FALSE;
        // READ S4 (WDT)
        RREADY_S4 = `FALSE;
        // READ S5 (DRAM)
        RREADY_S5 = `FALSE;
        case (Slave_RDATA_Src)
            `S0MUX:
            begin
                RID = RID_S0[3:0];
                RDATA = RDATA_S0;
                RRESP = RRESP_S0;
                RLAST = RLAST_S0;
                RVALID = RVALID_S0;
                RREADY_S0 = RREADY;
            end

            `S1MUX:
            begin
                RID = RID_S1[3:0];
                RDATA = RDATA_S1;
                RRESP = RRESP_S1;
                RLAST = RLAST_S1;
                RVALID = RVALID_S1;
                RREADY_S1 = RREADY;
            end

            `S2MUX:
            begin
                RID = RID_S2[3:0];
                RDATA = RDATA_S2;
                RRESP = RRESP_S2;
                RLAST = RLAST_S2;
                RVALID = RVALID_S2;
                RREADY_S2 = RREADY;
            end

            `S3MUX:
            begin
                RID = RID_S3[3:0];
                RDATA = RDATA_S3;
                RRESP = RRESP_S3;
                RLAST = RLAST_S3;
                RVALID = RVALID_S3;
                RREADY_S3 = RREADY;
            end

            `S4MUX:
            begin
                RID = RID_S4[3:0];
                RDATA = RDATA_S4;
                RRESP = RRESP_S4;
                RLAST = RLAST_S4;
                RVALID = RVALID_S4;
                RREADY_S4 = RREADY;
            end

            `S5MUX:
            begin
                RID = RID_S5[3:0];
                RDATA = RDATA_S5;
                RRESP = RRESP_S5;
                RLAST = RLAST_S5;
                RVALID = RVALID_S5;
                RREADY_S5 = RREADY;
            end

            `WRONGADDRESS:
            begin
                if (addr_done_reg)
                begin
                    RID = ARIDS_reg[3:0];
                    RDATA = 32'd0;
                    RRESP = `AXI_RESP_DECERR;
                    RLAST = (ARLEN_reg == 4'd0) ? `TRUE : `FALSE;
                    RVALID = `TRUE;
                end
                else
                begin
                    RID = 4'd0;
                    RDATA = 32'd0;
                    RRESP = `AXI_RESP_OKAY;
                    RLAST = `FALSE;
                    RVALID = `FALSE;
                end
            end

            default:
            begin
                // Defaults are already set at the beginning of the block
            end
        endcase
    end

    // Read Data Channel
    always_comb
    begin
        // Default values for all masters
        RID_M0 = 4'd0;
        RDATA_M0 = 32'd0;
        RRESP_M0 = 2'd0;
        RLAST_M0 = 1'd0;
        RVALID_M0 = 1'd0;

        RID_M1 = 4'd0;
        RDATA_M1 = 32'd0;
        RRESP_M1 = 2'd0;
        RLAST_M1 = 1'd0;
        RVALID_M1 = 1'd0;

        RID_M2 = 4'd0;
        RDATA_M2 = 32'd0;
        RRESP_M2 = 2'd0;
        RLAST_M2 = 1'd0;
        RVALID_M2 = 1'd0;

        // Default value for RREADY
        RREADY = 1'd0;

        // Select active master based on Master_RDATA_Src
        case (Master_RDATA_Src)
            `M0MUX: begin
                RID_M0 = RID;
                RDATA_M0 = RDATA;
                RRESP_M0 = RRESP;
                RLAST_M0 = RLAST;
                RVALID_M0 = RVALID;
                RREADY = RREADY_M0;
            end

            `M1MUX: begin
                RID_M1 = RID;
                RDATA_M1 = RDATA;
                RRESP_M1 = RRESP;
                RLAST_M1 = RLAST;
                RVALID_M1 = RVALID;
                RREADY = RREADY_M1;
            end

            `M2MUX: begin
                RID_M2 = RID;
                RDATA_M2 = RDATA;
                RRESP_M2 = RRESP;
                RLAST_M2 = RLAST;
                RVALID_M2 = RVALID;
                RREADY = RREADY_M2;
            end

            default: begin
                // Default behavior when no valid Master_RDATA_Src is selected
            end
        endcase
    end


endmodule
