//floating point ALU

module FP_ALU(FP_inA, FP_inB, FPU_en, FPU_op, FPU_result);

    input  logic [31:0] FP_inA;
    input  logic [31:0] FP_inB;
    input  logic        FPU_en;  
    input  logic [1:0]  FPU_op;   // 00: add, 01: sub
    output logic [31:0] FPU_result;



    logic        sigA, sigB;
    logic [7:0]  expA, expB;
    logic [25:0] manA, manB;

    logic [25:0] man_L, man_S;              //LARGE   /  SMALL
    logic [7:0]  exp_same, exp_dif;            // same legnth   diss length
    logic        sig_same;                    //

    logic [25:0] man_result;
    logic cout;
    logic [7:0]  exp_result;
    logic        sig_result;

    logic        A_large; //    A > B ?
//*************************************************************************//
//sign  exp mantissa
    assign sigA     = FP_inA[31];
    assign expA      = FP_inA[30:23];
    assign manA = {1'b1, FP_inA[22:0] ,2'b00}; 

    assign sigB     = FP_inB[31];
    assign expB      = FP_inB[30:23];
    assign manB = {1'b1, FP_inB[22:0], 2'b00}; 

//*****************************************************************************//
always_comb 
begin
cout = 1'b0;
    //compare exp bits
    if (FPU_en) begin  
        if (expA > expB) begin
            A_large = 1'b1;
			sig_same     = sigA;
            exp_same      = expA;
            exp_dif     = expA - expB;
            man_L        = manA;
            man_S = manB >> exp_dif;
        end 
		else begin
            A_large =1'b0;
			sig_same    = sigB;
            exp_same      = expB;
            exp_dif     = expB - expA;
            man_L        = manB;
            man_S = manA >> exp_dif;
        end
//*******************************************************************************//
     //man calculate   
        case (FPU_op)
        2'b00: begin                                 //ADD
                if (sigA == sigB) begin
                    sig_result = sig_same; 
                    {cout,man_result} = man_L + man_S;
                end 
                else begin
                    if (man_L >= man_S) begin
                        sig_result = sig_same;
                        man_result = man_L - man_S;
                    end 
                    else begin
                        sig_result = !sig_same;
                        man_result = man_S - man_L; 
                    end
                end
               end
        2'b01: begin                                //SUB
                if (sigA != sigB) begin
                    sig_result = sigA;
                    {cout,man_result} = man_L + man_S;
                end 
                else begin 
                    if (man_L >= man_S) begin
                        sig_result = (A_large)? sig_same : (!sig_same);
                        man_result = man_L - man_S;
                    end 
                    else begin
                         sig_result = !sig_same;
                         man_result = man_S - man_L;
                    end
                 end
                end
        default: begin
                {cout,man_result} = 27'b0;
				sig_result = 1'b0;
                exp_result = 8'b0;               
                A_large = 1'b0;
                end
        endcase
		
//***********************************************************//
		if (cout) begin
			{cout,man_result} = {cout,man_result} >> 1;
			exp_same = exp_same + 8'b1;
		end 
		else if (man_result[25] == 1'b0) begin
			for (int i = 0; i < 26; i = i + 1) begin
				if ((man_result[25] == 1'b0) & (exp_same > 8'b0)) begin
					{cout,man_result} = man_result << 1;
					exp_same = exp_same - 8'b1;
				end 
				else begin
				//nothing
				break;
				end
			end
		 end

		exp_result = exp_same;

 //******************round*******************************//
		if (man_result[0]) begin
			if (man_result[1] | (man_result[0] & man_result[2])) begin
			{cout,man_result} = {cout,man_result} + 27'b1;
			end
		end
	end 
    
	else begin
		exp_same      = 8'b0;
		man_L 		 = 26'b0;
		sig_same     = 1'b0;
		exp_dif     = 8'b0;
		man_S 		= 26'b0;
		{cout,man_result} = 27'b0;
		sig_result = 1'b0;
		exp_result = 8'b0;               
		A_large = 1'b0;
	end
end

//********************* ********** ************************//
//Result
always_comb 
begin
    if (FPU_en) begin
        FPU_result = {sig_result, exp_result, man_result[24:2]};  // Final 
    end 
    else begin
        FPU_result = 32'b0;  
    end
end 

endmodule
