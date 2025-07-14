// Hazard Detection Unit (HDU)
// Detects data hazards and signals to stall the pipeline when needed
module HDU (
    input  [4:0] IF_ID_rs,   // Source register 1 in the instruction currently in IF/ID stage
    input  [4:0] IF_ID_rt,   // Source register 2 in the instruction currently in IF/ID stage
    input  [4:0] ID_EX_rd,   // Destination register in the instruction currently in ID/EX stage
    input        ID_EX_memread,  // Indicates if the instruction in ID/EX stage is a memory read
    output logic stall_hazard     // Output signal to stall the pipeline

);

    // Detect hazard when a memory read instruction is in ID/EX stage 
    // and its destination register matches either rs1 or rs2 in IF/ID stage
    always_comb begin : HDU
	stall_hazard = 1'b0;
    begin
        unique if (ID_EX_memread  && (ID_EX_rd!=5'd0) && ((ID_EX_rd == IF_ID_rs) || (ID_EX_rd == IF_ID_rt))) begin
            stall_hazard = 1'b1;  // Hazard detected, stall the pipeline
        end else begin
            stall_hazard = 1'b0;  // No hazard, proceed normally
        
        end
    end
    end
    

endmodule
