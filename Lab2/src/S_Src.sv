//S-type Src

module S_Src(MEM_write_M, MEM_writetype, sdata_M, FP_sdata_M, writeMEM_place, DM_BWEB, DM_DI);

input logic MEM_write_M;
input logic [2:0] MEM_writetype;
input logic [31:0] sdata_M, FP_sdata_M;
input logic [1:0] writeMEM_place;
output logic [31:0] DM_BWEB;
output logic [31:0] DM_DI;
    
always_comb
begin
    if(MEM_write_M)begin
        case(MEM_writetype)
        3'b000 : begin                                                      //SW
                DM_BWEB = 32'h0000_0000;
                DM_DI = sdata_M;
                end
				
		3'b001 : begin                                                      //SB
                case (writeMEM_place)
                2'b00 : begin
                       DM_BWEB = 32'hffff_ff00;
                       DM_DI = {{24'hffff_ff},sdata_M[7:0]};
                       end
                2'b01 : begin
                       DM_BWEB = 32'hffff_00ff;
                       DM_DI = {{16'h0000},sdata_M[7:0],{8'h00}};
                       end
                2'b10 : begin
                       DM_BWEB = 32'hff00_ffff;
                       DM_DI = {{8'h00},sdata_M[7:0],{16'h0000}};
                       end
                2'b11 : begin
                       DM_BWEB = 32'h00ff_ffff;
                       DM_DI = {sdata_M[7:0],{24'h0000_00}};
                       end
                endcase
                end
				
	    3'b010 : begin                                                      //SH
                case (writeMEM_place)
                2'b00 : begin
                       DM_BWEB = 32'hffff_0000;
                       DM_DI = {{16'hffff},sdata_M[15:0]};
                       end
                2'b01 : begin
                       DM_BWEB = 32'hff00_00ff;
                       DM_DI = {{8'h00},sdata_M[15:0],{8'h00}};
                       end
                2'b10 : begin
                       DM_BWEB = 32'h0000_ffff;
                       DM_DI = {sdata_M[15:0],{16'h0000}};
                       end  
				default: begin
               DM_BWEB = 32'hffff_ffff;
               DM_DI = 32'b0;
               end 
                endcase
                end
        
        3'b011 : begin                                                   //FSW
               DM_BWEB = 32'h0000_0000;
               DM_DI = FP_sdata_M;
               end

        default : begin
               DM_BWEB = 32'hffff_ffff;
               DM_DI = 32'b0;
               end
        endcase
        end

    else begin
    DM_BWEB = 32'hffff_ffff;
    DM_DI = 32'b0;
    end
end
                
    
endmodule
