`ifndef MODULE_PIPELINE
`define MODULE_PIPELINE
`timescale 1ns / 1ps

`include "ALU_branch.v"
`include "ALU_control.v"
`include "ALU.v"
`include "control.v"
`include "instruction.v"
`include "mux.v"
`include "register.v"
`include "Data_mem.v"
`include "signextent.v"
`include "branch_pc.v"
`include "pc.v"
`include "Looking_forward_detection.v"
`include "Hazard_detection_unit.v"
// `include "branch_eq.v"

//////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//////////////////////////////////////////////////////////////////////////////////
module pipeline(
	input   clk,
    	input   [4:0]   regIn,
    	output  [31:0]  pcOut
                        regOut
);	 
	wire clk;

	// IF Stage

	// PC
	reg [31:0] PC_inIF;
	wire [31:0] PC_Add4IF;
	wire [31:0] JumpAddrID;
	wire [31:0] BranchAddrIF;
	wire [31:0] NextPCIF;
	wire [31:0] raIF;
	wire [31:0] imd_addIF;
	 
	// Instruction
	wire [31:0] InstructionIF;
	
	// ID Stage

	wire [4:0] 	RegisterRsID,
				RegisterRtID,
				RegisterRdID;

	
	// Control
	wire RegDstID;
	wire JumpID;
	wire BranchID;
	wire BneID;
	wire MemReadID;
        wire MemtoRegID;
	wire[1:0] ALUOpID;
	wire MemWriteID;
	wire ALUSrcID;
	wire RegWriteID;
	wire ZEROID;

	wire branch_eq_in1_sel;
	wire branch_eq_in2_sel;

	wire [31:0] branch_eq_in1;
	wire [31:0] branch_eq_in2;

	// Register
	wire [4:0] RegReadReg1ID;
	wire [4:0] RegReadReg2ID;
	wire [31:0] RegReadData1ID;
	wire [31:0] RegReadData2ID;
	wire [4:0] RegWriteRegID;
	wire [31:0] RegWriteDataID;

	// Signextent
	wire SignextentID;

	reg [31:0] PC_Add4ID;
	reg [31:0] InstructionID;

	// EX Stage
	
	// ALUCtr
	wire [5:0] FUNCTEX;
	wire [3:0] ALUctrEX;
	reg [31:0] RegReadData1EX;
	reg [31:0] RegReadData2EX;
	reg [4:0] RegisterRtEX;
	reg [4:0] RegisterRdEX;
	reg [4:0] RegisterRsEX;
	reg [4:0] RegisterRd_final_EX;
	reg RegDstEX;
	reg [31:0] PC_Add4EX;

	// ALU
	wire ZEROEX;
	wire [31:0] ALUoutEX;
	wire [31:0] ALUin1EX;
	wire [31:0] ALUin2EX;
	wire [31:0] ALUin2EX_front;
	reg [1:0] ALUOpEX;
	reg ALUSrcEX;
	reg BranchEX;
	reg MemReadEX;
	reg MemWriteEX;
	reg MemtoRegEX;
	reg RegWriteEX;
	
	// MEM Stage

	// Memory
	wire [31:0] MemReadDataMEM;
	wire reg [31:0] MemWriteDataMEM;
	wire [31:0] MemAddrMEM;
	reg [31:0] ALU_resultMEM;
	reg [4:0] RegisterRdMEM;
	reg BranchMEM;
	reg MemReadMEM;
	reg MemWriteMEM;
	reg MemtoRegMEM;
	reg RegWriteMEM;
	


	// WB Stage
  	reg [31:0] MemReadDataWB;
 	reg [31:0] ALU_resultWB;
	reg [4:0] RegWriteRegWB;
	reg [4:0] RegisterRtWB;
	reg [4:0] RegisterRdWB;
	reg [4:0] RegisterRsWB;
	reg MemtoRegWB;
	reg RegWriteWB;

	wire [1:0] ALU_in1_sel;
	wire [1:0] ALU_in2_sel;

	wire stall;
	wire flush;

	// assign ra = PC + 4;
	// assign JumpAddr = {ra[31:28], Instruction[25:0], 2'b00};

	 

	// IF Stage

	PC pc(
		.clk(clk),
		.stall(stall),
		.in(NextPCIF),
		.out(PCIF)
	);


	instruction Instruction(
	 	.addr(PC_Add4IF),
		.instruction(InstructionIF)
	);

	assign PC_Add4IF = PC_Add4IF + 4;
	 
	assign RegWriteRegID = (RegDstID == 0) ? InstructionID[20:16] : InstructionID[15:11];
	assign RegWriteDataID = (MemtoRegID == 0) ? ALUoutEX : MemReadDataID;

	// IF/ID 

	initial begin
        	PC_Add4ID = 32'b0;
        	InstructionID = 32'b0;
    	end

    	always @ (posedge clk) begin
        	if (flush == 1) begin
            		PC_Add4ID <= 32'b0;
            		InstructionID <= 32'b0;
        	end 
		else if (stall == 0) begin
        		PC_Add4ID <= PC_Add4IF;
            		InstructionID <= InstructionIF;
        	end
    	end	

	// ID Stage

	Looking_forward_detection forward (
		.MEM_WB_RegWrite (RegWriteWB),
		.EX_MEM_RegWrite (RegWriteMEM),

		.EX_MEM_RegisterRd (RegisterRdMEM),
		.MEM_WB_RegisterRd (RegisterRdWB),

		.ID_EX_RegisterRt (RegisterRtEX),
		.ID_EX_RegisterRs (RegisterRsEX),

		.IF_ID_RegisterRt (RegisterRtID),
		.IF_ID_RegisterRs (RegisterRsID),

		.ALU_in1_sel (ALU_in1_sel),
		.ALU_in2_sel (ALU_in2_sel),

		.branch_eq_in1_sel (branch_eq_in1_sel),
		.branch_eq_in2_sel (branch_eq_in2_sel)
	);

	assign branch_eq_in1 = (branch_eq_in1_sel == 1'b0) ? RegReadData1ID : MemReadDataMEM;
	assign branch_eq_in2 = (branch_eq_in2_sel == 1'b0) ? RegReadData2ID : MemReadDataMEM;


	// branch_eq Branch_Eq (
	// 	.in1 (branch_eq_in1),
	// 	.in2 (branch_eq_in2),
	// 	.is_eq (ZEROID)
	// );

	assign ZEROID = (branch_eq_in1 == branch_eq_in2) ? 1'b1 : 1'b0;

	Hazard_detection_unit Hazard (
		.ID_EX_MemRead (MemReadEX),
		.ID_EX_regWrite (RegWriteRegEX),
		.EX_MEM_MemRead (MemReadMEM),

		.ins_op (instruction [31:26]),

		.IF_ID_RegisterRs (RegisterRsID),
		.IF_ID_RegisterRt (RegisterRtID),

		.ID_EX_RegisterRt (RegisterRtEX),
		.ID_EX_RegisterRd (RegisterRd_final_EX),

		.EX_MEM_RegisterRd (RegisterRdMEM),

		.stall (stall),
		.flush (flush)
	);

	control Control(
		.opcode(InstructionID[31:26]),
		.RegDst(RegDstID),
		.Jump(JumpID),
		.Branch(BranchID),
		.Bne(BneID),
		.MemRead(MemReadID),
		.MemtoReg(MemtoRegID),
		.ALUOp(ALUOpID),
		.MemWrite(MemWriteID),
		.ALUSrc(ALUSrcID),
		.RegWrite(RegWriteID)
	);

	register Registers(
	 	.clock(clk),
		.Readreg1(InstructionID[25:21]),
		.Readreg2(InstructionID[20:16]),
		.Writereg(RegWriteRegWB),
		.Writedata(RegWriteDataWB),
		.RegWrite(RegWriteWB),
		.Readdata1(RegReadData1ID),
		.Readdata2(RegReadData2ID)
	);
	
	signextent Signextent(
		.instruction(InstructionID[15:0]),
		.data(SignextentID)
	);


	branch_pc Branch_pc(
		.ra(ra),
		.branch_shamt(imd_addID),
		.jump_address(JumpAddrID),
		.Jump(JumpID),
		.Beq(BranchID),
		.Bne(BneID),
		.PC_write(PCID),
		.Zero(ZEROID)
	);

	ALU_branch alu_branch(
		.ra(raID),
		.imd_add(SignextentID),
		.out(imd_addID)
	);

	// ID/EX 

	assign RegisterRsID = instruction[25:21];
	assign RegisterRtID = instruction[20:16];
	assign RegisterRdID = instruction[15:11];
	 
	always @ (posedge clk) begin
		if (flush == 1) begin
			ALUOpEX <= 2'b0;
			RegDstEX <= 0;
			MemReadEX <= 0;
			MemtoRegEX <= 0;
			MemWriteEX <= 0;
			ALUSrcEX <= 0;
			RegWriteEX <= 0;
		end
		else begin
			RegReadData1EX <= RegReadData1ID;
			RegReadData2EX <= RegReadData2ID;
			SignextentEX <= SignExtentID;
			RegisterRsEX <= RegisterRsID;
			RegisterRtEX <= RegisterRtID;
			RegisterRdEX <= RegisterRdID;
			ALUOpEX <= ALUOpID;
			RegDstEX <= RegDstID;
			MemReadEX <= MemReadID;
			MemtoRegEX <= MemtoRegID;
			MemWriteEX <= MemWriteID;
			ALUSrcEX <= ALUSrcID;
			RegWriteRegEX <= RegWriteRegID; 
		end
	end

	// EX Stage

	ALU_control ALUctr(
		.ALU_op(ALUOpEX),
		.funct(InstructionEX[5:0]),
		.control_out(ALUoutEX)
	);
		
	assign ALUin1EX = (ALU_in1_sel == 2'b00)  ?  RegReadData1EX : (  (ALU_in1_sel == 2'b01)  ? RegWriteDataWB : ALU_resultMEM ) ;
	assign ALUin2EX_front = (ALU_in2_sel == 2'b00)  ?  RegReadData2EX : (  (ALU_in2_sel == 2'b01)  ? RegWriteDataWB : ALU_resultMEM ) ;
	assign ALUin2EX = (ALUSrcEX != 1'b0) ? ALUin2EX_front :  SignextentEX;
	 
	ALU aLU(
		.ALU_in1(ALUin1EX),
		.ALU_in2(ALUin2EX),
		.ALU_control(ALUctrEX),
		.Zero(ZEROEX),
		.result(ALUoutEX)
	);

	assign RegisterRd_final_EX = ( RegDstEX ) ? RegisterRdEX : RegisterRtEX;  


	always @ (posedge clk) 
	begin
		ALU_resultMEM <= ALUoutEX;
		RegisterRdMEM <= RegisterRd_final_EX;
		MemWriteDataMEM <= ALUin2EX_front;
		BranchMEM <= BranchEX;
		MemReadMEM <= MemReadEX;
		MemWriteMEM <= MemWriteEX;
		MemtoRegMEM <= MemtoRegEX;
		RegWriteMEM <= RegWriteEX;
	end
	 
	// Mem Stage
	 	
	 
	Data_mem Data_Mem(
		.Address(ALU_outMEM),
		.Write_data(RegReadData2MEM),
		.Read_data(MemReadDataMEM),
		.MemRead(MemReadMEM),
		.MemWrite(MemWriteMEM),
		.clk(clk)
	);

	// MEM/WB

	always @ (posedge clk)
	begin
		MemReadDataWB <= MemReadDataMEM;
		ALU_resultWB <= ALU_resultMEM;
		RegWriteRegWB <= RegisterRdMEM;
		MemtoRegWB <= MemtoRegMEM;
		RegWriteWB <= RegWriteMEM;

	end

	assign RegWriteDataWB = (MemtoReg == 1'b0) ? ALU_resultWB : MemReadDataWB;


	 


	 

     
endmodule
`endif
