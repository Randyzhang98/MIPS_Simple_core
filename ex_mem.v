`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 00:39:35
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM (
    input               clk,

    input       [31:0]  EX_ALU_out,
                        EX_register_read_data2,
    input       [4:0]   EX_register_addr,
    input               EX_MemRead,
                        EX_MemtoReg,
                        EX_MemWrite,
                        EX_RegWrite,

    output reg  [31:0]  MEM_ALU_out,
                        MEM_register_read_data2,
    output reg  [4:0]   MEM_register_addr,
    output reg          MEM_MemRead,
                        MEM_MemtoReg,
                        MEM_MemWrite,
                        MEM_RegWrite
);

    initial begin
        MEM_ALU_out    = 32'b0;
        MEM_register_read_data2 = 32'b0;
        MEM_register_addr     = 5'b0;
        MEM_MemRead      = 1'b0;
        MEM_MemtoReg     = 1'b0;
        MEM_MemWrite     = 1'b0;
        MEM_RegWrite     = 1'b0;
    end

    always @ (posedge clk) begin
        MEM_ALU_out    <= EX_ALU_out;
        MEM_register_read_data2 <= EX_register_read_data2;
        MEM_register_addr     <= EX_register_addr;
        MEM_MemRead      <= EX_MemRead;
        MEM_MemtoReg     <= EX_MemtoReg;
        MEM_MemWrite     <= EX_MemWrite;
        MEM_RegWrite     <= EX_RegWrite;
    end

endmodule // EX_MEM
