// `include "../include/AXI_define.svh"

module Slave_Selection (
    input logic ACLK,
    input logic ARESETn,
    input logic ARVALID,
    input logic AWVALID,
    input logic RLAST,
    input logic WLAST,
    output [1:0] selection
);

    typedef enum logic [0:0] {IDLE = 1'd0, BUSY = 1'd1} StateType;
    typedef enum logic [1:0] {FREE = 2'd0, READ = 2'd1, WRITE = 2'd2, WRONG = 2'd3} SelectType;

    StateType state, nstate;
    SelectType select, select_reg;
    assign selection = select;
    // State transition logic
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn)  
            state <= IDLE;
        else 
            state <= nstate;
    end

    // Next state logic
    always_comb begin
        case (state)
            IDLE:
                if (ARVALID || AWVALID) 
                    nstate = BUSY;
                else 
                    nstate = IDLE;

            BUSY:
                if (RLAST || WLAST) 
                    nstate = IDLE;
                else 
                    nstate = BUSY;

            // default: 
            //     nstate = IDLE;
        endcase
    end

    // Select control logic
    always_comb begin
        case (state)
            IDLE: begin
                if (AWVALID) 
                    select = (~ARVALID) ? WRITE : WRONG;
                else if (ARVALID) 
                    select = (~AWVALID) ? READ : WRONG;
                else 
                    select = FREE;
            end
            BUSY: 
                select = select_reg;

            // default: 
            //     select = FREE;
        endcase
    end
    always_ff @(posedge ACLK or posedge ARESETn) begin
        if (ARESETn) 
            select_reg <= FREE;
        else if (state == IDLE)
            select_reg <= select;
    end

endmodule
