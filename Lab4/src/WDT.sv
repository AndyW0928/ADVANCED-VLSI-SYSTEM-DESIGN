

module WDT(clk, rst, clk2, rst2, WDEN, WDLIVE, WTOCNT, WTO);
 
input logic clk, rst;
input logic clk2, rst2;
input logic WDEN;
input logic WDLIVE;
input logic [31:0] WTOCNT;
output logic WTO;

//reg
logic WDEN_r, WDLIVE_r;
logic [31:0] WTOCNT_r;

always_ff @(posedge clk2 or posedge rst2)
begin
    if(rst2) begin
        WDEN_r <= 1'b0;
        WDLIVE_r <= 1'b0;
        WTOCNT_r <= 32'b0;
    end    
    else begin
        WDEN_r <= WDEN;
        WDLIVE_r <= WDLIVE;
        WTOCNT_r <= WTOCNT;    
    end    
end            
    

//count
//priority
//WDLIVE  > WDEN  > overflow 

logic [31:0] count;

always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        count <=32'b0;
    else begin
        if (WDEN_r) begin           //wdt enable
            if (WDLIVE_r)               //reset wdt
               count <= 32'b0; 
            else begin
                if (count < WTOCNT_r)       
                    count <= count + 32'b1;
                else                //overflow    
                    count <= 32'b0;
            end 
        end               
        else begin
            if (WDLIVE_r)               //reset wdt
               count <= 32'b0;
            else 
               count <= count;
        end  
    end  
end                           
                          
//WTO
//assign WTO = (count >= WTOCNT_r && WDEN_r)? 1'b1 : 1'b0;
always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        WTO <= 1'b0;
    else    
        WTO <= (count >= WTOCNT_r && WDEN_r); 
end                  
    
    
endmodule
