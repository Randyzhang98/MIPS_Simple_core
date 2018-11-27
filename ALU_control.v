
`ifndef MODULE_ALUCONTROL
`define MODULE_ALUCONTROL

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/12 22:06:17
// Design Name: 
// Module Name: ALU_control
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


module ALU_control(ALU_op, funct, control_out);
    input [1:0] ALU_op;
    input [5:0] funct;
    output [3:0] control_out;
    reg [3:0] control_out;

    always @ (funct, ALU_op)
    begin
        if (ALU_op == 2'b00) control_out = 4'b0010;
        else if (ALU_op == 2'b01) control_out = 4'b0110;
        else if (ALU_op == 2'b11) control_out = 4'b0000;
        else if (ALU_op == 2'b10) 
        begin
            case (funct)
                6'b100000:
                    control_out = 4'b0010; //add
                6'b100010:
                    control_out = 4'b0110; //sub
                6'b100100:
                    control_out = 4'b0000; //and
                6'b100101:
                    control_out = 4'b0001; //or
                6'b101010:
                    control_out = 4'b0111; //set_less_than
                default: ;
            endcase;
        end
    end

endmodule

`endif