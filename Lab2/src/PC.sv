module PC(clk, rst, PC_stall, AXI_stall, pc_n, /*ARVALID_M0, ARREADY_M0,*/  pc_c);

input logic clk, rst;
input logic PC_stall, AXI_stall;
input logic  [31:0] pc_n;         //current pc
//input logic ARVALID_M0, ARREADY_M0;
output logic  [31:0] pc_c;        //next pc 

always_ff @(posedge clk or posedge rst)
begin
    if (rst) begin
        pc_c <= 32'b0;
    end
    else if (PC_stall | AXI_stall/* | (ARVALID_M0 & !ARREADY_M0)*/) begin
        pc_c <= pc_c;
    end
    else begin
        pc_c <= pc_n;
   end
end
    
endmodule
