`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Triton Robosub : Electrical
// @Engineer: Devanshi Jain
// 
// Create Date: 04/24/2022 05:32:30 PM
// Design Name: 
// Module Name: maxtest3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//INPUT AXI STREAM
module maxtest3 #(
    parameter integer C_S_AXIS_TDATA_WIDTH = 32 
    )
    //Ports of Axi Slave  Bus Interface S_AXIS
    (
    input logic s_axis_aclk,
    input logic s_axis_aresetn,
    output logic s_axis_tready,
    input logic [C_S_AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input logic s_axis_tlast,
    input logic s_axis_tvalid
    );
    
    //Instantiation of Axi Bus Interface S_AXIS,
//    sample_generator_v1_0_S_AXIS #(
//        .C_S_AXIS_TDATA_WIDTH( C_S_AXIS_TDATA_WIDTH)
////    ) 
////    sample_generator_v1_0_S_AXIS_inst 
////    (
//        .En(En),
//        .S_AXIS_ACLK(s_axis_aclk),
//        .S_AXIS_ARESETN(s_axis_aresetn),
//        .S_AXIS_TREADY(s_axis_tready),
//        .S_AXIS_TDATA(s_axis_data),
//        .S_AXIS_TLAST(s_axis_tlast),
//        .S_AXIS_TVALID(s_axis_tvalid)
//    );

    logic c1, c2;
    // Instantiation of transaction_counter
    transaction_counter inst_transaction_counter(s_axis_tvalid, s_axis_tready, s_axis_aclk, s_axis_aresetn, c2);

    // Instantiation of max
    max_finder inst_max_finder(/*c1, */c2, s_axis_aclk, s_axis_tdata, s_axis_tlast, s_axis_aresetn/*, MAX*/, s_axis_tvalid);

endmodule

// SETTING UP COUNTER
module  transaction_counter
// transaction_counter inst_transaction(s_axis_tvalid, s_axis_tready, s_axis_aclk, s_axis_aresetn, c1, c2);
#(parameter int sampling_rate = 500000)
(
    input logic valid,
    input logic ready,
    input logic clk,
    input logic resetn,
    //output logic[31:0] count, // how many transactions you've seen so far
    output logic count_flag //only 1 bit clock signal rqd to clear the maxm bit //OVERFLOW STREAM
);

logic[31:0] count;
//sequential -> non-blocking assignment
//combinational -> blocking assignment
always_ff@(posedge clk) begin
    if (! resetn) //reset is active in low signal
        count <= 0; //set transactions to 0 for initial
    else begin
        if (count == sampling_rate) begin
            count <= 0;
            count_flag <= 1;
        end
        else
            count <= (valid == 1 & ready == 1) ? count + 1: count;
    end
end

endmodule

// MAX-FINDER : Take in different channels at specific tlast values
module max_finder 
// max inst_max(c2, s_axis_aclk, s_axis_tdata, s_axis_tlast, s_axis_aresetn/*, MAX*/, s_axis_tvalid);
(
    //input logic[31:0] count, // how many transactions you've seen so far
    input logic count_flag,
    input logic clk,
    input logic [31:0] data,
    input logic tlast,
    input logic resetn,
    output logic maxm,
    output logic valid
);

logic [15:0] data1;
logic [15:0] data2;
logic [15:0] data3;
logic [15:0] data4;
always_ff@(posedge clk) begin /*use of negedge reset??*/
    // using tlast to find respective channel numbers 
    if (!tlast) begin
        data1[15:0] <= data[15:0];
        data2[15:0] <= data[31:16];
    end
    else begin
        data3[15:0] <= data[15:0];
        data4[15:0] <= data[31:16];
    end
    //accumulate maximum??
    end


endmodule
