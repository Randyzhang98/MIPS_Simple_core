`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/12 21:52:03
// Design Name: 
// Module Name: ALU_branch
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

module ALU_branch(ra, imd_add, out);
    input [31:0] ra, imd_add;
    output [31:0] out;
    reg [31:0] out;

    always @(ra or imd_add)
    begin
        out = ra + (imd_add << 2);
    end     

endmodule
