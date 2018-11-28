`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/12 22:41:18
// Design Name: 
// Module Name: ALU
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

module ALU(ALU_in1, ALU_in2, ALU_control, Zero, result);
    input [31:0] ALU_in1, ALU_in2;
    input [3:0] ALU_control;
    output Zero;
    output [31:0] result;
    reg [31:0] result;

    assign Zero = (result == 0);

    initial begin
      result = 0;
    end

    always @ (ALU_in1 or ALU_in2 or ALU_control)
    begin
        if (ALU_control == 4'b0000) result = ALU_in1 & ALU_in2;
        else if (ALU_control == 4'b0001) result = ALU_in1 | ALU_in2;
        else if (ALU_control == 4'b0010) result = ALU_in1 + ALU_in2;
        else if (ALU_control == 4'b0110) result = ALU_in1 - ALU_in2;
        else if (ALU_control == 4'b0111) begin
            if (ALU_in1 < ALU_in2) result = 1;
            else result = 0;
            end
        else if (ALU_control == 4'b1100) result = ~ (ALU_in1 | ALU_in2);
    end


endmodule

