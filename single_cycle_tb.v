
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:   00:39:53 11/20/2017
// Design Name:   single_cycle
// Module Name:   /home/liu/VE370/p2/single_cycle_tb.v
// Project Name:  p2
// Target Device:
// Tool versions:
// Description:
//
// Verilog Test Fixture created by ISE for module: single_cycle
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////

`include "single_cycle.v"

module single_cycle_tb;

    integer i = 0;

	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	single_cycle uut (
		.clk(clk)
	);


	initial begin
		// Initialize Inputs
		clk = 0;
        $dumpfile("single_cycle.vcd");
        $dumpvars(1, uut);
        $display("Texual result of single cycle:");
        $display("==========================================================");
        #440;
        $display("==========================================================");
        $stop;
	end

    always #10 begin
        $display("Time: %d, CLK = %d, PC = 0x%H", i, clk, uut.pc_out);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.registers.Registers[16], uut.registers.Registers[17], uut.registers.Registers[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.registers.Registers[19], uut.registers.Registers[20], uut.registers.Registers[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.registers.Registers[22], uut.registers.Registers[23], uut.registers.Registers[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.registers.Registers[9], uut.registers.Registers[10], uut.registers.Registers[11]);
        $display("[$t4] = 0x%H, [$t5] = 0x%H, [$t6] = 0x%H", uut.registers.Registers[12], uut.registers.Registers[13], uut.registers.Registers[14]);
        $display("[$t7] = 0x%H, [$t8] = 0x%H, [$t9] = 0x%H", uut.registers.Registers[15], uut.registers.Registers[24], uut.registers.Registers[15]);

            // $display("regReadData1 = 0x%H, regReadData2 = 0x%H, aa = 0x%H", uut.regReadData1, uut.regReadData2, uut.aa);
            // $display("regReadData1 = 0x%H, regReadData2 = 0x%H, bb = 0x%H", uut.regReadData1, uut.regReadData2, uut.bb);
            // $display("op = 0x%H, ins = 0x%H, regDst = 0x%H", uut.ALU_op, uut.instruction_out, uut.regDst);
            // $display("beq = 0x%H, ra = 0x%H, zero = 0x%H", uut.beq, uut.ra, uut.zero);
            //             $display("ALU_in1 = 0x%H, ALU_in2 = 0x%H, reg-write-add = 0x%H", uut.ALU_in1, uut.ALU_in2, uut.regWrite_add);

            // $display("ALU_result = 0x%H, regwrite = 0x%H, reg-write-add = 0x%H", uut.ALU_out, uut.regWrite, uut.regWrite_add);
            // $display("regWriteData = 0x%H, ra = 0x%H, zero = 0x%H", uut.regWriteData, uut.ra, uut.zero);
            // $display(" dataMem[4]= 0x%H, dataMem[8] = 0x%H, memwrite = 0x%H", uut.Data_Mem.mem[1], uut.Data_Mem.mem[2], uut.memWrite);
            // $display("----------------------------------------------------------");
        clk = ~clk;
        if (~clk) i = i + 1;
    end

endmodule
