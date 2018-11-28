`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 20:55:45
// Design Name: 
// Module Name: register
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

module register(
	input clock,
	input [25:21] Readreg1,
	input [20:16] Readreg2,
	input [4:0] Writereg,
	input [31:0] Writedata,
	input RegWrite,
	output reg [31:0] Readdata1,
	output reg [31:0] Readdata2
	);
		reg [31:0] Registers[31:0];
		integer i;
		initial begin
			for (i = 0; i <= 31; i = i+1)
			begin
				Registers[i] = 32'b0;
			end
		end
		always @ (Readreg1 or Readreg2)
		begin
			Readdata1 <= Registers[Readreg1];
			Readdata2 <= Registers[Readreg2];
		end
		always @(negedge clock)
		begin
			if (RegWrite == 1)
			begin
				Registers[Writereg] <= Writedata;
			end
		end
endmodule
