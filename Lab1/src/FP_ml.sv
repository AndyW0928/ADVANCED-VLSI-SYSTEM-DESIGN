module FP_ml (
                input clk,
                input rst,
                input fp_ml_en,
                input [31:0] input_A,
                input [31:0] input_B,
                output logic [31:0] flout_c,
                output logic [1:0] overflow
);

 logic            s1, s2;                    
 logic [7:0]      exp1, exp2;                 
 logic [23:0]     man1, man2;                 
 logic            n;                        
 logic [9:0]      temp1, temp2, temp3;       
 logic [47:0]     mul_out_p;                  


 //first output
 logic         s_out1;
 logic [9:0]   e_out1;
 logic  [47:0]  m_out1;
 
//first reg
 logic        s1_r; 
 logic [9:0]  e1_r; 
 logic [47:0] m1_r;
 
//secont output
 logic [1:0]  f_out; 
 logic [7:0]  e_out2; 
 logic [22:0] m_out2; 


//secont reg
 logic        s2_r;
 logic [1:0]  f_r; 
 logic [7:0]  e2_r;
 logic [22:0] m2_r;



always @(posedge clk or posedge rst) 
begin
   if (rst) begin      
      s1   <= 1'b0;
      exp1 <= 8'b0;
      man1 <= {1'b1, 23'b0};
   end
   else if (fp_ml_en) begin
      s1   <= input_A[31];
      exp1 <= input_A[30:23];
      man1 <= {1'b1, input_A[22:0]};
   end
end
 

always @(posedge clk or posedge rst) 
begin
   if (rst) begin      
      s2   <= 1'b0;
      exp2 <= 8'b0;
      man2 <= {1'b1, 23'b0};
   end
   else if (fp_ml_en) begin
      s2   <= input_B[31];
      exp2 <= input_B[30:23];
      man2 <= {1'b1, input_B[22:0]};
   end
end


assign s_out1 = s1 ^ s2;   
 

always@(*) 
begin
   if (man1 == 24'b10000000000_0000000000000)
	   m_out1 = 48'b0;
	else if (man2 == 24'b10000000000_0000000000000)
	   m_out1 = 48'b0;
	else
	   m_out1 = man1 * man2;  
end


always@(*) 
begin
   if (exp1[7] == 1)
      temp1 = {2'b00, 1'b0, exp1[6:0]};
   else 
	   temp1 = {2'b11, 1'b1, exp1[6:0]};
   if (exp2[7] == 1)
      temp2 = {2'b00, 1'b0, exp2[6:0]};
   else
	   temp2 = {2'b11, 1'b1, exp2[6:0]}; 
end


assign e_out1[9:0] = temp1[9:0] + temp2[9:0];  


always@(posedge clk or posedge rst) 
begin
   if (rst) begin
       s1_r <= 1'b0;
	   e1_r <= 10'b0;
	   m1_r <= 48'b0;
   end
   else begin
       s1_r <= s_out1;
	   e1_r <= e_out1;
	   m1_r <= m_out1;
   end
end


always@(*) 
begin
   if (m1_r == 48'b0) begin  
       m_out2 =  23'b0;
       n  =  1'b0;
   end  
	else begin
		if (m1_r[47] == 1) begin
		    n  = 1'b1;                    
			 mul_out_p = m1_r >> 1; 
	   end
	   else begin
			 n   = 1'b0;                 
			 mul_out_p = m1_r;      
	   end
         m_out2[22:0] = mul_out_p[45:23];

   end

   temp3 = e1_r[9:0] + n + 1'b1;  
	if (temp3[9:8] == 2'b01)  
        f_out = 2'b01; 
   else if (temp3[9:8] == 2'b10)  
	    f_out = 2'b10; 
   else 
	    f_out = 2'b00; 

   case(temp3[7])  
     1'b1 :  e_out2 = {1'b0,temp3[6:0]}; 
     1'b0 :  e_out2 = {1'b1,temp3[6:0]}; 
   endcase
end


//always@(posedge clk or posedge rst) 
//begin
//   if (rst) begin
//       s2_r <= 1'b0;
//	   e2_r <= 8'b0;
//	   m2_r <= 23'b0;
//	   f_r <= 2'b0;
//   end
//   else if ((m_out2 == 0) && (e_out2 == 0)) begin   
//	   s2_r <= 1'b0;
//	   e2_r <= 8'b0;
//	   m2_r <= 23'b0;
//	   f_r <= 2'b0;
//	end
//   else begin
//       s2_r <= s1_r;
//       f_r <= f_out;
//       e2_r <= e_out2;
//       m2_r <= m_out2;
//	end
//end

always@(*)
begin
    if ((m_out2 == 0) && (e_out2 == 0)) begin   
	   s2_r <= 1'b0;
	   e2_r <= 8'b0;
	   m2_r <= 23'b0;
	   f_r <= 2'b0;
	end
   else begin
       s2_r <= s1_r;
       f_r <= f_out;
       e2_r <= e_out2;
       m2_r <= m_out2;
	end
end

always@(*)
begin
	  flout_c  = {s2_r, e2_r[7:0], m2_r[22:0]};
	  overflow = f_r;
end

endmodule
