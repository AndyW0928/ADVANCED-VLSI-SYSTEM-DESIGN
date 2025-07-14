module BPU(
    input clk,
    input rst,
    input stall_CPU,
    input stall_hazard,
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

typedef enum logic [1:0] {  
    STRONGLY_NT = 2'b01,
    WEAKLY_NT = 2'b00,    
    WEAKLY_T  = 2'b10,    
    STRONGLY_T = 2'b11     
} BPU_state;


BPU_state state, nstate;

logic branch_inst;
// logic [31:0] inst_reg, inst_select;
logic [31:0] imm;




assign branch_inst = (ID_EX_opcode==7'b1100011);
// assign inst_select = (stall_CPU || stall_hazard) ? inst_reg:inst
assign imm = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
assign pc_Pred = (pc + imm) ;

// always_ff @(posedge clk or posedge rst )begin
//     if(rst) 
//         inst_reg<=32'b0;
//     else begin
//         if(stall_CPU || stall_hazard) inst_reg<=inst_reg;
//         else inst_reg<=inst;
//     end
// end

always_ff@(posedge clk or posedge rst )begin
    if(rst) state<=WEAKLY_NT;
    else begin
        // if(stall_CPU || stall_hazard) state<=state;
        // else 
        state<=nstate;
    end
end

always_comb begin
    case(state)
    STRONGLY_NT:begin
        if(branch_inst)begin
            if(branch_RealTaken) nstate=WEAKLY_NT;
            else nstate=STRONGLY_NT;
        end
        else nstate=STRONGLY_NT;
    end
    WEAKLY_NT:begin
        if(branch_inst)begin
            if(branch_RealTaken) nstate=WEAKLY_T;
            else nstate=STRONGLY_NT;
        end
        else nstate=WEAKLY_NT;
    end
    WEAKLY_T:begin
        if(branch_inst)begin
            if(branch_RealTaken) nstate=STRONGLY_T;
            else nstate=WEAKLY_NT;
        end
        else nstate=WEAKLY_T;
    end
    STRONGLY_T:begin
        if(branch_inst)begin
            if(branch_RealTaken) nstate=STRONGLY_T;
            else nstate=WEAKLY_T;
        end
        else nstate=STRONGLY_T;
    end
    endcase
end

always_comb begin
    if (inst[6:0]==7'b1100011)
    begin
        case(state)
        STRONGLY_NT:begin
            branch_pred=1'b0;
        end
        WEAKLY_NT:begin
            branch_pred=1'b0;
        end
        WEAKLY_T:begin
            branch_pred=1'b1;
        end
        STRONGLY_T:begin
            branch_pred=1'b1;
        end
        endcase    
    end
    else branch_pred=1'b0;
    
end

always_comb begin
    if(branch_RealTaken && branch_inst) begin
        if(ID_EX_branch_pred)begin
            //taken but predict not taken
            t_pnt=1'b0;
            //not taken but predict taken
            nt_pt=1'b0;
        end
        else begin
            t_pnt=1'b1;
            nt_pt=1'b0;
        end
    end
    else if(~branch_RealTaken && branch_inst)begin
        if(ID_EX_branch_pred)begin
            t_pnt=1'b0;
            nt_pt=1'b1;
        end
        else begin
            t_pnt=1'b0;
            nt_pt=1'b0;
        end
    end
    else begin
        t_pnt=1'b0;
        nt_pt=1'b0;
    end
end

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