`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 00:42:29
// Design Name: 
// Module Name: IF_ID
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

module IF_ID (
    input               clk,
                        stall,
                        IF_ID_flush,
    input       [31:0]  IF_ra,
                        IF_ins,
    output reg  [31:0]  ID_ra,
                        ID_ins
);

    initial begin
        ID_ra = 32'b0;
        ID_ins = 32'b0;
    end

    always @ (posedge clk) begin
        if (IF_ID_flush) begin
            ID_ra <= 32'b0;
            ID_ins <= 32'b0;
        end else if (!stall) begin
            ID_ra <= IF_ra;
            ID_ins <= IF_ins;
        end
    end

endmodule // IF_ID
