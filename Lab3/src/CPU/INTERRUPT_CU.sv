//WFI signal not decide
`define INTR_STATE_BITS 2
`define MRET    (32'b0011000_00010_00000_000_00000_1110011)
`define WFI     (32'b0001000_00101_00000_000_00000_1110011)

module INTERRUPT_CU(clk, rst, inst, inter_DMA, inter_WDT, mie_in, mtie_in, meie_in, AXI_stall,
MEIP_en, MEIP_end, MTIP_en, MTIP_end, WFI_out, WFI_pc_en);
    
input logic clk, rst;
input logic [31:0] inst;

input logic mie_in, mtie_in, meie_in;
input logic AXI_stall;    

input logic inter_DMA, inter_WDT;       //interruput signal from DMA WDT

output logic MEIP_en, MEIP_end;      //external interrupt (DMA) begin/end
output logic MTIP_en, MTIP_end;      //time interrupt (WDT) begin/end

output logic WFI_out;               // for csr decide pc        /***********/not sure***********
output logic WFI_pc_en; 
logic MRET_en, WFI_en;      //MRET WFI happen

//CSR  
assign MRET_en = (inst == `MRET)? 1'b1 : 1'b0;
assign WFI_en =  (inst == `WFI )? 1'b1 : 1'b0;


typedef enum logic[`INTR_STATE_BITS - 1:0] { 
    IDLE = 2'b00, 
    WFI  = 2'b01, 
    TRAP = 2'b11, 
    TIMEOUT= 2'b10
} INTER_state;
INTER_state inter_cs,inter_ns;

//cs
always_ff @(posedge clk or posedge rst )
begin
    if(rst)
        inter_cs <= IDLE;
    else
        inter_cs <= inter_ns;
end

//ns
always_comb
begin
    inter_ns = inter_cs;
    case (inter_cs)
    IDLE : begin
              if (~AXI_stall) begin
                if (inter_DMA && meie_in && mie_in)
                    inter_ns = TRAP;
                else if (inter_WDT && mtie_in && mie_in)
                    inter_ns = TIMEOUT;
                else if (WFI_en)
                    inter_ns = WFI;
              end
			  else 
				inter_ns = IDLE;
           end
    WFI : begin
             if (~AXI_stall) begin
                if (inter_DMA && meie_in && mie_in)
                    inter_ns = TRAP;
                else if (inter_WDT && mtie_in && mie_in)
                    inter_ns = TIMEOUT;
                else if (WFI_en)
                    inter_ns = WFI;
             end
			 else
				inter_ns = WFI;
          end
    TRAP : begin
                if (~AXI_stall) begin
                    if (MRET_en)
                        inter_ns = IDLE;
                    else
                        inter_ns = TRAP;
                end
				else 
					inter_ns = TRAP;
           end 
     TIMEOUT : begin
                if (~AXI_stall)begin
                    if (~inter_WDT)
                        inter_ns = IDLE;
                    else 
                        inter_ns = TIMEOUT;
                end
				else 
					inter_ns = TIMEOUT;
              end
     endcase                                                                                        
end                              

//out
always_comb
begin
    case (inter_cs)
    IDLE : begin
            MEIP_end = 1'b0;
            MTIP_end = 1'b0;
            WFI_out = 1'b0;          
            if (inter_ns == TRAP) begin
                MEIP_en = 1'b1;               
                MTIP_en = 1'b0;
            end
            else if (inter_ns == TIMEOUT) begin   
                MEIP_en = 1'b0;
                MTIP_en = 1'b1;
            end
            else begin
                MEIP_en = 1'b0;
                MTIP_en = 1'b0;
            end
            if (inter_ns == WFI) 
                WFI_pc_en =1'b1;
            else 
                WFI_pc_en =1'b0;
          end
    WFI : begin
            MEIP_end = 1'b0;
            MTIP_end = 1'b0;
            WFI_out = 1'b1;          
            if (inter_ns == TRAP) begin
                MEIP_en = 1'b1;               
                MTIP_en = 1'b0;
            end
            else if (inter_ns == TIMEOUT) begin   
                MEIP_en = 1'b0;
                MTIP_en = 1'b1;
            end
            else begin
                MEIP_en = 1'b0;
                MTIP_en = 1'b0;
            end
            if (inter_ns == TRAP) 
                WFI_pc_en =1'b0;
            else 
                WFI_pc_en =1'b1;
          end
    TRAP : begin
            if (inter_ns == IDLE) MEIP_end = 1'b1;
            else MEIP_end = 1'b0;       
            MEIP_en = 1'b0;
            MTIP_en = 1'b0; 
            MTIP_end = 1'b0;
            WFI_out = 1'b0;
            WFI_pc_en =1'b0;
           end
    TIMEOUT : begin
                if (inter_ns == IDLE) MTIP_end = 1'b1;
                else MTIP_end = 1'b0;       
                MEIP_en = 1'b0;
                MEIP_end = 1'b0;

                MTIP_en = 1'b0; 
                
                WFI_out = 1'b0;
                WFI_pc_en =1'b0;
             end 
    endcase
end                                         
                         
    
    
endmodule
