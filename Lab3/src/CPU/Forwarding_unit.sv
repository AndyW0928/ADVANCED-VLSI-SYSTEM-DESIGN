// Forwarding_unit for data hazards
module Forwarding_unit (
    input  [4:0] IF_ID_rs,    // Source register 1 in the instruction currently in IF/ID stage
    input  [4:0] IF_ID_rt,    // Source register 2 in the instruction currently in IF/ID stage
    input  [4:0] ID_EX_rs,    // Source register 1 in the instruction currently in ID/EX stage
    input  [4:0] ID_EX_rt,    // Source register 2 in the instruction currently in ID/EX stage
    input  [4:0] EX_MEM_rd,   // Destination register in the instruction currently in EX/MEM stage
    input  [4:0] MEM_WB_rd,   // Destination register in the instruction currently in MEM/WB stage
    input        ID_EX_fprs1, // Flag indicating if the rs1 in ID/EX stage is floating-point
    input        ID_EX_fprs2, // Flag indicating if the rs2 in ID/EX stage is floating-point

    input        EX_MEM_fp_regwrite,  // Indicates if the instruction in EX/MEM stage writes to a floating-point register
    input        EX_MEM_int_regwrite, // Indicates if the instruction in EX/MEM stage writes to an integer register
    input        MEM_WB_fp_regwrite,  // Indicates if the instruction in MEM/WB stage writes to a floating-point register
    input        MEM_WB_int_regwrite, // Indicates if the instruction in MEM/WB stage writes to an integer register
    output logic [1:0] forwardA,   // Forwarding control for operand A (rs1)
    output logic [1:0] forwardB,   // Forwarding control for operand B (rs2)
    output logic [1:0] forwardA2fpu, // Forwarding control for operand fpA (fp rs1)
    output logic [1:0] forwardB2fpu, // Forwarding control for operand fpB (fp rs2)
    output logic forwardC,         // Forwarding control for rs1 in IF/ID stage
    output logic forwardD          // Forwarding control for rs2 in IF/ID stage
);

    logic [5:0] ID_EX_rs_ext, ID_EX_rt_ext, EX_MEM_rd_ext, MEM_WB_rd_ext;

    // Extend rs and rd signals to include a bit indicating if they are floating-point registers
    assign ID_EX_rs_ext = {ID_EX_fprs1, ID_EX_rs};
    assign ID_EX_rt_ext = {ID_EX_fprs2, ID_EX_rt};
    assign EX_MEM_rd_ext = {EX_MEM_fp_regwrite, EX_MEM_rd};
    assign MEM_WB_rd_ext = {MEM_WB_fp_regwrite, MEM_WB_rd};

    // Forwarding logic for rs1 (forwardA)
    always_comb begin 
        forwardA = 2'b00;  // Default to no forwarding
        if ((ID_EX_rs_ext != 6'b0) & (EX_MEM_rd_ext == ID_EX_rs_ext) & (EX_MEM_fp_regwrite || EX_MEM_int_regwrite) & (EX_MEM_rd_ext != 6'b0)) 
            forwardA = 2'd1;  // Forward from EX/MEM stage (M)
        else if ((ID_EX_rs_ext != 6'b0) & (MEM_WB_rd_ext == ID_EX_rs_ext) & (MEM_WB_fp_regwrite || MEM_WB_int_regwrite) & (MEM_WB_rd_ext != 6'b0)) 
            forwardA = 2'd2;  // Forward from MEM/WB stage (W)
        else 
            forwardA = 2'd0;  // No forwarding
    end

    // Forwarding logic for rs2 (forwardB)
    always_comb begin 
        forwardB = 2'b00;  // Default to no forwarding
        if ((ID_EX_rt_ext != 6'b0) & (EX_MEM_rd_ext == ID_EX_rt_ext) & (EX_MEM_fp_regwrite || EX_MEM_int_regwrite) & (EX_MEM_rd_ext != 6'b0)) 
            forwardB = 2'd1;  // Forward from EX/MEM stage (M)
        else if ((ID_EX_rt_ext != 6'b0) & (MEM_WB_rd_ext == ID_EX_rt_ext) & (MEM_WB_fp_regwrite || MEM_WB_int_regwrite) & (MEM_WB_rd_ext != 6'b0)) 
            forwardB = 2'd2;  // Forward from MEM/WB stage (W)
        else 
            forwardB = 2'd0;  // No forwarding
    end

    // Forwarding logic for fprs1 (forwardA2FPU)
    always_comb begin 
        forwardA2fpu = 2'b00;  // Default to no forwarding
        if ((ID_EX_rs_ext != 6'b0) & (EX_MEM_rd_ext == ID_EX_rs_ext) & (EX_MEM_fp_regwrite || EX_MEM_int_regwrite) & (EX_MEM_rd_ext != 6'b0)) 
            forwardA2fpu = 2'd1;  // Forward from EX/MEM stage (M)
        else if ((ID_EX_rs_ext != 6'b0) & (MEM_WB_rd_ext == ID_EX_rs_ext) & (MEM_WB_fp_regwrite || MEM_WB_int_regwrite) & (MEM_WB_rd_ext != 6'b0)) 
            forwardA2fpu = 2'd2;  // Forward from MEM/WB stage (W), Did not go thourgh LD moduel.
        else 
            forwardA2fpu = 2'd0;  // No forwarding
    end

    // Forwarding logic for fprs2 (forwardB2FPU)
    always_comb begin 
        forwardB2fpu = 2'b00;  // Default to no forwarding
        if ((ID_EX_rt_ext != 6'b0) & (EX_MEM_rd_ext == ID_EX_rt_ext) & (EX_MEM_fp_regwrite || EX_MEM_int_regwrite) & (EX_MEM_rd_ext != 6'b0)) 
            forwardB2fpu = 2'd1;  // Forward from EX/MEM stage (M)
        else if ((ID_EX_rt_ext != 6'b0) & (MEM_WB_rd_ext == ID_EX_rt_ext) & (MEM_WB_fp_regwrite || MEM_WB_int_regwrite) & (MEM_WB_rd_ext != 6'b0)) 
            forwardB2fpu = 2'd2;  // Forward from MEM/WB stage (W), Did not go thourgh LD moduel.
        else 
            forwardB2fpu = 2'd0;  // No forwarding
    end

    // Forwarding logic for rs1 and rs2 in IF/ID stage (forwardC, forwardD)
    always_comb begin : ForwardC_D
        forwardC = 1'b0;  // Default to no forwarding
        forwardD = 1'b0;  // Default to no forwarding
        
        // If the destination register in MEM/WB stage is written, check for hazards with IF/ID stage registers
        if ((MEM_WB_fp_regwrite || MEM_WB_int_regwrite) && (MEM_WB_rd != 5'b0)) begin
            if (MEM_WB_rd == IF_ID_rs) begin
                forwardC = 1'b1;  // Forward to rs1 in IF/ID stage
            end
            if (MEM_WB_rd == IF_ID_rt) begin
                forwardD = 1'b1;  // Forward to rs2 in IF/ID stage
            end
        end
    end

endmodule
