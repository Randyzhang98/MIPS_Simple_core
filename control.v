`ifndef MODULE_CONTROL
`define MODULE_CONTROL

`timescale 1ns / 1ps
///////////////////////////////////////////////////////////
//
//
//
//
//
///////////////////////////////////////////////////////////
module control(
	input wire [5:0] opcode,
	output reg RegDst,
	output reg Jump,
	output reg Branch,
	output reg Bne,
	output reg MemRead,
	output reg MemtoReg,
	output reg [1:0] ALUOp,
	output reg MemWrite,
	output reg ALUSrc,
	output reg RegWrite
	);

		initial begin
        RegDst     <=1'b0;
        Jump       <=1'b0;
        Branch   <=1'b0;
        Bne   <=1'b0;
        MemRead    <=1'b0;
        MemtoReg   <=1'b0;
        MemWrite   <=1'b0;
        ALUSrc     <=1'b0;
        RegWrite   <=1'b0;
        ALUOp      <=2'b00;
    	end



		always @(opcode) 
		begin
			case (opcode)
				// R
				6'b000000:
				begin
					RegDst<=1;
					Jump<=0;
					Branch<=0;
					Bne<=0;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b10;
					MemWrite<=0;
					ALUSrc<=0;
					RegWrite<=1;
				
				end
				// lw
				6'b100011:
				begin
					RegDst<=0;
					Jump<=0;
					Branch<=0;
					Bne<=0;
					MemRead<=1;
					MemtoReg<=1;
					ALUOp<=2'b00;
					MemWrite<=0;
					ALUSrc<=1;
					RegWrite<=1;
				end
				// sw 
				6'b101011:
				begin
					RegDst<=1;
					Jump<=0;
					Branch<=0;
					Bne<=0;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b00;
					MemWrite<=1;
					ALUSrc<=1;
					RegWrite<=0;
				end
				// branch
				6'b000100:
				begin
					RegDst<=0;
					Jump<=0;
					Branch<=1;
					Bne<=0;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b01;
					MemWrite<=0;
					ALUSrc<=0;
					RegWrite<=0;
				end
				//bne
				6'b000101:
				begin
					RegDst<=0;
					Jump<=0;
					Branch<=0;
					Bne<=1;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b01;
					MemWrite<=0;
					ALUSrc<=0;
					RegWrite<=0;
				end

				// jump
				6'b000010:
				begin
					RegDst<=0;
					Jump<=1;
					Branch<=0;
					Bne<=0;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b00;
					MemWrite<=0;
					ALUSrc<=0;
					RegWrite<=0;
				end

				// addi
				6'b001000:
				begin
					RegDst<=0;
					Jump<=0;
					Branch<=0;
					Bne<=0;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b00;
					MemWrite<=0;
					ALUSrc<=1;
					RegWrite<=1;
				end
				// andi
				6'b001100:
				begin
					RegDst<=0;
					Jump<=0;
					Branch<=0;
					Bne<=0;
					MemRead<=0;
					MemtoReg<=0;
					ALUOp<=2'b11;
					MemWrite<=0;
					ALUSrc<=1;
					RegWrite<=1;
				end
				default:;
			endcase
		end

endmodule


`endif