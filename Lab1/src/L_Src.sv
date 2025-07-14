//Load Src

module L_Src(MEM_read_M, MEM_readtype_M, DM_DO, MEM_data_M);

input logic MEM_read_M;
input logic [2:0] MEM_readtype_M;
input logic [31:0] DM_DO;
output logic [31:0] MEM_data_M;
    
always_comb
begin
    if (MEM_read_M) begin
        case (MEM_readtype_M)
        3'b000 : MEM_data_M = DM_DO;                                    //LW
		3'b001 : MEM_data_M = {{24{DM_DO[7]}},DM_DO[7:0]};                 //LB
		3'b010 : MEM_data_M = {{16{DM_DO[15]}},DM_DO[15:0]};               //LH
		3'b011 : MEM_data_M = {24'h0000_00,DM_DO[7:0]};                  //LBU
		3'b100 : MEM_data_M = {16'h0000,DM_DO[15:0]};                     //LHU
        3'b101 : MEM_data_M = DM_DO;             
        default: MEM_data_M = 32'b0;
        endcase
   end
   else begin
   MEM_data_M = 32'b0;
   end
end
endmodule
