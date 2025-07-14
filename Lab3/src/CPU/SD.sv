// Store Data
module SD (
    input  logic [2:0]  EX_MEM_memwrite,  // Memory write type signal
    input  logic [1:0]  last2,             // Last 2 bits of the address
    input  logic [31:0] EX_MEM_write_data,// Data to write
    output logic        DM_WEB,           // Write enable to SRAM
    // output logic [31:0] DM_BWEB,          // Byte write enable mask(SRAM)
    output logic [3:0] DM_BWEB,          // Byte write enable mask(AXI)
    output logic [31:0] DM_DI             // Data input to SRAM
);

   always_comb begin : Store_Data
        // Default to read mode (no write)
        DM_WEB = 1'b1;
        DM_BWEB = 4'd0;
        DM_DI = 32'd0;
        
        // If memory write is enabled
        if (|EX_MEM_memwrite) begin
            DM_WEB = 1'b0;  // Enable SRAM write
            case (EX_MEM_memwrite)
                3'b111: begin  : SD_Store_Word // SW (Store Word)
                    // Select bytes to write based on last2 (address bits)
                    case(last2)
                        2'b01: begin
                            // DM_BWEB = 32'h0000_00FF;
                            // DM_BWEB = 4'b0001;
                            DM_BWEB = 4'b1110;
                            DM_DI = {EX_MEM_write_data[23:0], 8'b0};
                        end
                        2'b10: begin
                            // DM_BWEB = 32'h0000_FFFF;
                            // DM_BWEB = 4'b0011;
                            DM_BWEB = 4'b1100;
                            DM_DI = {EX_MEM_write_data[15:0], 16'b0};
                        end
                        2'b11: begin
                            // DM_BWEB = 32'h00FF_FFFF;
                            // DM_BWEB = 4'b0111;
                            DM_BWEB = 4'b1000;
                            DM_DI = {EX_MEM_write_data[7:0], 24'b0};
                        end
                        default: begin
                            // DM_BWEB = 32'h0000_0000;
                            // DM_BWEB = 4'b0000;
                            DM_BWEB = 4'b1111;
                            DM_DI = EX_MEM_write_data;
                        end
                    endcase
                end

                3'b011: begin  : SD_Store_Halfword // SH (Store Halfword)
                    case(last2)
                        2'b01: begin
                            // DM_BWEB = 32'hFF00_00FF;
                            // DM_BWEB = 4'b1001;
                            DM_BWEB = 4'b0110;
                            DM_DI = {EX_MEM_write_data[23:0], 8'b0};
                        end
                        2'b10: begin
                            // DM_BWEB = 32'h0000_FFFF;
                            // DM_BWEB = 4'b0011;
                            DM_BWEB = 4'b1100;
                            DM_DI = {EX_MEM_write_data[15:0], 16'b0};
                        end
                        2'b11: begin
                            // DM_BWEB = 32'h00FF_FFFF;
                            // DM_BWEB = 4'b0111;
                            DM_BWEB = 4'b1000;
                            DM_DI = {EX_MEM_write_data[7:0], 24'b0};
                        end
                        default: begin
                            // DM_BWEB = 32'hFFFF_0000;
                            // DM_BWEB = 4'b1100;
                            DM_BWEB = 4'b0011;
                            DM_DI = EX_MEM_write_data;
                        end
                    endcase
                end

                3'b001: begin   : SD_Store_Byte // SB (Store Byte)
                    case(last2)
                        2'b01: begin
                            // DM_BWEB = 32'hFFFF_00FF;
                            // DM_BWEB = 4'b1101;
                            DM_BWEB = 4'b0010;
                            DM_DI = {EX_MEM_write_data[23:0], 8'b0};
                        end
                        2'b10: begin
                            // DM_BWEB = 32'hFF00_FFFF;
                            // DM_BWEB = 4'b1011;
                            DM_BWEB = 4'b0100;
                            DM_DI = {EX_MEM_write_data[15:0], 16'b0};
                        end
                        2'b11: begin
                            // DM_BWEB = 32'h00FF_FFFF;
                            // DM_BWEB = 4'b0111;
                            DM_BWEB = 4'b1000;
                            DM_DI = {EX_MEM_write_data[7:0], 24'b0};
                        end
                        default: begin
                            // DM_BWEB = 32'hFFFF_FF00;
                            // DM_BWEB = 4'b1110;
                            DM_BWEB = 4'b0001;
                            DM_DI = EX_MEM_write_data;
                        end
                    endcase
                end
                
                default: begin 
                    // DM_BWEB = 32'hFFFF_FFFF;  // Disable all writes
                    DM_BWEB = 4'b0000;
                    DM_DI = 32'd0;
                end
            endcase
        end 
    end
endmodule
