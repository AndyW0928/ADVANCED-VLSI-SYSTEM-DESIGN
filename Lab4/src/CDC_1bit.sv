//CDC for 1bit data

module CDC_1bit(clk, rst, clk2, rst2, data_en_A, data_bus,
data_out);

input logic clk, rst;
input logic clk2, rst2;
input logic data_en_A;
input logic data_bus;
output logic data_out;

//DFF_data bus
logic data_bus_wire;

always_ff @(posedge clk or posedge rst)
begin
    if (rst)
        data_bus_wire <= 1'b0;
    else
        data_bus_wire <= data_bus;    
end        
//**************************************************//        
//DFF1_data enable
logic data_en_wire1;

always_ff @(posedge clk or posedge rst)
begin
    if (rst)
        data_en_wire1 <= 1'b0;
    else
        data_en_wire1 <= data_en_A;    
end

//DFF2_ data enable
logic data_en_wire2;       

always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        data_en_wire2 <= 1'b0;
    else
        data_en_wire2 <= data_en_wire1;    
end        

//DFF3_ data enable
logic data_en_B;       

always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        data_en_B <= 1'b0;
    else
        data_en_B <= data_en_wire2;    
end   
//**************************************************//
//MUX
logic data_mux_wire; 

always_comb
begin
    if (data_en_B)
        data_mux_wire = data_bus_wire;
    else
        data_mux_wire = data_out;   
end                  
//**************************************************//
//DFF_out
always_ff @(posedge clk2 or posedge rst2)
begin
    if (rst2)
        data_out <= 1'b0;
    else
        data_out <= data_mux_wire;    
end   
    
endmodule
