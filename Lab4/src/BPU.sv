module BPU(
    input clk,
    input rst,
    input stall_CPU,
    input stall_hazard,
    input MTIP_en,
    input [6:0] ID_EX_opcode,
    input branch_RealTaken,
    input ID_EX_branch_pred,
    input [31:0] inst,
    input [31:0] pc,
    output logic branch_pred,
    output logic [31:0] pc_Pred,
    output logic t_pnt,
    output logic nt_pt
);

// State definition for branch prediction unit
typedef enum logic [1:0] {  
    STRONGLY_NT = 2'b01,
    WEAKLY_NT = 2'b00,    
    WEAKLY_T  = 2'b10,    
    STRONGLY_T = 2'b11     
} BPU_state;

BPU_state state, nstate;

logic branch_inst;
logic [31:0] imm;

// Determine if instruction is a branch
assign branch_inst = (ID_EX_opcode == 7'b1100011);

// Calculate immediate value and predicted PC
assign imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
assign pc_Pred = pc + imm;

// State update logic
always_ff @(posedge clk or posedge rst) begin
    if (rst) 
        state <= WEAKLY_NT;
    else if (MTIP_en) 
        state <= WEAKLY_NT;
    else 
        state <= nstate;
end

// Next state logic
always_comb begin
    case (state)
        STRONGLY_NT: begin
            if (branch_inst) begin
                nstate = branch_RealTaken ? WEAKLY_NT : STRONGLY_NT;
            end else begin
                nstate = STRONGLY_NT;
            end
        end
        WEAKLY_NT: begin
            if (branch_inst) begin
                nstate = branch_RealTaken ? WEAKLY_T : STRONGLY_NT;
            end else begin
                nstate = WEAKLY_NT;
            end
        end
        WEAKLY_T: begin
            if (branch_inst) begin
                nstate = branch_RealTaken ? STRONGLY_T : WEAKLY_NT;
            end else begin
                nstate = WEAKLY_T;
            end
        end
        STRONGLY_T: begin
            if (branch_inst) begin
                nstate = branch_RealTaken ? STRONGLY_T : WEAKLY_T;
            end else begin
                nstate = STRONGLY_T;
            end
        end
    endcase
end

// Branch prediction logic
always_comb begin
    if (inst[6:0] == 7'b1100011) begin
        case (state)
            STRONGLY_NT, WEAKLY_NT: branch_pred = 1'b0;
            WEAKLY_T, STRONGLY_T:   branch_pred = 1'b1;
        endcase    
    end else begin
        branch_pred = 1'b0;
    end
end
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        t_pnt <= 1'b0;
        nt_pt <= 1'b0;
    end
    else begin
        if (branch_inst) begin
            if (branch_RealTaken) begin
                t_pnt <= ~ID_EX_branch_pred; // Predicted not taken but actually taken
            end else begin
                nt_pt <= ID_EX_branch_pred;  // Predicted taken but actually not taken
            end
        end
        else begin
            t_pnt <= 1'b0;
            nt_pt <= 1'b0;
        end
    end
end
// logic t_pnt_reg, nt_pt_reg;
// logic t_pnt_tmp, nt_pt_tmp;
// Taken and not-taken point logic
// always_comb begin
//     t_pnt_tmp = 1'b0;
//     nt_pt_tmp = 1'b0;

//     if (branch_inst) begin
//         if (branch_RealTaken) begin
//             t_pnt_tmp = ~ID_EX_branch_pred; // Predicted not taken but actually taken
//         end else begin
//             nt_pt_tmp = ID_EX_branch_pred;  // Predicted taken but actually not taken
//         end
//     end
//     else begin
//         t_pnt_tmp = 1'b0;
//         nt_pt_tmp = 1'b0;
//     end
// end

// always_ff @(posedge clk or posedge rst) begin
//     if (rst) begin
//         t_pnt_reg <= 1'b0;
//         nt_pt_reg <= 1'b0;
//     end
//     else begin
//         t_pnt_reg <= t_pnt_tmp;
//         nt_pt_reg <= nt_pt_tmp;
//     end
// end
// assign t_pnt = t_pnt_reg;
// assign nt_pt = nt_pt_reg;
// always_comb begin
//     t_pnt = 1'b0;
//     nt_pt = 1'b0;

//     if (branch_inst) begin
//         if (branch_RealTaken) begin
//             t_pnt_tmp = ~ID_EX_branch_pred; // Predicted not taken but actually taken
//         end else begin
//             nt_pt_tmp = ID_EX_branch_pred;  // Predicted taken but actually not taken
//         end
//     end
//     else begin
//         t_pnt_tmp = 1'b0;
//         nt_pt_tmp = 1'b0;
//     end
// end

//====================== record predict correct or not ==================================//
// always_ff @(posedge clk )begin
//     if(rst)begin
//         right_reg<=32'b0;
//         wrong_reg<=32'b0;
//     end
//     else begin
//         if(stall_CPU || stall_hazard)begin
//             right_reg<=right_reg;
//             wrong_reg<=wrong_reg; 
//         end
//         else begin
//             if(branch_inst)begin
//                 case(state)
//                 STRONGLY_NT:begin
//                     if(branch_RealTaken)begin
//                         right_reg<=right_reg;
//                         wrong_reg<=wrong_reg+32'b1;
//                     end
//                     else begin
//                         right_reg<=right_reg+32'b1;
//                         wrong_reg<=wrong_reg;
//                     end
//                 end
//                 WEAKLY_NT:begin
//                     if(branch_RealTaken)begin
//                         right_reg<=right_reg;
//                         wrong_reg<=wrong_reg+32'b1;
//                     end
//                     else begin
//                         right_reg<=right_reg+32'b1;
//                         wrong_reg<=wrong_reg;
//                     end
//                 end
//                 WEAKLY_T:begin
//                     if(branch_RealTaken)begin
//                         right_reg<=right_reg+32'b1;
//                         wrong_reg<=wrong_reg;
//                     end
//                     else begin
//                         right_reg<=right_reg;
//                         wrong_reg<=wrong_reg+32'b1;
//                     end
//                 end
//                 STRONGLY_T:begin
//                     if(branch_RealTaken)begin
//                         right_reg<=right_reg+32'b1;
//                         wrong_reg<=wrong_reg;
//                     end
//                     else begin
//                         right_reg<=right_reg;
//                         wrong_reg<=wrong_reg+32'b1;
//                     end
//                 end
//                 endcase    
//             end
//             else begin
//                 right_reg<=right_reg;
//                 wrong_reg<=wrong_reg;
//             end
//         end
        
//     end
// end

endmodule