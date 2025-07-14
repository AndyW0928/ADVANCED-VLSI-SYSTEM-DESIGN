// `include "../../src/AXI/WriteChannel/WriteArbiter.sv"
// `include "../../src/AXI/WriteChannel/WriteDecoder.sv"
// `include "../../src/AXI/WriteArbiter.sv"
// `include "../../src/AXI/WriteDecoder.sv"

module WriteAXI(
    input clk,
	input rst,
    
    // ======= Master =======

    // WRITE ADDRESS M1 (Data)
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	// WRITE DATA M1 (Data)
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	// WRITE RESPONSE M1 (Data)
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

    //WRITE ADDRESS M2 (DMA)
	input [`AXI_ID_BITS-1:0] AWID_M2,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M2,
	input [`AXI_LEN_BITS-1:0] AWLEN_M2,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M2,
	input [1:0] AWBURST_M2,
	input AWVALID_M2,
	output logic AWREADY_M2,
	
	//WRITE DATA M2 (DMA)
	input [`AXI_DATA_BITS-1:0] WDATA_M2,
	input [`AXI_STRB_BITS-1:0] WSTRB_M2,
	input WLAST_M2,
	input WVALID_M2,
	output logic WREADY_M2,
	
	//WRITE RESPONSE M2 (DMA)
	output logic [`AXI_ID_BITS-1:0] BID_M2,
	output logic [1:0] BRESP_M2,
	output logic BVALID_M2,
	input BREADY_M2,

    // ======= Slave =======

    // WRITE ADDRESS S0 (ROM)
	// output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	// output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	// output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	// output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	// output logic [1:0] AWBURST_S0,
	// output logic AWVALID_S0,
	// input AWREADY_S0,
	// WRITE DATA S0 (ROM)
	// output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	// output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	// output logic WLAST_S0,
	// output logic WVALID_S0,
	// input WREADY_S0,
	// WRITE RESPONSE S0 (ROM)
	// input [`AXI_IDS_BITS-1:0] BID_S0,
	// input [1:0] BRESP_S0,
	// input BVALID_S0,
	// output logic BREADY_S0,

	// WRITE ADDRESS S1 (IM SRAM)
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	// WRITE DATA S1 (IM SRAM)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	// WRITE RESPONSE S1 (IM SRAM)
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,

    // WRITE ADDRESS S2 (DM SRAM)
    output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	output logic [1:0] AWBURST_S2,
	output logic AWVALID_S2,
	input AWREADY_S2,
	// WRITE DATA S2 (DM SRAM)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	output logic WLAST_S2,
	output logic WVALID_S2,
	input WREADY_S2,
	// WRITE RESPONSE S2 (DM SRAM)
	input [`AXI_IDS_BITS-1:0] BID_S2,
	input [1:0] BRESP_S2,
	input BVALID_S2,
	output logic BREADY_S2,

	// WRITE ADDRESS S3 (DMA)
	output logic [`AXI_IDS_BITS-1:0] AWID_S3,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
	output logic [1:0] AWBURST_S3,
	output logic AWVALID_S3,
	input AWREADY_S3,
	// WRITE DATA S3 (DMA)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
	output logic WLAST_S3,
	output logic WVALID_S3,
	input WREADY_S3,
	// WRITE RESPONSE S3 (DMA)
	input [`AXI_IDS_BITS-1:0] BID_S3,
	input [1:0] BRESP_S3,
	input BVALID_S3,
	output logic BREADY_S3,

    /////WRITE ADDRESS S4 (WDT)/////
	output logic [`AXI_IDS_BITS-1:0] AWID_S4,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4,
	output logic [1:0] AWBURST_S4,
	output logic AWVALID_S4,
	input AWREADY_S4,
	// WRITE DATA S4
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
	output logic WLAST_S4,
	output logic WVALID_S4,
	input WREADY_S4,
	// WRITE RESPONSE S4
	input [`AXI_IDS_BITS-1:0] BID_S4,
	input [1:0] BRESP_S4,
	input BVALID_S4,
	output logic BREADY_S4,
	/////WRITE ADDRESS S5 (DRAM)/////
	output logic [`AXI_IDS_BITS-1:0] AWID_S5,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
	output logic [1:0] AWBURST_S5,
	output logic AWVALID_S5,
	input AWREADY_S5,
	// WRITE DATA S5
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
	output logic WLAST_S5,
	output logic WVALID_S5,
	input WREADY_S5,
	// WRITE RESPONSE S5
	input [`AXI_IDS_BITS-1:0] BID_S5,
	input [1:0] BRESP_S5,
	input BVALID_S5,
	output logic BREADY_S5 
);
    logic addressDone_reg;
    logic dataDone_reg;
    logic [`AXI_IDS_BITS-1:0] IDS_reg;
    logic addressDone;
    logic dataDone;

    logic                      AWVALID_wire;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_wire;
    logic [`AXI_ID_BITS-1:0]   AWID_wire;
    logic [1:0]                Arbiter_WADDR_Src;
    logic [1:0]                Arbiter_WDATA_Src;
    logic [1:0]                Arbiter_WRESP_Src;

    logic       AWREADY_wire;
    logic       done_wire;
    logic [2:0] Decoder_WADDR_Src;
    logic [2:0] Decoder_WDATA_Src;
    logic [2:0] Decoder_WRESP_Src;

    logic [`AXI_IDS_BITS-1:0] AWIDS;
	logic [`AXI_ADDR_BITS-1:0] AWADDR;
	logic [`AXI_LEN_BITS-1:0] AWLEN;
	logic [`AXI_SIZE_BITS-1:0] AWSIZE;
	logic [1:0] AWBURST;
	logic AWVALID;
	logic AWREADY;

	logic [`AXI_DATA_BITS-1:0] WDATA;
	logic [`AXI_STRB_BITS-1:0] WSTRB;
	logic WLAST;
	logic WVALID;
	logic WREADY;

    logic [`AXI_ID_BITS-1:0] BID;
	logic [1:0] BRESP;
	logic BVALID;
	logic BREADY;


    // Module
    WriteArbiter writeArbiter
    (
        .clk(clk),
        .rst(rst),
        // Master Write Signal
        .AWVALID_M1(AWVALID_M1),
        .AWADDR_M1(AWADDR_M1),
        .AWVALID_M2(AWVALID_M2),
        .AWADDR_M2(AWADDR_M2),
        // Signal to AXI & Siganl to Decoder
        .AWVALID(AWVALID_wire),
        .AWADDR(AWADDR_wire),
        .AWID(AWID_wire),
        // Decoder to Arbiter
        .AWREADY(AWREADY_wire),
        .done(done_wire),
        // Bridge Selection
        .WADDR_Src(Arbiter_WADDR_Src),
        .WDATA_Src(Arbiter_WDATA_Src),
        .WRESP_Src(Arbiter_WRESP_Src)
    );
    WriteDecoder writeDecoder
    (
        .clk(clk),
        .rst(rst),
        // Arbiter to Decoder
        .AWVALID(AWVALID_wire),
        .AWADDR(AWADDR_wire),
        // Decoder to Arbiter
        .AWREADY(AWREADY_wire),
        .done(done_wire),
        // Master Signal
        .BREADY(BREADY),
        // Slave Signal
        .AWREADY_S1(AWREADY_S1),
        .AWREADY_S2(AWREADY_S2),
        .AWREADY_S3(AWREADY_S3),
        .AWREADY_S4(AWREADY_S4),
        .AWREADY_S5(AWREADY_S5),
        .BVALID(BVALID),
        // Bridge Selection
        .WADDR_Src(Decoder_WADDR_Src),
        .WDATA_Src(Decoder_WDATA_Src),
        .WRESP_Src(Decoder_WRESP_Src)
    );

    // Wrong Address State Machine
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            addressDone_reg <= `FALSE;
            dataDone_reg <= `FALSE;
            IDS_reg <= 8'd0;
        end
        else if (done_wire)
        begin
            addressDone_reg <= `FALSE;
            dataDone_reg <= `FALSE;
            IDS_reg <= 8'd0;
        end
        else if (Decoder_WADDR_Src == `WRONGADDRESS || 
                 Decoder_WDATA_Src == `WRONGADDRESS || 
                 Decoder_WRESP_Src == `WRONGADDRESS)
        begin
            if (addressDone_reg == `FALSE && addressDone == `TRUE)
            begin
                addressDone_reg <= `TRUE;
                IDS_reg <= AWIDS;
            end
            else 
            begin
                addressDone_reg <= addressDone_reg;
            end
            if (dataDone_reg == `FALSE && dataDone == `TRUE)
            begin
                dataDone_reg <= `TRUE;
            end
            else 
            begin
                dataDone_reg <= dataDone_reg;
            end
        end
        else 
        begin
            addressDone_reg <= `FALSE;
            dataDone_reg <= `FALSE;
            IDS_reg <= 8'd0;
        end
    end

    // Write Address Channel
    always_comb
    begin
        AWREADY_M1 = 1'd0;
        AWREADY_M2 = 1'd0;

        case (Arbiter_WADDR_Src)
            `M1MUX:
            begin
                AWIDS = {AWID_wire, AWID_M1};
                AWADDR = AWADDR_wire;
                AWLEN = AWLEN_M1;
                AWSIZE = AWSIZE_M1;
                AWBURST = AWBURST_M1;
                AWVALID = AWVALID_wire;
                AWREADY_M1 = AWREADY;
            end
            `M2MUX:
            begin
                AWIDS = {AWID_wire, AWID_M2};
                AWADDR = AWADDR_wire;
                AWLEN = AWLEN_M2;
                AWSIZE = AWSIZE_M2;
                AWBURST = AWBURST_M2;
                AWVALID = AWVALID_wire;
                AWREADY_M2 = AWREADY;
            end
            default:
            begin
                AWIDS = 8'd0;
                AWADDR = 32'd0;
                AWLEN = 4'd0;
                AWSIZE = 3'd0;
                AWBURST = 2'd0;
                AWVALID = 1'd0;
                AWREADY_M1 = 1'd0;
                AWREADY_M2 = 1'd0;
            end
        endcase
    end


    // Write Address Channel
    always_comb 
    begin
        // WRITE S0 (ROM)
        // AWID_S0 = 8'd0;
        // AWADDR_S0 = 32'd0;
        // AWLEN_S0 = 4'd0;
        // AWSIZE_S0 = 3'd0;
        // AWBURST_S0 = 2'd0;
        // AWVALID_S0 = 1'd0;
        // WRITE S1 (IM SRAM)
        AWID_S1 = 8'd0;
        AWADDR_S1 = 32'd0;
        AWLEN_S1 = 4'd0;
        AWSIZE_S1 = 3'd0;
        AWBURST_S1 = 2'd0;
        AWVALID_S1 = 1'd0;
        // WRITE S2 (DM SRAM)
        AWID_S2 = 8'd0;
        AWADDR_S2 = 32'd0;
        AWLEN_S2 = 4'd0;
        AWSIZE_S2 = 3'd0;
        AWBURST_S2 = 2'd0;
        AWVALID_S2 = 1'd0;
        // WRITE S3 (DMA)
        AWID_S3 = 8'd0;
        AWADDR_S3 = 32'd0;
        AWLEN_S3 = 4'd0;
        AWSIZE_S3 = 3'd0;
        AWBURST_S3 = 2'd0;
        AWVALID_S3 = 1'd0;
        // WRITE S4 (WDT)
        AWID_S4 = 8'd0;
        AWADDR_S4 = 32'd0;
        AWLEN_S4 = 4'd0;
        AWSIZE_S4 = 3'd0;
        AWBURST_S4 = 2'd0;
        AWVALID_S4 = 1'd0;
        // WRITE S5 (DRAM)
        AWID_S5 = 8'd0;
        AWADDR_S5 = 32'd0;
        AWLEN_S5 = 4'd0;
        AWSIZE_S5 = 3'd0;
        AWBURST_S5 = 2'd0;
        AWVALID_S5 = 1'd0;        
        // Default AWREADY
        AWREADY = `FALSE;
        // Default Address Done
        addressDone = `FALSE;

        case (Decoder_WADDR_Src)
            // `S0MUX:
            // begin
            //     AWID_S0 = AWID;
            //     AWADDR_S0 = AWADDR;
            //     AWLEN_S0 = AWLEN;
            //     AWSIZE_S0 = AWSIZE;
            //     AWBURST_S0 = AWBURST;
            //     AWVALID_S0 = AWVALID;
            //     AWREADY = AWREADY_S0;
            // end
            `S1MUX:
            begin
                AWID_S1 = AWIDS;
                AWADDR_S1 = AWADDR;
                AWLEN_S1 = AWLEN;
                AWSIZE_S1 = AWSIZE;
                AWBURST_S1 = AWBURST;
                AWVALID_S1 = AWVALID;
                AWREADY = AWREADY_S1;
            end
            `S2MUX:
            begin
                AWID_S2 = AWIDS;
                AWADDR_S2 = AWADDR;
                AWLEN_S2 = AWLEN;
                AWSIZE_S2 = AWSIZE;
                AWBURST_S2 = AWBURST;
                AWVALID_S2 = AWVALID;
                AWREADY = AWREADY_S2;
            end
            `S3MUX:
            begin
                AWID_S3 = AWIDS;
                AWADDR_S3 = AWADDR;
                AWLEN_S3 = AWLEN;
                AWSIZE_S3 = AWSIZE;
                AWBURST_S3 = AWBURST;
                AWVALID_S3 = AWVALID;
                AWREADY = AWREADY_S3;
            end
            `S4MUX:
            begin
                AWID_S4 = AWIDS;
                AWADDR_S4 = AWADDR;
                AWLEN_S4 = AWLEN;
                AWSIZE_S4 = AWSIZE;
                AWBURST_S4 = AWBURST;
                AWVALID_S4 = AWVALID;
                AWREADY = AWREADY_S4;
            end
            `S5MUX:
            begin
                AWID_S5 = AWIDS;
                AWADDR_S5 = AWADDR;
                AWLEN_S5 = AWLEN;
                AWSIZE_S5 = AWSIZE;
                AWBURST_S5 = AWBURST;
                AWVALID_S5 = AWVALID;
                AWREADY = AWREADY_S5;
            end
            `WRONGADDRESS:
            begin
                // Address Channel Handshake
                if (addressDone_reg == `FALSE)
                begin
                    AWREADY = `TRUE;
                    if (AWVALID)
                    begin
                        addressDone = `TRUE;
                    end
                    else
                    begin
                        addressDone = `FALSE;
                    end
                end
                else
                begin
                    AWREADY = `FALSE;
                    addressDone = `FALSE;
                end
            end
            default:
            begin
                AWREADY = `FALSE;
                addressDone = `FALSE;
            end
        endcase
    end

    // Write Data Channel
    always_comb 
    begin
        WREADY_M1 = 1'd0;
        WREADY_M2 = 1'd0;

        case (Arbiter_WDATA_Src)
            `M1MUX:
            begin
                WDATA = WDATA_M1;
                WSTRB = WSTRB_M1;
                WLAST = WLAST_M1;
                WVALID = WVALID_M1;
                WREADY_M1 = WREADY;
            end
            `M2MUX:
            begin
                WDATA = WDATA_M2;
                WSTRB = WSTRB_M2;
                WLAST = WLAST_M2;
                WVALID = WVALID_M2;
                WREADY_M2 = WREADY;
            end
            default:
            begin
                WDATA = 32'd0;
                WSTRB = 4'd0;
                WLAST = 1'd0;
                WVALID = 1'd0;
                WREADY_M1 = 1'd0;
                WREADY_M2 = 1'd0;
            end
        endcase
    end


    // Write Data Channel
 always_comb 
    begin
        // WRITE S0 (ROM)
        // WDATA_S0 = 32'd0;
        // WSTRB_S0 = 4'd0;
        // WLAST_S0 = 1'd0;
        // WVALID_S0 = 1'd0;
        // WRITE S1 (IM SRAM)
        WDATA_S1 = 32'd0;
        WSTRB_S1 = 4'd0;
        WLAST_S1 = 1'd0;
        WVALID_S1 = 1'd0;
        // WRITE S2 (DM SRAM)
        WDATA_S2 = 32'd0;
        WSTRB_S2 = 4'd0;
        WLAST_S2 = 1'd0;
        WVALID_S2 = 1'd0;
        // WRITE S3 (DMA)
        WDATA_S3 = 32'd0;
        WSTRB_S3 = 4'd0;
        WLAST_S3 = 1'd0;
        WVALID_S3 = 1'd0;
        // WRITE S4 (WDT)
        WDATA_S4 = 32'd0;
        WSTRB_S4 = 4'd0;
        WLAST_S4 = 1'd0;
        WVALID_S4 = 1'd0;
        // WRITE S5 (DRAM)
        WDATA_S5 = 32'd0;
        WSTRB_S5 = 4'd0;
        WLAST_S5 = 1'd0;
        WVALID_S5 = 1'd0;        
        // Default AWREADY
        WREADY = `FALSE;
        // Default Data Done
        dataDone = `FALSE;

        case (Decoder_WDATA_Src)
            // `S0MUX:
            // begin
            //     WDATA_S0 = WDATA;
            //     WSTRB_S0 = WSTRB;
            //     WLAST_S0 = WLAST;
            //     WVALID_S0 = WVALID;
            //     WREADY = WREADY_S0;
            // end
            `S1MUX:
            begin
                WDATA_S1 = WDATA;
                WSTRB_S1 = WSTRB;
                WLAST_S1 = WLAST;
                WVALID_S1 = WVALID;
                WREADY = WREADY_S1;
            end
            `S2MUX:
            begin
                WDATA_S2 = WDATA;
                WSTRB_S2 = WSTRB;
                WLAST_S2 = WLAST;
                WVALID_S2 = WVALID;
                WREADY = WREADY_S2;
            end
            `S3MUX:
            begin
                WDATA_S3 = WDATA;
                WSTRB_S3 = WSTRB;
                WLAST_S3 = WLAST;
                WVALID_S3 = WVALID;
                WREADY = WREADY_S3;
            end
            `S4MUX:
            begin
                WDATA_S4 = WDATA;
                WSTRB_S4 = WSTRB;
                WLAST_S4 = WLAST;
                WVALID_S4 = WVALID;
                WREADY = WREADY_S4;
            end
            `S5MUX:
            begin
                WDATA_S5 = WDATA;
                WSTRB_S5 = WSTRB;
                WLAST_S5 = WLAST;
                WVALID_S5 = WVALID;
                WREADY = WREADY_S5;
            end
            `WRONGADDRESS:
            begin
                // Data Channel Handshake
                if (dataDone_reg == `FALSE)
                begin
                    WREADY = `TRUE;
                    if (WLAST && WVALID)
                    begin
                        dataDone = `TRUE;
                    end
                    else 
                    begin
                        dataDone = `FALSE;
                    end
                end
                else 
                begin
                    WREADY = `FALSE;
                    dataDone = `FALSE;
                end
            end
            default:
            begin
                WREADY = `FALSE;
                dataDone = `FALSE;
            end
        endcase
    end


 // Write Response Channel
    // Slave MUX
    always_comb 
    begin
        // Default BID
        BID = 4'd0;
        // Default BRESP
        BRESP = `AXI_RESP_OKAY;
        // Default BVALID
        BVALID = `FALSE;

        // WRITE S0 (ROM)
        // BREADY_S0 = `FALSE;

        // WRITE S1 (IM SRAM)
        BREADY_S1 = `FALSE;
        // WRITE S2 (DM SRAM)
        BREADY_S2 = `FALSE;
        // WRITE S3 (DMA)
        BREADY_S3 = `FALSE;
        // WRITE S4 (WDT)
        BREADY_S4 = `FALSE;
        // WRITE S5 (DRAM)
        BREADY_S5 = `FALSE;

        case (Decoder_WRESP_Src)
            // `S0MUX:
            // begin
            //     BID = BID_S0[3:0];
            //     BRESP = BRESP_S0;
            //     BVALID = BVALID_S0;
            //     BREADY_S0 = BREADY;
            // end
            `S1MUX:
            begin
                BID = BID_S1[3:0];
                BRESP = BRESP_S1;
                BVALID = BVALID_S1;
                BREADY_S1 = BREADY;
            end
            `S2MUX:
            begin
                BID = BID_S2[3:0];
                BRESP = BRESP_S2;
                BVALID = BVALID_S2;
                BREADY_S2 = BREADY;
            end
            `S3MUX:
            begin
                BID = BID_S3[3:0];
                BRESP = BRESP_S3;
                BVALID = BVALID_S3;
                BREADY_S3 = BREADY;
            end
            `S4MUX:
            begin
                BID = BID_S4[3:0];
                BRESP = BRESP_S4;
                BVALID = BVALID_S4;
                BREADY_S4 = BREADY;
            end
            `S5MUX:
            begin
                BID = BID_S5[3:0];
                BRESP = BRESP_S5;
                BVALID = BVALID_S5;
                BREADY_S5 = BREADY;
            end
            `WRONGADDRESS:
            begin
                if (addressDone_reg && dataDone_reg)
                begin
                    BID = IDS_reg[3:0];
                    BRESP = `AXI_RESP_DECERR;
                    BVALID = `TRUE;
                end
                else 
                begin
                    BID = 4'd0;
                    BRESP = `AXI_RESP_OKAY;
                    BVALID = `FALSE;
                end
            end
            default:
            begin
                BID = 4'd0;
                BRESP = `AXI_RESP_OKAY;
                BVALID = `FALSE;
            end
        endcase
    end


    // Write Response Channel
    // Master MUX
    always_comb 
    begin
        BID_M1 = 4'd0;
        BRESP_M1 = 2'd0;
        BVALID_M1 = 1'd0;
        BID_M2 = 4'd0;
        BRESP_M2 = 2'd0;
        BVALID_M2 = 1'd0;

        case (Arbiter_WRESP_Src)
            `M1MUX:
            begin
                BID_M1 = BID;
                BRESP_M1 = BRESP;
                BVALID_M1 = BVALID;

                BREADY = BREADY_M1;
            end
            `M2MUX:
            begin
                BID_M2 = BID;
                BRESP_M2 = BRESP;
                BVALID_M2 = BVALID;

                BREADY = BREADY_M2;
            end
            default:
            begin
                BID_M1 = 4'd0;
                BRESP_M1 = 2'd0;
                BVALID_M1 = 1'd0;
                BID_M2 = 4'd0;
                BRESP_M2 = 2'd0;
                BVALID_M2 = 1'd0;

                BREADY = 1'd0;
            end
        endcase
    end

endmodule