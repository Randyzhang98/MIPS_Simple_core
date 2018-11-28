`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 00:45:51
// Design Name: 
// Module Name: pipeline_zsj
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


module pipeline_zsj(
	input               clk,
    input       [4:0]   regIn,
    output      [31:0]  pcOut,
                        regOut
);	 
     wire               IF_ID_flush,
                        ID_EX_flush,
                        stall;

    // IF stage
    wire        [31:0]  IF_pc_in,
                        IF_pc_out,
                        IF_ra,
                        IF_ins,
                        IF_branch_out;

    // ID stage
    wire        [31:0]  ID_ra,
                        ID_brancn_shamt,
                        ID_ins,
                        ID_register_read_data1,
                        ID_register_read_data2,
                        ID_branch_eq_forward1,
                        ID_branch_eq_forward2,
                        ID_sign_extend,
                        ID_jaddr;
    wire        [4:0]   ID_registers_Rs,
                        ID_registers_Rt,
                        ID_registers_Rd;
    wire        [1:0]   ID_ALU_op;
    wire                ID_RegDst,
                        ID_jump,
                        ID_beq,
                        ID_bne,
                        ID_MemRead,
                        ID_MemtoReg,
                        ID_MemWrite,
                        ID_ALUSrc,
                        ID_RegWrite,
                        ID_branch_comp_re,
                        ID_branch_eq;

    // EX stage
    wire        [31:0]  EX_register_read_data1,
                        EX_register_read_data2,
                        EX_sign_extend,
                        EX_ALU_in1,
                        EX_ALU_in2_front,
                        EX_ALU_in2,
                        EX_ALU_out;
    wire        [4:0]   EX_register_Rs,
                        EX_register_Rt,
                        EX_register_Rd,
                        EX_register_addr;
    wire        [3:0]   EX_ALU_control;
    wire        [1:0]   EX_ALU_op;
    wire                EX_RegDst,
                        EX_MemRead,
                        EX_MemtoReg,
                        EX_MemWrite,
                        EX_ALUSrc,
                        EX_RegWrite,
                        EX_ALU_Zero;

    // MEM stage
    wire        [31:0]  MEM_ALU_out,
                        MEM_register_read_data2,
                        MEM_Data_mem_out;
    wire        [4:0]   MEM_register_addr;
    wire                MEM_MemRead,
                        MEM_MemtoReg,
                        MEM_MemWrite,
                        MEM_RegWrite;
    // WB stage
    wire        [31:0]  WB_ALU_out,
                        WB_Data_mem_out,
                        WB_register_write;
    wire        [4:0]   WB_register_addr;
    wire                WB_MemtoReg,
                        WB_RegWrite;

    // Data Hazard
    wire        [1:0]   ALU_in1_sel,
                        ALU_in2_sel;
    wire                branch_eq_in1_sel,
                        branch_eq_in2_sel;
    //IF
    PC pc (
        .clk(clk),
        .stall (stall),
        .in(IF_pc_in),
        .out(IF_pc_out)
    );

    instruction Instruction (
        .addr(IF_pc_out),
        .instruction(IF_ins)
    );

    assign IF_ra = IF_pc_out + 4;
    //IF/ID
    IF_ID ifid (
        .clk(clk), .stall(stall), .IF_ID_flush(IF_ID_flush),
        .IF_ra(IF_ra), .ID_ra(ID_ra),
        .IF_ins(IF_ins), .ID_ins(ID_ins)
    );
    //ID stage
    assign ID_registers_Rs = ID_ins[25:21];
    assign ID_registers_Rt = ID_ins[20:16];
    assign ID_registers_Rd = ID_ins[15:11];

    control Control(
		.opcode(ID_ins[31:26]),
		.RegDst(ID_RegDst),
		.Jump(ID_jump),
		.Branch(ID_beq),
		.Bne(ID_bne),
		.MemRead(ID_MemRead),
		.MemtoReg(ID_MemtoReg),
		.ALUOp(ID_ALU_op),
		.MemWrite(ID_MemWrite),
		.ALUSrc(ID_ALUSrc),
		.RegWrite(ID_RegWrite)
	);

    // Control control (
    //     .opCode(ID_ins[31:26]),
    //     .regDst(ID_RegDst),
    //     .jump(ID_jump),
    //     .branchEq(ID_beq),
    //     .branchNe(ID_bne),
    //     .memRead(ID_MemRead),
    //     .memtoReg(ID_MemtoReg),
    //     .memWrite(ID_MemWrite),
    //     .aluSrc(ID_ALUSrc),
    //     .regWrite(ID_RegWrite),
    //     .aluOp(ID_ALU_op)
    // );

    register_pipeline Registers(
	 	.clock(clk),
		.Readreg1(ID_registers_Rs),
		.Readreg2(ID_registers_Rt),
        .ReadregExtra(regIn),
		.Writereg(WB_register_addr),
		.Writedata(WB_register_write),
		.RegWrite(WB_RegWrite),
		.Readdata1(ID_register_read_data1),
		.Readdata2(ID_register_read_data2),
        .ReaddataExtra(regOut)
	);

    signextent Signextent(
		.instruction(ID_ins[15:0]),
		.data(ID_sign_extend)
	);

    Looking_forward_detection forward (
		.MEM_WB_RegWrite (WB_RegWrite),
		.EX_MEM_RegWrite (MEM_RegWrite),

		.EX_MEM_RegisterRd (MEM_register_addr),
		.MEM_WB_RegisterRd (WB_register_addr),

		.ID_EX_RegisterRt (EX_register_Rt),
		.ID_EX_RegisterRs (EX_register_Rs),

		.IF_ID_RegisterRt (ID_registers_Rt),
		.IF_ID_RegisterRs (ID_registers_Rs),

		.ALU_in1_sel (ALU_in1_sel),
		.ALU_in2_sel (ALU_in2_sel),

		.branch_eq_in1_sel (branch_eq_in1_sel),
		.branch_eq_in2_sel (branch_eq_in2_sel)
	);

    assign ID_brancn_shamt = ID_ra + (ID_sign_extend << 2);
    assign ID_branch_eq_forward1 = (branch_eq_in1_sel == 1'b1) ? MEM_ALU_out : ID_register_read_data1;
    assign ID_branch_eq_forward2 = (branch_eq_in2_sel == 1'b1) ? MEM_ALU_out : ID_register_read_data2;
    assign ID_branch_eq = (ID_branch_eq_forward1 == ID_branch_eq_forward2);
    assign ID_branch_comp_re = (ID_beq && ID_branch_eq) || (ID_bne && !ID_branch_eq);
    assign IF_branch_out = (!ID_branch_comp_re) ? IF_ra : ID_brancn_shamt;
    assign ID_jaddr = {ID_ra[31:28], ID_ins[25:0], 2'b0};
    assign IF_pc_in = (!ID_jump) ? IF_branch_out : ID_jaddr;
    //assign IF_ID_flush = ID_branch_comp_re;

    Hazard_detection_unit Hazard (
		.ID_EX_MemRead (EX_MemRead),
		.ID_EX_regWrite (EX_RegWrite),
		.EX_MEM_MemRead (MEM_MemRead),
        .ID_branch_comp_re (ID_branch_comp_re),
		.ins_op (ID_ins [31:26]),

		.IF_ID_RegisterRs (ID_registers_Rs),
		.IF_ID_RegisterRt (ID_registers_Rt),

		.ID_EX_RegisterRt (EX_register_Rt),
		.ID_EX_RegisterRd (EX_register_addr),

		.EX_MEM_RegisterRd (MEM_register_addr),

		.stall (stall),
        // .flush (ID_EX_flush)
		.flushIDEX (ID_EX_flush),
        .flushIFID (IF_ID_flush)
	);

    // ID/EX
      ID_EX idex (
        .clk(clk), .ID_EX_flush(ID_EX_flush),
        .ID_register_read_data1(ID_register_read_data1), .EX_register_read_data1(EX_register_read_data1),
        .ID_register_read_data2(ID_register_read_data2), .EX_register_read_data2(EX_register_read_data2),
        .ID_sign_extend(ID_sign_extend), .EX_sign_extend(EX_sign_extend),
        .ID_registers_Rs(ID_registers_Rs), .EX_register_Rs(EX_register_Rs),
        .ID_registers_Rt(ID_registers_Rt), .EX_register_Rt(EX_register_Rt),
        .ID_registers_Rd(ID_registers_Rd), .EX_register_Rd(EX_register_Rd),
        .ID_ALU_op(ID_ALU_op), .EX_ALU_op(EX_ALU_op),
        .ID_RegDst(ID_RegDst), .EX_RegDst(EX_RegDst),
        .ID_MemRead(ID_MemRead), .EX_MemRead(EX_MemRead),
        .ID_MemtoReg(ID_MemtoReg), .EX_MemtoReg(EX_MemtoReg),
        .ID_MemWrite(ID_MemWrite), .EX_MemWrite(EX_MemWrite),
        .ID_ALUSrc(ID_ALUSrc), .EX_ALUSrc(EX_ALUSrc),
        .ID_RegWrite(ID_RegWrite), .EX_RegWrite(EX_RegWrite)
    );

    // EX stage
	ALU_control ALUctr(
		.ALU_op(EX_ALU_op),
		.funct(EX_sign_extend[5:0]),
		.control_out(EX_ALU_control)
	);

    assign EX_ALU_in1 = (ALU_in1_sel == 2'b00) ? EX_register_read_data1 :
        ((ALU_in1_sel == 2'b01) ? WB_register_write : MEM_ALU_out);
    assign EX_ALU_in2_front = (ALU_in2_sel == 2'b00) ? EX_register_read_data2 :
        ((ALU_in2_sel == 2'b01) ? WB_register_write : MEM_ALU_out);
    assign EX_ALU_in2 = (!EX_ALUSrc) ? EX_ALU_in2_front : EX_sign_extend;

    ALU alu (
        .ALU_in1(EX_ALU_in1),
        .ALU_in2(EX_ALU_in2),
        .ALU_control(EX_ALU_control),
        .Zero(EX_ALU_Zero),
        .result(EX_ALU_out)
    );

    assign EX_register_addr = (!EX_RegDst) ? EX_register_Rt : EX_register_Rd;

    //EX/MEM

    EX_MEM exmem (
        .clk(clk),
        .EX_ALU_out(EX_ALU_out), .MEM_ALU_out(MEM_ALU_out),
        .EX_register_read_data2(EX_ALU_in2_front), .MEM_register_read_data2(MEM_register_read_data2),
        .EX_register_addr(EX_register_addr), .MEM_register_addr(MEM_register_addr),
        .EX_MemRead(EX_MemRead), .MEM_MemRead(MEM_MemRead),
        .EX_MemtoReg(EX_MemtoReg), .MEM_MemtoReg(MEM_MemtoReg),
        .EX_MemWrite(EX_MemWrite), .MEM_MemWrite(MEM_MemWrite),
        .EX_RegWrite(EX_RegWrite), .MEM_RegWrite(MEM_RegWrite)
    );

    // MEM stage
    Data_mem dm (
        .clk(clk),
        .address(MEM_ALU_out),
        .Write_data(MEM_register_read_data2),
        .Read_data (MEM_Data_mem_out),
        .MemWrite (MEM_MemWrite),
        .MemRead (MEM_MemRead)
    );

    // MEM/WB

	   // MEM/WB
    MEM_WB memwb (
        .clk(clk),
        .MEM_Data_mem_out(MEM_Data_mem_out), .WB_Data_mem_out(WB_Data_mem_out),
        .MEM_ALU_out(MEM_ALU_out), .WB_ALU_out(WB_ALU_out),
        .MEM_register_addr(MEM_register_addr), .WB_register_addr(WB_register_addr),
        .MEM_MemtoReg(MEM_MemtoReg), .WB_MemtoReg(WB_MemtoReg),
        .MEM_RegWrite(MEM_RegWrite), .WB_RegWrite(WB_RegWrite)
    );

     // WB stage
    assign WB_register_write = (!WB_MemtoReg) ? WB_ALU_out : WB_Data_mem_out;
    //assign WB_register_write = WB_ALU_out;







    assign pcOut = IF_pc_out;

endmodule