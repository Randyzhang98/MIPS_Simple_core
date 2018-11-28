`ifndef MODULE_MUX
`define MODULE_MUX


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 00:40:55
// Design Name: 
// Module Name: mux
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


module mux(in1, in2, select, out);
    parameter max = 31;
    input [max:0] in1, in2;
    input select;
    output [max:0] out;

    assign out = (select == 0) ? in1 : in2;

endmodule

`endif