`ifndef MODULE_DATAMEM
`define MODULE_DATAMEM

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 00:51:02
// Design Name: 
// Module Name: Data_mem
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


module Data_mem(Address, Write_data, Read_data, MemRead, MemWrite, clk);
    input [31:0] Address, Write_data;
    input MemRead, MemWrite, clk;
    output reg [31:0] Read_data;
    reg [31:0] mem[31:0];

    always @ (posedge clk)
    begin
        if (MemWrite) mem[Address >> 2] = Write_data; 
    end

    always @ (negedge clk)
    begin
        if (MemRead) Read_data = mem[Address >> 2];
    end

endmodule

`endif