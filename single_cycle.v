`ifndef MODULE_SINGLE_CYCLE
`define MODULE_SINGLE_CYCLE
`timescale 1ns / 1ps

`include "ALU_branch.v"
`include "ALU_control.v"
//`include "aluTC.v"
`include "ALU.v"
`include "control.v"
`include "instruction.v"
`include "mux.v"
`include "register.v"
`include "Data_mem.v"
`include "signextent.v"
`include "branch_pc.v"
`include "pc.v"

module single_cycle (input clk);
    wire    [31:0]  pc_in,
                    pc_out,
                    ra,
                    instruction_out,
                    jump_address,
                    ALU_branch_out,
                    ALU_out,

                    regWriteData,
                    regReadData1,
                    regReadData2,

                    signextent_out,
                    ALU_in1,
                    ALU_in2,

                    Data_mem_out,

                    imd_add;

    wire            regDst,
                    jump,
                    beq,
                    bne,
                    memRead,
                    memtoReg,
                    memWrite,
                    aluSrc,
                    regWrite,

                    zero;

    wire    [1:0]   ALU_op;

    wire    [4:0]   regWrite_add;

    wire    [3:0]   ALU_control_out;


    assign ra = pc_out + 4;
    assign stall = 1'b0;
    assign jump_address = {ra[31:28],instruction_out[25:0], 2'b00};

    control Control(
        .opcode (instruction_out[31:26]),
        .RegDst (regDst),
        .Jump (jump),
        .Branch (beq),
        .Bne (bne),
        .MemRead (memRead),
        .MemtoReg (memtoReg),
        .ALUOp (ALU_op),
        .MemWrite (memWrite),
        .ALUSrc (aluSrc),
        .RegWrite (regWrite)
    );

    instruction Instruction(
        .addr (pc_out),
        .instruction (instruction_out)
    );
    wire [4:0] aa, bb;
    //no meaning part
    assign aa = instruction_out[25:21];
    assign bb = instruction_out[20:16];

    register registers (
        .clock (clk),
        .Readreg1 (instruction_out[25:21]),
        .Readreg2 (instruction_out[20:16]),
        .Writereg (regWrite_add),
        .Writedata (regWriteData),
        .RegWrite (regWrite),
        .Readdata1 (regReadData1),
        .Readdata2 (regReadData2)
    );

    assign regWrite_add = (regDst == 1'b0) ? instruction_out[20:16] : instruction_out[15:11];
    assign regWriteData = (memtoReg == 1'b0) ? ALU_out : Data_mem_out;
    assign ALU_in1 = regReadData1;

    signextent Signextent(
        .instruction (instruction_out[15:0]),
        .data (signextent_out)
    );

    assign ALU_in2 = (aluSrc == 1'b0) ? regReadData2 : signextent_out;

    ALU_control ALU_Control(
        .ALU_op (ALU_op),
        .funct (instruction_out[5:0]),
        .control_out (ALU_control_out)
    );

    ALU aLU (
        .ALU_in1 (ALU_in1),
        .ALU_in2 (ALU_in2),
        .ALU_control (ALU_control_out),
        .Zero (zero),
        .result (ALU_out)
    );

    //     ALU aluMain(
    //     .a(regReadData1),
    //     .b(ALU_in2),
    //     .control(ALU_control_out),
    //     .zero(zero),
    //     .result(ALU_out)
    // );

    PC pc(
        .clk(clk),
        .stall(stall),
        .in(pc_in),
        .out(pc_out)
    );

    branch_pc Branch_pc (
        .ra (ra),
        .branch_shamt (imd_add),
        .jump_address (jump_address),
        .Jump (jump),
        .Beq (beq),
        .Bne (bne),
        .PC_write (pc_in),
        .Zero (zero)
    );

    ALU_branch alu_branch (
        .ra (ra),
        .imd_add (signextent_out),
        .out (imd_add)
    );

    Data_mem Data_Mem (
        .Address (ALU_out),
        .Write_data (regReadData2),
        .Read_data (Data_mem_out),
        .MemRead (memRead),
        .MemWrite (memWrite),
        .clk (clk)
    );



endmodule // single_cycle

`endif // MODULE_SINGLE_CYCLE
