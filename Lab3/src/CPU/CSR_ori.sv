// Control and Status Register (CSR) Module
module CSR ( 
    input clk,                  // Clock signal
    input rst,                  // Reset signal
    input func5_sub,            // Used to distinguish whether to read upper or lower part of the register
    input CSR_rdinst,           // Used to distinguish between CSR_RDINSTRET or CSR_RDCYCLE
    input [31:0] ID_EX_pc,      // The program counter value from the ID/EX pipeline register
    output logic [31:0] csr_out, // Output for the CSR value
    input stall_CPU,
    input stall_hazard,
    input branch_taken
);

    // Define constants for CSR read instructions
    localparam  RDINSTRETH = 2'b11,   // Read the upper 32 bits of executed instruction count
                RDINSTRET  = 2'b01,   // Read the lower 32 bits of executed instruction count
                RDCYCLEH   = 2'b10,   // Read the upper 32 bits of clock cycle count
                RDCYCLE    = 2'b00;   // Read the lower 32 bits of clock cycle count

    // Internal 64-bit registers to store the cycle and instruction count values
    logic [63:0] CSR_cycle;   // Stores the count of clock cycles since reset
    logic [63:0] CSR_instret; // Stores the count of executed instructions

    // Always block to update the cycle count on each clock cycle
    always_ff @(posedge clk or posedge rst) begin : CSR_cycles
        if (rst) begin 
            CSR_cycle <= 64'b0;  // Reset cycle count to 0
        end
        else begin
            CSR_cycle <= CSR_cycle + 64'b1;  // Increment cycle count on each clock cycle
        end
    end

    // Always block to update the instruction count on each clock cycle
    always_ff @(posedge clk or posedge rst) begin : CSR_instrets
        if (rst) begin 
            CSR_instret <= 64'b0;  // Reset instruction count to 0
        end 
        else if (CSR_cycle == 64'd1) begin
            CSR_instret <= 64'd1;   // Initialize instruction count to 1 on first cycle
        end
        else if (ID_EX_pc == 32'b0 || stall_CPU /*|| stall_hazard|| branch_taken*/) begin
             CSR_instret <= CSR_instret ;
        end
        else  begin
            CSR_instret <= CSR_instret + 64'b1; 
        end
    end

    // Select the appropriate CSR value based on the control signals func5_sub and CSR_rdinst
    always_comb begin : CSR_out
        case ({func5_sub, CSR_rdinst})
            RDINSTRETH: csr_out = CSR_instret[63:32]; // Read the upper 32 bits of instruction count
            RDINSTRET : csr_out = CSR_instret[31:0];  // Read the lower 32 bits of instruction count
            RDCYCLEH  : csr_out = CSR_cycle[63:32];   // Read the upper 32 bits of clock cycle count
            RDCYCLE   : csr_out = CSR_cycle[31:0];    // Read the lower 32 bits of clock cycle count
            // default   : csr_out = 32'b0;            // Uncomment this line to set default value when no match
        endcase
    end
endmodule
