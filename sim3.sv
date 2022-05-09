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
        .s_axis_aclk(ACLK),
        .s_axis_aresetn(ARESET_n),
        .s_axis_tready(TREADY),
        .s_axis_tdata(TDATA),
        .s_axis_tlast(TLAST),
        .s_axis_tvalid(TVALID)
        ); 

    initial begin
        ACLK = 0;
        ARESET_n = 0; //resets everything (global) (active mode)
         #20ns ARESET_n = 1; //after two clock cycles set it to 1
        //default timescale is a nanosecond
    #10;
    TVALID = 1;
    end

    always@(ACLK)
            #10ns ACLK <= !ACLK;


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
