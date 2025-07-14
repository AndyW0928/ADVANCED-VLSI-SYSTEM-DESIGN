//mepc not sure*************

module CSR(clk, rst, pc_c, pc_E, rs1_data, inst, stall, AXI_stall, 
MEIP_en, MTIP_en, MEIP_end, MTIP_end, WFI_in,
csr_data, pc_CSR,
mie_out, mtie_out, meie_out);

input logic clk, rst;
input logic [31:0] pc_c;              //current pc
input logic [31:0] pc_E;              //EXE cycle pc  
input logic [31:0] rs1_data;        //rs1 data for CSRRW, CSRRS, CSRRC
input logic [31:0] inst;
input logic stall, AXI_stall;
input logic MEIP_en, MEIP_end;      //external interrupt (DMA) begin/end
input logic MTIP_en, MTIP_end;      //time interrupt (WDT) begin/end
input logic WFI_in;                 //from interrupt cu**************not sure****************

output logic [31:0] csr_data;
output logic [31:0] pc_CSR;         //pc for interrupt

output logic mie_out, mtie_out, meie_out;

//machine mode CSR
localparam MSTATUS = 12'h300;
localparam MIE = 12'h304;
localparam MIP = 12'h344;
localparam MTVEC = 12'h305;
localparam MEPC = 12'h341;

localparam RDINSTRET = 12'hc02;
localparam RDINSTRETH = 12'hc82;
localparam RDCYCLE = 12'hc00;
localparam RDCYCLEH = 12'hc80;

//Mnemonic
localparam CSRRW  = 3'b001;
localparam CSRRS  = 3'b010;
localparam CSRRC  = 3'b011;
localparam CSRRWI = 3'b101;
localparam CSRRSI = 3'b110;
localparam CSRRCI = 3'b111;

logic [63:0] csr_inst, csr_cycle;
logic [31:0] mstatus_r, mie_r, mip_r, mtvec_r, mepc_r;

logic  csr_func3;
logic csr_en;

//decode
logic [11:0] csr_imm;
logic [4:0] rs1;
logic [31:0] uimm;
logic [2:0] func3;
logic [4:0] rd;
logic [6:0] op;

