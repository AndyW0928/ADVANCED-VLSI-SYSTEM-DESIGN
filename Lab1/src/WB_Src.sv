//WB_data Src

module WB_Src(WB_data_src_W, MEM_back_W, MEM_load_W, CSR_cyc, WB_data);

input logic [2:0] WB_data_src_W;
input logic [31:0] MEM_back_W, MEM_load_W, CSR_cyc;
output logic [31:0] WB_data; 

always_comb
    case(WB_data_src_W)     
	3'b000 : WB_data = MEM_back_W;
    3'b110 : WB_data = MEM_load_W;      
    3'b111 : WB_data = CSR_cyc;
	default : WB_data = 32'b0;
    endcase     
endmodule

