module FPU (
    input logic func5_sub,           // Used to distinguish floating-point operations (e.g., subtraction vs addition)
    input logic [31:0] operand1, 
    input logic [31:0] operand2,
    input logic ID_EX_fpu_on,        // FPU enable flag
    output logic [31:0] fp_out // Floating-point operation result
);

// FPU pipeline operation logic//

    logic [7:0] FA_E, FB_E;
    assign FA_E = operand1[30:23];
    assign FB_E = operand2[30:23];

// Compare operand1 and operand2 
    logic ex1_cal_done, ex2_cal_done;
    logic ex_done, ex_shift_done, shift_num_get;
    logic FS_F_cal_done, FS_F_shift_done, FS_F_round_done;
    logic FS_E_shift_done, A_greater, FS26_tmp_done;
    logic FA_S, FB_S;
    logic [26:0] FA_F_ext, FB_F_ext;
    always_comb begin : Set_partition
        FA_S = 1'b0;
        FB_S = 1'b0;
        FA_F_ext = 27'b0;
        FB_F_ext = 27'b0;
        ex_done = 1'b0;
        A_greater = 1'b0;
        if (ID_EX_fpu_on) begin
            A_greater = (operand1[30:23] > operand2[30:23])?1'b1:1'b0;
            unique if (A_greater) begin
                {FA_S,  FA_F_ext} = {operand1[31],  2'b01, operand1[22:0], 2'b00};  // FA fraction with extra bits
                {FB_S,  FB_F_ext} = {func5_sub ^ operand2[31],  2'b01, operand2[22:0], 2'b00};  // FB fraction with extra bits
            end else begin
                {FA_S,  FA_F_ext} = {func5_sub ^ operand2[31],  2'b01, operand2[22:0], 2'b00};  // FA fraction with extra bits
                {FB_S,  FB_F_ext} = {operand1[31],  2'b01, operand1[22:0], 2'b00};  // FB fraction with extra bits
            end
            ex_done = 1'b1;
        end
    end
    
// Parallel processing ex_diff
    logic [7:0] Ex_diff1;
    always_comb begin : Exdiff1
        ex1_cal_done = 1'b0;
        Ex_diff1 = 8'b0;
        if (ID_EX_fpu_on) begin
            // Calculate the exponent difference
            Ex_diff1 = operand1[30:23] - operand2[30:23];
            ex1_cal_done = 1'b1;
        end
    end
    logic [7:0] Ex_diff2;
    always_comb begin : Exdiff2
        ex2_cal_done = 1'b0;
        Ex_diff2 = 8'b0;
        if (ID_EX_fpu_on) begin
            // Calculate the exponent difference
            Ex_diff2 = operand2[30:23] - operand1[30:23];
            ex2_cal_done = 1'b1;
        end
    end
    
    logic [26:0] FB_F_sh;
    always_comb begin : Ex_shift
        ex_shift_done = 1'b0;
        FB_F_sh = 27'b0;
        if (ex_done && ex1_cal_done && ex2_cal_done) begin
            unique if (A_greater) begin
                FB_F_sh = FB_F_ext >> Ex_diff1;
                ex_shift_done = 1'b1;
            end else begin
                FB_F_sh = FB_F_ext >> Ex_diff2;
                ex_shift_done = 1'b1;
            end
        end
    end

