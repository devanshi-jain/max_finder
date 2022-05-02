//@author : Ravi Johnson

`timescale 1ns / 1ps
//`include "width_defs.vh"

//AXI-Stream interface definition
module sim3 #(parameter STREAM_WIDTH = 32);
    logic[STREAM_WIDTH-1:0]  TDATA;
    logic                    TVALID;
    logic                    TLAST;
    logic                    TREADY;
    //unused in this design, since clk/rst is global
    logic                    ACLK;
    logic                    ARESET_n;

    maxtest3 design_inst(
        ACLK,
        ARESET_n,
        TREADY,
        TDATA,
        TLAST,
        TVALID
        ); 
    
    always@(ACLK) 
        #10ns ACLK <= !ACLK;

    initial begin
    #10;
    TVALID = 1;
    end
    
    always@(posedge ACLK)
        if(TVALID & TDATA) begin 
            if(TLAST) begin
                TDATA = $urandom_range(0,65000);
                #1 TLAST = !TLAST;
            end else begin 
                TDATA = $urandom_range(0,65000);
                #1 TLAST = !TLAST;
            end
        end

endmodule
