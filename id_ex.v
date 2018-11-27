`ifndef MODULE_ID_EX
`define MODULE_ID_EX
`timescale 1ns / 1ps

module ID_EX (
    input               clk,
                        ID_EX_flush,

    input       [31:0]  ID_register_read_data1,
                        ID_register_read_data2,
                        ID_sign_extend,
    input       [4:0]   ID_registers_Rs,
                        ID_registers_Rt,
                        ID_registers_Rd,
    input       [1:0]   ID_ALU_op,
    input               ID_RegDst,
                        ID_MemRead,
                        ID_MemtoReg,
                        ID_MemWrite,
                        ID_ALUSrc,
                        ID_RegWrite,

    output reg  [31:0]  EX_register_read_data1,
                        EX_register_read_data2,
                        EX_sign_extend,
    output reg  [4:0]   EX_register_Rs,
                        EX_register_Rt,
                        EX_register_Rd,
    output reg  [1:0]   EX_ALU_op,
    output reg          EX_RegDst,
                        EX_MemRead,
                        EX_MemtoReg,
                        EX_MemWrite,
                        EX_ALUSrc,
                        EX_RegWrite
);

    initial begin
        EX_register_read_data1  = 32'b0;
        EX_register_read_data2  = 32'b0;
        EX_sign_extend    = 32'b0;
        EX_register_Rs    = 5'b0;
        EX_register_Rt    = 5'b0;
        EX_register_Rd    = 5'b0;
        EX_ALU_op         = 2'b0;
        EX_RegDst        = 1'b0;
        EX_MemRead       = 1'b0;
        EX_MemtoReg      = 1'b0;
        EX_MemWrite      = 1'b0;
        EX_ALUSrc        = 1'b0;
        EX_RegWrite      = 1'b0;
    end

    always @ (posedge clk) begin
        if (ID_EX_flush) begin
            EX_ALU_op         <= 2'b0;
            EX_RegDst        <= 1'b0;
            EX_MemRead       <= 1'b0;
            EX_MemtoReg      <= 1'b0;
            EX_MemWrite      <= 1'b0;
            EX_ALUSrc        <= 1'b0;
            EX_RegWrite      <= 1'b0;
        end else begin
            EX_register_read_data1  <= ID_register_read_data1;
            EX_register_read_data2  <= ID_register_read_data2;
            EX_sign_extend    <= ID_sign_extend;
            EX_register_Rs    <= ID_registers_Rs;
            EX_register_Rt    <= ID_registers_Rt;
            EX_register_Rd    <= ID_registers_Rd;
            EX_ALU_op         <= ID_ALU_op;
            EX_RegDst        <= ID_RegDst;
            EX_MemRead       <= ID_MemRead;
            EX_MemtoReg      <= ID_MemtoReg;
            EX_MemWrite      <= ID_MemWrite;
            EX_ALUSrc        <= ID_ALUSrc;
            EX_RegWrite      <= ID_RegWrite;
        end
    end

endmodule // ID_EX

`endif // MODULE_ID_EX
