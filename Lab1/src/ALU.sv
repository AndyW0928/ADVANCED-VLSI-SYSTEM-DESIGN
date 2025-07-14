
module ALU(in_A, in_B, ALU_op, ALU_en, ZERO, ALU_result);
 
input logic [31:0] in_A, in_B;
input logic [4:0] ALU_op;
input logic ALU_en;
output logic ZERO;
output logic [31:0] ALU_result;

logic [63:0] MUL_result;

always_comb
begin
    if (ALU_en) begin
    ZERO = 1'b0;
	MUL_result = 64'b0;
    case (ALU_op)
	5'b00000: ALU_result = in_A + in_B;                                         //ADD
    5'b00001: ALU_result = in_A - in_B;                                         //SUB
    5'b00010: ALU_result = in_A << in_B[4:0];                                   //SLL
    5'b00011: ALU_result = ($signed(in_A) < $signed(in_B)) ? 32'd1 : 32'd0;         //SLT
    5'b00100: ALU_result = (in_A < in_B) ? 32'd1 : 32'd0;                       //SLTU
    5'b00101: ALU_result = in_A ^ in_B;                                         //XOR
    5'b00110: ALU_result = in_A >> in_B[4:0];                                   //SRL
    5'b00111: ALU_result = $signed(in_A) >>> in_B[4:0];                             //SRA
    5'b01000: ALU_result = in_A | in_B;                                         //OR
    5'b01001: ALU_result = in_A & in_B;                                         //AND  
   
	//*********************************B*********************************************//
    5'b01010: begin                                                          //BEQ
              ZERO = (in_A == in_B);
              ALU_result = 32'b0;
              end
    5'b01011: begin                                                             //BNE
              ZERO = (in_A != in_B);
              ALU_result = 32'b0;
              end
    5'b01100: begin                                                             //BLT
              ZERO = ($signed(in_A) < $signed(in_B));
              ALU_result = 32'b0;
              end
    5'b01101: begin                                                             //BGE
              ZERO = ($signed(in_A) >= $signed(in_B));
              ALU_result = 32'b0;
              end          
    5'b01110: begin                                                             //BLTU
              ZERO = ($unsigned(in_A) < $unsigned(in_B));
              ALU_result = 32'b0;
              end
    5'b01111: begin                                                             //BGEU                   
              ZERO = ($unsigned(in_A) >= $unsigned(in_B));
              ALU_result = 32'b0;
              end
			  
	//***************************************M***********************************//
    5'b10000: begin
              MUL_result = in_A * in_B;
              ALU_result = MUL_result[31:0];
              end
    5'b10001: begin
              ALU_result = $signed(in_A) * $signed(in_B);
              end
    5'b10010: begin
              MUL_result = $signed({{32{1'b1}},in_A}) * $unsigned(in_B);
              ALU_result = MUL_result[63:32];
              end
    5'b10011: begin
              MUL_result = in_A * in_B;
              ALU_result = MUL_result[63:32];
              end
    default: begin
             ZERO = 1'b0;
             ALU_result = 32'b0;
             end
    endcase
    end
    else begin         
    ZERO = 1'b0;
	MUL_result =64'b0;
    ALU_result = 32'b0;
    end
end

endmodule
