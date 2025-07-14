module Reg_PC (
    input clk,                   // Clock input
    input rst,                   // Reset input
    input stall_hazard,          // Stall signal
    input [31:0] pc_next,        // Next PC value
    output reg [31:0] pc,         // Current PC value
    input stall_CPU,
    input logic WFI_out, WFI_pc_en,
    input logic MEIP_en, MEIP_end,
    input logic MTIP_en, MTIP_end,
    input logic [31:0] pc_CSR,

    input [31:0] pc_Pred,
    input branch_pred,
    input t_pnt,
    input nt_pt

);
// logic [31:0] original_pc;
// logic rst_pc;
always_ff @(posedge clk or posedge rst) begin : PC_Register
    if (rst) begin
        pc <= 32'd0;  // Reset PC to 0
        // rst_pc <= 1'b0;
    end
    else begin
		// rst_pc <= 1'b1;
        if (stall_hazard || (stall_CPU)) 
            pc <= pc;  // Stall PC if hazard detected
        else if (WFI_pc_en) begin
            pc <= pc;
        end
        else if (MEIP_en | MEIP_end | MTIP_en /*| MTIP_end*/) begin
            pc <= pc_CSR;
        end
        // else if(nt_pt) 
        //     pc<=original_pc+32'd4;
        // else if(branch_pred) 
        //     pc<=pc_Pred;
        else begin
            pc <= pc_next;
        end
    end
end

// always_ff @(posedge clk or posedge rst) begin
//     if (rst) begin
//         original_pc<=32'd0;
//     end
//     else if ((MTIP_en)) 
//             original_pc<=32'd0;
//     else if ((stall_CPU)) 
//             original_pc<=original_pc;
//     else begin
//         if(branch_pred)begin
//             original_pc<=pc;
//         end
//         else begin
//             original_pc<=original_pc;
//         end
//     end
// end
endmodule
