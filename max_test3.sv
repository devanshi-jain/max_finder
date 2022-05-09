`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Triton Robosub : Electrical
// @Engineer: Devanshi Jain
// 
// Create Date: 04/24/2022 05:32:30 PM
// Design Name: 
// Module Name: max_test3
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

    logic c1, c2;

    always_comb
        s_axis_tready = s_axis_aresetn;
    // Instantiation of transaction_counter
    transaction_counter inst_transaction_counter(s_axis_tvalid, s_axis_tready, s_axis_aclk, s_axis_aresetn, c2);

    // Instantiation of max
    max_finder inst_max_finder(/*c1, */c2, s_axis_aclk, s_axis_tdata, s_axis_tlast, s_axis_aresetn/*, MAX, s_axis_tvalid*/);

endmodule



// SETTING UP COUNTER
module  transaction_counter
// transaction_counter inst_transaction(s_axis_tvalid, s_axis_tready, s_axis_aclk, s_axis_aresetn, c1, c2);
#(parameter int sampling_rate = 500)//checking for 500
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
        count <= (valid  && ready); //? count + 1: count;
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
    output logic maxm//,
    //output logic valid
);

logic [15:0] data1;
logic [15:0] data2;
logic [15:0] data3;
logic [15:0] data4;

always_ff@(posedge clk) begin

    if (!tlast) begin
        data1[15:0] <= data[15:0];
        data2[15:0] <= data[31:16];
    end
    else begin
        data3[15:0] <= data[15:0];
        data4[15:0] <= data[31:16];
    end
end

//Second register for 1st hydrophone
logic [15:0] data1_max;

always_ff@(posedge clk) begin 
    data1_max[0] = data1[0];
    for(int i=1; i<15;i++)
        if (data1_max[i-1]>data1[i]) begin
            data1_max[i] = data1_max[i-1];
        end
        else begin
            data1_max[i] = data1[i];
        end
    end

//Third register for 1st hydrophone
logic data1_final;

int max1 = 0;
for(int i=0; i<15;i++)
    if (max1 < data1_max[i]) begin
        max1 = data1_max[i];
    end
end
data1_final = max1;

//Second register for 2nd hydrophone
logic [15:0] data2_max;

always_ff@(posedge clk) begin 
    data2_max[0] = data2[0];
    for(int i=1; i<15;i++)
        if (data2_max[i-1]>data2[i]) begin
            data2_max[i] = data2_max[i-1];
        end
        else begin
            data2_max[i] = data2[i];
        end
    end

//Third register for 2nd hydrophone
logic data2_final;

int max2 = 0;
for(int i=0; i<15;i++)
    if (max2 < data2_max[i]) begin
        max2 = data2_max[i];
    end
end
data2_final = max2;

//Second register for 3rd hydrophone
logic [15:0] data3_max;

always_ff@(posedge clk) begin 
    data3_max[0] = data3[0];
    for(int i=1; i<15;i++)
        if (data3_max[i-1]>data3[i]) begin
            data3_max[i] = data3_max[i-1];
        end
        else begin
            data3_max[i] = data3[i];
        end
    end

//Third register for 3rd hydrophone
logic data3_final;

int max3 = 0;
for(int i=0; i<15;i++)
    if (max3 < data3_max[i]) begin
        max3 = data3_max[i];
    end
end
data3_final = max3;

//Second register for 4th hydrophone
logic [15:0] data4_max;

always_ff@(posedge clk) begin 
    data4_max[0] = data4[0];
    for(int i=1; i<15;i++)
        if (data4_max[i-1]>data4[i]) begin
            data4_max[i] = data4_max[i-1];
        end
        else begin
            data4_max[i] = data4[i];
        end
    end

//Third register for 4th hydrophone
logic data4_final;

int max4 = 0;
for(int i=0; i<15;i++)
    if (max4 < data4_max[i]) begin
        max4 = data4_max[i];
    end
end
data4_final = max4;


//at reset move maximum into output and reset internal max.





     
endmodule