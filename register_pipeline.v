
`ifndef MODULE_REGISTER
`define MODULE_REGISTER

`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
//
//
//
//
//
////////////////////////////////////////////////////////////////
module register_pipeline(
	input clock,
	input [4:0] Readreg1,
	input [4:0] Readreg2,
	input [4:0] ReadregExtra, 
	input [4:0] Writereg,
	input [31:0] Writedata,
	input RegWrite,
	output reg [31:0] Readdata1,
					 Readdata2,
						ReaddataExtra
	);
		reg [31:0] Registers[31:0];
		integer i;
		initial begin
			for (i = 0; i <= 31; i = i+1)
			begin
				Registers[i] = 32'b0;
			end
		end
		always @ ( * )
		begin
			Readdata1 = Registers[Readreg1];
			Readdata2 = Registers[Readreg2];
			ReaddataExtra = Registers[ReadregExtra];
		end
		always @(negedge clock)
		begin
			if (RegWrite == 1)
			begin
				Registers[Writereg] = Writedata;
			end
		end
endmodule


`endif