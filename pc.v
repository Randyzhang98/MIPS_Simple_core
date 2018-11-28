`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 00:45:05
// Design Name: 
// Module Name: PC
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


module PC (
    input               clk,
                        stall,
    input       [31:0]  in,
    output reg  [31:0]  out
);

    initial begin
        out = 32'b0;
    end

    always @ (posedge clk) begin
        if (!stall)
            out <= in;
    end

endmodule // PC
