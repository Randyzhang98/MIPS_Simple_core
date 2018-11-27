
`timescale 1ns / 1ps

`include "pipeline_zsj.v"

module pipeline_tb;

    integer i = 0;

	// Inputs
	reg clk;
    //wire reg [31:0] pc_out;


	// Instantiate the Unit Under Test (UUT)
	pipeline_zsj uut (
		.clk(clk)
        //.pcOut(pc_out)
	);


	initial begin
		// Initialize Inputs
		clk = 0;
        $dumpfile("pipeline.vcd");
        $dumpvars(1, uut);
        $display("Texual result of pipeline:");
        $display("==========================================================");
        #700;
        $stop;
	end

    always #10 begin
        $display("Time: %d, CLK = %d, PC = 0x%H", i, clk, uut.pcOut);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.Registers.Registers[16], uut.Registers.Registers[17], uut.Registers.Registers[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.Registers.Registers[19], uut.Registers.Registers[20], uut.Registers.Registers[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.Registers.Registers[22], uut.Registers.Registers[23], uut.Registers.Registers[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.Registers.Registers[9], uut.Registers.Registers[10], uut.Registers.Registers[11]);
        $display("[$t4] = 0x%H, [$t5] = 0x%H, [$t6] = 0x%H", uut.Registers.Registers[12], uut.Registers.Registers[13], uut.Registers.Registers[14]);
        $display("[$t7] = 0x%H, [$t8] = 0x%H, [$t9] = 0x%H", uut.Registers.Registers[15], uut.Registers.Registers[24], uut.Registers.Registers[15]);

//             $display("pc_inIF = 0x%H, jumpID = 0x%H, branchNeID = 0x%H", uut.pcInIF, uut.jumpID, uut.branchNeID);
            
//             $display("aluOpID = 0x%H, instructionIF = 0x%H, regDstID = 0x%H", uut.aluOpID, uut.instructionIF, uut.regDstID);
//             $display("aluOpEX = 0x%H, instructionID = 0x%H, regDstEX = 0x%H", uut.aluOpEX, uut.instructionID, uut.regDstEX);
//             $display("regReadData1ID = 0x%H, regReadData2ID = 0x%H, registerRsID = 0x%H", uut.regReadData1ID, uut.regReadData2ID, uut.registerRsID);
//             $display("regReadData1ID = 0x%H, regReadData2ID = 0x%H, registerRtID = 0x%H", uut.regReadData1ID, uut.regReadData2ID, uut.registerRtID);
//  $display("==========================================================");
//             $display("beq = 0x%H, pcAdd4IF = 0x%H, branchID = 0x%H", uut.branchEqID, uut.pcAdd4IF, uut.branchID);
//             $display("aluResultMEM = 0x%H, regWriteEX = 0x%H, registerMEM = 0x%H", uut.aluResultMEM, uut.regWriteEX, uut.registerMEM);
//             $display("aluResultEX = 0x%H, aluInBEX = 0x%H, aluInAEX = 0x%H", uut.aluResultEX, uut.aluInBEX, uut.aluInAEX);
//             $display("forwardA = 0x%H, forwardB = 0x%H, aluInAEX = 0x%H", uut.forwardA, uut.forwardB, uut.aluInAEX);
//             $display("regReadData1EX = 0x%H, regReadData2EX = 0x%H, aluInAEX = 0x%H", uut.regReadData1EX, uut.regReadData2EX, uut.aluInAEX);
//         $display("registerEX = 0x%H, registerMEM = 0x%H, registerWB = 0x%H", uut.registerEX, uut.registerMEM, uut.registerWB);
// $display("regWriteEX = 0x%H, regWriteMEM = 0x%H, regWriteWB = 0x%H", uut.regWriteEX, uut.regWriteMEM, uut.regWriteWB);

//  $display("==========================================================");
//             $display("regWriteDataWB = 0x%H, regWriteWB = 0x%H, registerWB = 0x%H", uut.regWriteDataWB, uut.regWriteWB, uut.registerWB);
//             $display("memReadEX = 0x%H, regWriteEX = 0x%H, memReadMEM = 0x%H", uut.memReadEX, uut.regWriteEX, uut.memReadMEM);
//             $display("registerRsID = 0x%H, registerRtID = 0x%H, registerRtEX = 0x%H", uut.registerRsID, uut.registerRtID, uut.registerRtEX);
//             $display("registerRdEX = 0x%H, regWriteMEM = 0x%H, registerMEM = 0x%H", uut.registerRdEX, uut.regWriteMEM, uut.registerMEM);
//              $display("stall = 0x%H, flushIDEX = 0x%H, registerMEM = 0x%H", uut.stall, uut.flushIDEX, uut.registerMEM);
//          $display("regReadData1NewID = 0x%H, regReadData2NewID = 0x%H, regReadDataEqID = 0x%H", uut.regReadData1NewID, uut.regReadData2NewID, uut.regReadDataEqID);
         
//                      $display("forwardC = 0x%H, forwardD = 0x%H, regReadDataEqID = 0x%H", uut.forwardC, uut.forwardD, uut.regReadDataEqID);

            // $display(" dataMem[4]= 0x%H, dataMem[8] = 0x%H, memwrite = 0x%H", uut.Data_Mem.mem[1], uut.Data_Mem.mem[2], uut.memWrite);
            // $display("----------------------------------------------------------");
        clk = ~clk;
        if (~clk) i = i + 1;
    end

endmodule