assign csr_imm = inst[31:20];
assign rs1 = inst[19:15];
assign uimm = {27'b0,rs1};
assign func3 = inst[14:12];
assign rd = inst[11:7];
assign op = inst[6:0];


assign csr_func3 = (func3 != (3'b000 | 3'b100))? 1'b1 : 1'b0;     //func3 for CSR inst without  MRET WFI
assign csr_en = (csr_func3 && (op == 7'b1110011))? 1'b1 : 1'b0;    //op for CSR


//for interrupt cu
assign mie_out = mstatus_r[3];
assign mtie_out = mie_r[7]; 
assign meie_out = mie_r[11]; 

always_comb 
begin
    if (rd != 5'b0) begin
        case(inst[31:20])
        RDINSTRET : csr_data = csr_inst[31:0];      //CSR INSTRET
        RDINSTRETH : csr_data = csr_inst[63:32];
        RDCYCLE : csr_data = csr_cycle[31:0];       //CSR  CYCLE
        RDCYCLEH : csr_data = csr_cycle[63:32];
        
        MSTATUS : csr_data = mstatus_r;             //[3]:MIE   [7]: MPIE   [12:11]: MPP
        MIE : csr_data = mie_r;                    //[7]:MTIE   [11]:MEIE
        MIP : csr_data = mip_r;                    //[7]:MTIP   [11]:MEIP
        MTVEC : csr_data = mtvec_r;                 //pc for interrupt
        MEPC : csr_data = mepc_r;                   //pc before trap
        default : csr_data = 32'b0;
        endcase
    end
    else 
    csr_data = 32'b0;
end


assign mtvec_r = 32'h0001_0000;                 // IM address
assign mip_r = {20'b0, MEIP_en, 3'b0, MTIP_en, 7'b0}; 

always_ff @(posedge clk or posedge rst)
begin
    if (rst) begin
        mstatus_r <= 32'b0;
        mie_r <= 32'b0;
 //       mip_r <= 32'b0;
 //       mtvec_r <= 32'b0;
        mepc_r <= 32'b0;
    end
    else begin
        if (AXI_stall) begin
        mstatus_r <= mstatus_r;
        mie_r <= mie_r;
        mepc_r <= mepc_r;
        end
        else begin
            if (csr_en /*& (rd != 5'b0)*/) begin
                case (csr_imm)
                MSTATUS : begin
                         case (func3)
                         CSRRW : begin
                                if (rs1 == 5'b0)
                                mstatus_r <= 32'b0;
                                else 
                                mstatus_r <= {19'b0,rs1_data[12:11],3'b0,rs1_data[7],3'b0,rs1_data[3],3'b0};
                                end
                        CSRRS : begin
                                if (rs1 == 5'b0)
                                mstatus_r <= 32'b0;
                                else 
                                mstatus_r <= mstatus_r | {19'b0,rs1_data[12:11],3'b0,rs1_data[7],3'b0,rs1_data[3],3'b0};
                                end  
                        CSRRC : begin
                                if (rs1 == 5'b0)
                                mstatus_r <= 32'b0;
                                else 
                                mstatus_r <= mstatus_r & (~{19'b0,rs1_data[12:11],3'b0,rs1_data[7],3'b0,rs1_data[3],3'b0});
                                end                     
                        CSRRWI : begin
                                mstatus_r <= {19'b0,uimm[12:11],3'b0,uimm[7],3'b0,uimm[3],3'b0};
                                end 
                        CSRRSI : begin
                                mstatus_r <= mstatus_r | {19'b0,uimm[12:11],3'b0,uimm[7],3'b0,uimm[3],3'b0};
                                end 
                        CSRRCI : begin 
                                mstatus_r <= mstatus_r & (~{19'b0,uimm[12:11],3'b0,uimm[7],3'b0,uimm[3],3'b0});
                                end
                        default: ;
                        endcase
                        end                                            
                MIE : begin
                         case (func3)
                         CSRRW : begin
                                if (rs1 == 5'b0)
                                mie_r <= 32'b0;
                                else 
                                mie_r <= {20'b0,rs1_data[11],3'b0,rs1_data[7],7'b0};
                                end
                        CSRRS : begin
                                if (rs1 == 5'b0)
                                mie_r <= 32'b0;
                                else 
                                mie_r <= mie_r | {20'b0,rs1_data[11],3'b0,rs1_data[7],7'b0};
                                end  
                        CSRRC : begin
                                if (rs1 == 5'b0)
                                mie_r <= 32'b0;
                                else 
                                mie_r <= mie_r & (~{20'b0,rs1_data[11],3'b0,rs1_data[7],7'b0});
                                end                     
                        CSRRWI : begin
                                mie_r <= {20'b0,uimm[11],3'b0,uimm[7],7'b0};
                                end 
                        CSRRSI : begin
                                mie_r <= mie_r | {20'b0,uimm[11],3'b0,uimm[7],7'b0};
                                end 
                        CSRRCI : begin 
                                mie_r <= mie_r & (~{20'b0,uimm[11],3'b0,uimm[7],7'b0});
                                end
                        default: ;
                        endcase
                        end  
                MEPC : begin
                         case (func3)
                         CSRRW : begin
                                if (rs1 == 5'b0)
                                mepc_r <= 32'b0;
                                else 
                                mepc_r <= rs1_data;
                                end
                        CSRRS : begin
                                if (rs1 == 5'b0)
                                mepc_r <= 32'b0;
                                else 
                                mepc_r <= mepc_r | rs1_data;
                                end  
                        CSRRC : begin
                                if (rs1 == 5'b0)
                                mepc_r <= 32'b0;
                                else 
                                mepc_r <= mepc_r & (~rs1_data);
                                end                     
                        CSRRWI : begin
                                mepc_r <= uimm;
                                end 
                        CSRRSI : begin
                                mepc_r <= mepc_r | uimm;
                                end 
                        CSRRCI : begin 
                                mepc_r <= mepc_r & (~uimm);
                                end
                        default: ;
                        endcase
                        end
                        
                endcase            
            end              
            else begin
                if (MEIP_en || MTIP_en) begin        //interrupt happen
                    mstatus_r[7] <= mstatus_r[3];       //[3]:MIE   [7]: MPIE   [12:11]: MPP
                    mstatus_r[12:11] <= 2'b11;
                    mstatus_r[3] <= 1'b0;
                    if (~WFI_in) mepc_r <= pc_E;                    //mepc  **********not sure*************
                    else mepc_r <= pc_c - 32'd4;                          //not sure*********
                end
                else if (MEIP_end || MTIP_end) begin  //interrupt end
                    mstatus_r[3] <= mstatus_r[7];       //[3]:MIE   [7]: MPIE   [12:11]: MPP
                    mstatus_r[12:11] <= 2'b11;
                    mstatus_r[7] <= 1'b1;
                    mepc_r <= 32'b0;
                end    
                else begin
                    mstatus_r <= mstatus_r;
                    mepc_r <= mepc_r;
                end
           end
        end            
    end
end


//pc_CSR
always_comb
begin
    if (MEIP_en || MTIP_en) 
        pc_CSR = mtvec_r;
    else if (MEIP_end || MTIP_end) 
        pc_CSR = mepc_r;
    else
        pc_CSR = 32'b0;     //maybe should choose other pc
end                



//INSTRET
// always_ff @(posedge clk or posedge rst )
// begin
//     if (rst) 
//         csr_inst <= 64'b1;
//     else if (pc_E != 32'b0 && ~AXI_stall)
//         csr_inst <= csr_inst + 64'b1;
// end
    // Always block to update the instruction count on each clock cycle
    always_ff @(posedge clk or posedge rst) begin : CSR_instrets
        if (rst) begin 
            csr_inst <= 64'b0;  // Reset instruction count to 0
        end 
        else if (csr_cycle == 64'd1) begin
            csr_inst <= 64'd1;   // Initialize instruction count to 1 on first cycle
        end
        else if (pc_E != 32'b0 && ~AXI_stall)
            csr_inst <= csr_inst + 64'b1;        
    end

//CYCLE
always_ff @(posedge clk or posedge rst )
begin
    if (rst) 
        csr_cycle <= 64'b0;
    else 
        csr_cycle <= csr_cycle + 64'b1;
end        
            


endmodule
