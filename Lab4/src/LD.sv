// Load Data
module LD (
    input  logic  [2:0] MEM_WB_memread,        // Memory read type signal from MEM/WB stage
    input  logic [31:0] DM_DO,                 // Data from SRAM (data memory)
    input  logic [1:0]  last2,  
    output logic [31:0] read_data              // Output processed data from memory
);

   always_comb begin : Load_Data
        read_data = 32'd0;  // Initialize output to 0
        
        // // Determine the type of memory load instruction
        // case (MEM_WB_memread)
        //     3'b111: begin : LD_Load_Word // LW (Load Word)
        //         read_data = DM_DO;  // Read the full 32-bit word from memory
        //     end
            
        //     3'b011: begin : LD_Load_Halfword // LH (Load Halfword)
        //         read_data = {{16{DM_DO[15]}}, DM_DO[15:0]};  // Sign-extend the lower 16 bits (halfword)
        //     end
            
        //     3'b001: begin : LD_Load_Byte // LB (Load Byte)
        //         read_data = {{24{DM_DO[7]}}, DM_DO[7:0]};  // Sign-extend the lower 8 bits (byte)
        //     end
            
        //     3'b100: begin : LD_Load_Halfword_Unsigned // LHU (Load Halfword Unsigned)
        //         read_data = {16'b0, DM_DO[15:0]};  // Zero-extend the lower 16 bits (halfword)
        //     end
            
        //     3'b110: begin : LD_Load_Byte_Unsigned // LBU (Load Byte Unsigned)
        //         read_data = {24'b0, DM_DO[7:0]};  // Zero-extend the lower 8 bits (byte)
        //     end
            
        //     default: begin
        //         read_data = 32'd0;  // Default to 0 for unsupported load types
        //     end
        // endcase
        if (|MEM_WB_memread) begin
        case (MEM_WB_memread)
        3'b111 :  read_data = DM_DO;                                    //LW
                                              
		3'b001 : begin                                                   //LB
                 case(last2)
                 2'b00 : read_data = {{24{DM_DO[7]}},DM_DO[7:0]};  
                 2'b01 : read_data = {{24{DM_DO[15]}},DM_DO[15:8]};
                 2'b10 : read_data = {{24{DM_DO[23]}},DM_DO[23:16]};
                 2'b11 : read_data = {{24{DM_DO[31]}},DM_DO[31:24]};
                 endcase
                 end             

		3'b011 : begin                                                   //LH
                 case(last2)
                 2'b00 : read_data = {{16{DM_DO[15]}},DM_DO[15:0]};  
                 2'b01 : read_data = {{16{DM_DO[23]}},DM_DO[23:8]};
                 2'b10 : read_data = {{16{DM_DO[31]}},DM_DO[31:16]};
                 2'b11 : read_data = {{24{DM_DO[31]}},DM_DO[31:24]};   
                 endcase
                 end       

		3'b110 : begin                                                   //LBU
                 case(last2)
                 2'b00 : read_data = {24'h0000_00,DM_DO[7:0]};         
                 2'b01 : read_data = {24'h0000_00,DM_DO[15:8]};  
                 2'b10 : read_data = {24'h0000_00,DM_DO[23:16]};  
                 2'b11 : read_data = {24'h0000_00,DM_DO[31:24]};          
                 endcase
                 end

		3'b100 : begin                                                   //LHU
                 case(last2)
                 2'b00 : read_data = {16'h0000,DM_DO[15:0]};     
                 2'b01 : read_data = {16'h0000,DM_DO[23:8]}; 
                 2'b10 : read_data = {16'h0000,DM_DO[31:16]}; 
                 2'b11 : read_data = {24'h0000_00,DM_DO[31:24]}; 
                 endcase
                 end      

        // 3'b101 : read_data = DM_DO;                                    //FLW        

        default: read_data = 32'b0;
        endcase
   end
   else begin
   read_data = 32'b0;
   end
   end
endmodule