// Perform addition or subtraction based on the signs of the operands
    // logic FS_F26;
    logic [26:0] FS_F_cal;
    logic [25:0] FS_F_tmp;
    always_comb begin : FS_Fcal
        FS_F_cal_done = 1'b0;
        FS_F_cal = 27'b0;
        FS_F_tmp = 26'b0;
        if (ex_shift_done) begin
            FS_F_cal = (FA_S == FB_S) ? (FA_F_ext + FB_F_sh) : (FA_F_ext - FB_F_sh);
            // FS_F26 = FS_F_cal[26];
            FS_F_tmp = FS_F_cal[25:0];
            FS_F_cal_done = 1'b1;
        end
    end



    logic [4:0] FS_shift_num;
    logic [4:0] addr;
    logic addr_get;
    logic [4:0] counter;
    always_comb begin : get_shift_num
        addr_get = 1'b0;
        addr = 5'b0;
        // penc = 26'b0;
        if (FS_F_cal_done) begin
            for (reg [4:0] I = 5'b0; I < 5'd26; I = I + 5'd1) begin
                if (FS_F_tmp[I]) begin
                    addr = I ;
                end
            end
            addr_get = 1'b1;
        end
    end

    always_comb begin
        shift_num_get = 1'b0;
        FS_shift_num = 5'b0;
        if (addr_get) begin
            case (addr)
                5'd0:  FS_shift_num = 5'd25;
                5'd1:  FS_shift_num = 5'd24;
                5'd2:  FS_shift_num = 5'd23;
                5'd3:  FS_shift_num = 5'd22;
                5'd4:  FS_shift_num = 5'd21;
                5'd5:  FS_shift_num = 5'd20;
                5'd6:  FS_shift_num = 5'd19;
                5'd7:  FS_shift_num = 5'd18;
                5'd8:  FS_shift_num = 5'd17;
                5'd9:  FS_shift_num = 5'd16;
                5'd10: FS_shift_num = 5'd15;
                5'd11: FS_shift_num = 5'd14;
                5'd12: FS_shift_num = 5'd13;
                5'd13: FS_shift_num = 5'd12;
                5'd14: FS_shift_num = 5'd11;
                5'd15: FS_shift_num = 5'd10;
                5'd16: FS_shift_num = 5'd9;
                5'd17: FS_shift_num = 5'd8;
                5'd18: FS_shift_num = 5'd7;
                5'd19: FS_shift_num = 5'd6;
                5'd20: FS_shift_num = 5'd5;
                5'd21: FS_shift_num = 5'd4;
                5'd22: FS_shift_num = 5'd3;
                5'd23: FS_shift_num = 5'd2;
                5'd24: FS_shift_num = 5'd1;
                5'd25: FS_shift_num = 5'd0;
                default: FS_shift_num = 5'd0; // 預設值
            endcase
            shift_num_get = 1'b1;
        end
    end


    logic [26:0] FS_F26_tmp;
    logic [7:0] FS_E26_tmp;
    always_comb begin : FS_F26
        FS26_tmp_done = 1'b0;
        FS_F26_tmp = 27'b0;
        FS_E26_tmp = 8'b0;
        if (FS_F_cal_done) begin
            FS_F26_tmp = {1'b0,FS_F_cal[26:1]};
            FS_E26_tmp = FA_E + 8'b1; // Increase exponent if result is too large
            FS26_tmp_done = 1'b1;
        end
    end

   
    logic [7:0] FS_E_shift;
    always_comb begin : FS_Eshift
        FS_E_shift_done = 1'b0;
        FS_E_shift = 8'b0;
        if (shift_num_get && FS26_tmp_done) begin
            if (FS_F_cal[26]) begin
                FS_E_shift = FS_E26_tmp;
                FS_E_shift_done = 1'b1;
            end
            else begin
                // Use PE32 module to detect leading zeros and shift the fraction;
                FS_E_shift = FA_E - {3'b0,(FS_shift_num)};
                FS_E_shift_done = 1'b1;
            end
        end
    end

    logic [26:0] FS_F_shift;
    always_comb begin : FS_Fshift
        FS_F_shift_done = 1'b0;
        FS_F_shift = 27'b0;
        if (shift_num_get) begin
            if (FS_F_cal[26]) begin
                FS_F_shift = FS_F26_tmp;
                FS_F_shift_done = 1'b1;
            end
            else begin
                // Use PE32 module to detect leading zeros and shift the fraction
                FS_F_shift = FS_F_cal << (FS_shift_num);
                FS_F_shift_done = 1'b1;
            end
        end
    end
// Round to nearest, ties to even
    logic [26:0] FS_F_round;
    always_comb begin : Rounding
        FS_F_round_done = 1'b0;
        FS_F_round = 27'b0;
        if (FS_F_shift_done) begin
            // Perform rounding
            if (FS_F_shift[0] && (FS_F_shift[1] || FS_F_shift[2])) begin
                FS_F_round = FS_F_shift + 27'b1; // Round up if necessary
                FS_F_round_done = 1'b1;
            end
            else begin
                FS_F_round = FS_F_shift ;
                FS_F_round_done = 1'b1;
            end
        end
    end
// Output the floating-point result
    always_comb begin : FP_result
    if (ID_EX_fpu_on) begin
        if (ex_shift_done && FS_E_shift_done && FS_F_round_done) begin
            fp_out = {FA_S, FS_E_shift, FS_F_round[24:2]};
        end
        else fp_out = 32'b0;
    end
    else fp_out = 32'b0;
    end

endmodule
