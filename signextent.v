`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 21:19:23
// Design Name: 
// Module Name: signextent
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


module signextent(
	input [15:0] instruction,
	output reg [31:0] data
	);
		always @(instruction)
		begin
			if (instruction[15] == 1'b0)
				data = {16'b0000000000000000, instruction};
			else if (instruction[15] == 1'b1)
				data = {16'b1111111111111111, instruction};
		end
endmodule
