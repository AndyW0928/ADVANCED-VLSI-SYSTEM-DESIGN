// `include "AXI_define.svh"
module Master_Read(
	input ACLK,
	input ARESETn,

	//READ ADDRESS
	output logic [`AXI_ID_BITS-1:0] ARID,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR,
	output logic [`AXI_LEN_BITS-1:0] ARLEN,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE,
	output logic [1:0] ARBURST,
	output logic ARVALID,
	input  ARREADY,
	
	//READ DATA
	input  [`AXI_ID_BITS-1:0] RID,
	input  [`AXI_DATA_BITS-1:0] RDATA,
	input  [1:0] RRESP,
	input  RLAST,
	input  RVALID,
	output logic RREADY,

	//Some input signal from CPU
	input read_signal,
	input [31:0] address_in,
	input [`AXI_ID_BITS-1:0] id_in,

	//Some output data to CPU
	output logic [31:0] data_out,
	output logic stall_IF,
	output logic rvalid_out,

	input [1:0] MW_state,
	input [1:0] MW_nstate,

	output logic [1:0] state,
	output logic [1:0] nstate
);
localparam  IDLE = 2'd0,
			WAIT_HS = 2'd1,
			ADDR = 2'd2;

// logic [1:0] state, nstate;

logic [`AXI_ADDR_BITS-1:0] ARADDR_reg;
logic [`AXI_ID_BITS-1:0] ARID_reg;
logic ARVALID_reg;
logic [31:0] RDATA_reg;

assign rvalid_out=RVALID;

//current state register
always_ff@(posedge ACLK or posedge ARESETn) begin
	if(ARESETn) state <= IDLE;
	else state <= nstate;
end

//next state logic(comb)
always@(*)begin
	case(state)
	IDLE:begin
		if(MW_state!=2'b0)begin
			nstate=IDLE;
		end
		else begin //normal
			if(ARVALID)begin
				if(ARREADY) nstate=ADDR;
				else nstate=WAIT_HS;
			end
			else begin
				nstate=IDLE;
			end			
		end
	end
	WAIT_HS:begin
		if(ARREADY) nstate=ADDR;
		else nstate=WAIT_HS;
	end
	ADDR:begin
		if(RLAST && RVALID && RREADY)	nstate=IDLE;
		else nstate=ADDR;
	end
	default: nstate=IDLE;
	endcase
end

// output logic(comb(v) or registor?)		
always@(*)begin
	case(state)
	IDLE:begin
		if(MW_state!=2'b0)begin //hold (DRAM)
			//data
			ARID=4'b0;
			ARADDR=32'b0;
			//constant
			ARLEN=4'b0;
			ARSIZE=3'b010;
			ARBURST=2'b01;
			//control signal
			ARVALID=1'b0;
			RREADY=1'b0;
			data_out=RDATA_reg;

			if(MW_nstate==2'b0) stall_IF=1'b0;
			else stall_IF=1'b1;
		end
		else begin //normal situation(read sram or ROM)
			//data
			ARID=4'b0;
			ARADDR=address_in;
			//constant
			ARLEN=4'b0;
			ARSIZE=3'b010;
			ARBURST=2'b01;
			//control signal
			ARVALID=read_signal;
			RREADY=1'b0;
			data_out=RDATA_reg;

			if(read_signal)	stall_IF=1'b1;
			else stall_IF=1'b0;	
		end

	end
	WAIT_HS:begin
		//data
		ARID=4'b0;
		ARADDR=ARADDR_reg;
		//constant
		ARLEN=4'b0;
		ARSIZE=3'b010;
		ARBURST=2'b01;
		//control signal
		ARVALID=ARVALID_reg;
		RREADY=1'b0;
		data_out=RDATA_reg;
		
		stall_IF=1'b1;
	end
	ADDR:begin
			//data
			ARID=ARID_reg;
			ARADDR=ARADDR_reg;
			//constant
			ARLEN=4'b0;
			ARSIZE=3'b010;
			ARBURST=2'b01;
			//control signal
			ARVALID=1'b0;
			RREADY=1'b1;
			if(RLAST) data_out=RDATA;
			else data_out=RDATA_reg;
			if(MW_state!=2'b0 && MW_nstate!=2'b0) stall_IF=1'b1;
			else begin
				if(RLAST) stall_IF=1'b0;
				else stall_IF=1'b1;
			end

	end
	default: begin
		//data
		ARID=4'b0;
		ARADDR=32'b0;
		//constant
		ARLEN=4'b0;
		ARSIZE=3'b010;
		ARBURST=2'b01;
		//control signal
		ARVALID=1'b0;
		RREADY=1'b0;
		data_out=32'b0;
		
		stall_IF=1'b0;
	end
	endcase
end

//data sent back
always_ff@(posedge ACLK or posedge ARESETn) begin
	if(ARESETn)begin
		ARID_reg<=4'b0;
		ARADDR_reg<=32'b0;
		ARVALID_reg<=1'b0;
		RDATA_reg<=32'b0;
	end
	else begin
		case(state)
		IDLE: begin
			ARID_reg<=id_in;
			ARADDR_reg<=address_in;
			ARVALID_reg<=read_signal;
		end
		ADDR: begin
			if(RLAST) RDATA_reg<=RDATA;
			else RDATA_reg<=RDATA_reg;
		end
		default: ;
		endcase
	end
end
endmodule
