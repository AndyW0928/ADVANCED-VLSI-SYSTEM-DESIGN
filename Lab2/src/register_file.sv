
module register_file(clk, rst, A1, A2, A3, rf_write, WB_data, A1_data, A2_data);

//I/O
input logic clk, rst;
input logic [4:0] A1, A2, A3;
input logic rf_write;                     //rd_write_en
input logic [31:0] WB_data;                    //write back data
output logic [31:0] A1_data, A2_data;

//reg
logic [31:0] register [0:31]; 
/*
//read A1
always_ff @(posedge clk or posedge rst)
begin
    if (rst)
    A1_data <= 32'b0;
    else if (rf_write & (A3 != 5'b0) & (A3 == A1))
    A1_data <= WB_data;
    else
    A1_data <= register[A1];
end

//read A2
always_ff @(posedge clk or posedge rst)
begin
    if (rst)
    A2_data <= 32'b0;
    else if (rf_write & (A3 != 5'b0) & (A3 == A2))
    A2_data <= WB_data;
    else
    A2_data <= register[A2];
end
*/

assign A1_data = (rf_write & (A3 != 5'b0) & (A3 == A1))? WB_data : register[A1];
assign A2_data = (rf_write & (A3 != 5'b0) & (A3 == A2))? WB_data : register[A2];

//write back
always_ff @(posedge clk or posedge rst)
begin
    if (rst) begin
    register[0] <= 32'b0;
    register[1] <= 32'b0;
    register[2] <= 32'b0;
    register[3] <= 32'b0;
    register[4] <= 32'b0;
    register[5] <= 32'b0;
    register[6] <= 32'b0;
    register[7] <= 32'b0;
    register[8] <= 32'b0;
    register[9] <= 32'b0;
    register[10] <= 32'b0;
    register[11] <= 32'b0;
    register[12] <= 32'b0;
    register[13] <= 32'b0;
    register[14] <= 32'b0;
    register[15] <= 32'b0;
    register[16] <= 32'b0;
    register[17] <= 32'b0;
    register[18] <= 32'b0;
    register[19] <= 32'b0;
    register[20] <= 32'b0;
    register[21] <= 32'b0;
    register[22] <= 32'b0;
    register[23] <= 32'b0;
    register[24] <= 32'b0;
    register[25] <= 32'b0;
    register[26] <= 32'b0;
    register[27] <= 32'b0;
    register[28] <= 32'b0;
    register[29] <= 32'b0;
    register[30] <= 32'b0;
    register[31] <= 32'b0;
    end
    else if (rf_write & (A3 != 5'b0)) 
    register[A3] <= WB_data;
end    



endmodule
