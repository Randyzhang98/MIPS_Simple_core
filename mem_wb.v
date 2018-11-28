`ifndef MODULE_MEM_WB
`define MODULE_MEM_WB
`timescale 1ns / 1ps

module MEM_WB (
    input               clk,

    input       [31:0]  MEM_Data_mem_out,
                        MEM_ALU_out,
    input       [4:0]   MEM_register_addr,
    input               MEM_MemtoReg,
                        MEM_RegWrite,

    output reg  [31:0]  WB_Data_mem_out,
                        WB_ALU_out,
    output reg  [4:0]   WB_register_addr,
    output reg          WB_MemtoReg,
                        WB_RegWrite
);

    initial begin
        WB_Data_mem_out    = 32'b0;
        WB_ALU_out     = 32'b0;
        WB_register_addr      = 5'b0;
        WB_MemtoReg      = 1'b0;
        WB_RegWrite      = 1'b0;
    end

    always @ (posedge clk) begin
        WB_Data_mem_out    <= MEM_Data_mem_out;
        WB_ALU_out     <= MEM_ALU_out;
        WB_register_addr      <= MEM_register_addr;
        WB_MemtoReg      <= MEM_MemtoReg;
        WB_RegWrite      <= MEM_RegWrite;
    end

endmodule // MEM_WB

`endif // MODULE_MEM_WB
