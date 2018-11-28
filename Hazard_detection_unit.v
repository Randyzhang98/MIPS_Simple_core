`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 00:40:59
// Design Name: 
// Module Name: Hazard_detection_unit
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


module Hazard_detection_unit (
    input               ID_EX_MemRead,
                        ID_EX_regWrite,
                        EX_MEM_MemRead,
                        ID_branch_comp_re,
    input       [5:0]   ins_op,
    input       [4:0]   IF_ID_RegisterRs,
                        IF_ID_RegisterRt,
                        ID_EX_RegisterRt,
                        ID_EX_RegisterRd,
                        EX_MEM_RegisterRd,
    output reg          stall,
                        flushIDEX,
                        flushIFID
);

    initial begin
        stall = 1'b0;
        flushIDEX = 1'b0;
        flushIFID = 1'b0;
    end

    always @ ( * ) begin
        if (ID_EX_MemRead && ID_EX_RegisterRt && (ID_EX_RegisterRt == IF_ID_RegisterRs || ID_EX_RegisterRt == IF_ID_RegisterRt)) begin
            // $display("0000000000000000000");
            stall = 1'b1;
            flushIDEX = 1'b1;
            flushIFID = 1'b0;
        end else if ( ( (ins_op == 6'b000100) || (ins_op == 6'b000101) )) begin
            if (ID_branch_comp_re) flushIFID = 1'b1;

            if ( (ID_EX_regWrite && ID_EX_RegisterRd && (ID_EX_RegisterRd == IF_ID_RegisterRs || ID_EX_RegisterRd == IF_ID_RegisterRt)) ) 
            begin
                        // $display("1111111111111111111");

                stall = 1'b1;
                flushIDEX = 1'b1;
            end 
            else if ( (EX_MEM_MemRead && EX_MEM_RegisterRd && (EX_MEM_RegisterRd == IF_ID_RegisterRs || EX_MEM_RegisterRd == IF_ID_RegisterRt) ) )
            begin
            // $display("2222222222222222222222222222");
                stall = 1'b1;
                flushIDEX = 1'b1;
            end

            else 
            begin
            // $display("33333333333333333333333333");
                stall = 1'b0;
                flushIDEX = 1'b0;
            end
        end 
        else if ( ins_op == 6'b000010 )
        begin
        // $display("44444444444444444");
            stall = 1'b0;
            flushIDEX = 1'b0;
            flushIFID = 1'b1;
        end
        else 
        begin
        // $display("55555555555555");
            stall = 1'b0;
            flushIDEX = 1'b0;
            flushIFID = 1'b0;
        end
    end

endmodule
