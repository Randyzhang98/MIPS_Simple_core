`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/13 01:09:05
// Design Name: 
// Module Name: branch_pc
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


module branch_pc(ra, branch_shamt, jump_address, Jump, Beq, Bne, PC_write, Zero);
    input [31:0] ra, branch_shamt, jump_address;
    input Jump, Beq, Bne, Zero;
    output reg [31:0] PC_write;

    always @ (ra or branch_shamt or jump_address or Jump or Beq or Bne or Zero)
    begin
        if (  (Bne == 0 & Beq == 1 & Zero == 1) | (Bne == 1 & Beq == 0 & Zero == 0) ) PC_write = branch_shamt;
        else if ( Jump == 1 ) PC_write = jump_address;
        else PC_write = ra;

    end


endmodule
