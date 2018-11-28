`ifndef MODULE_IF_ID
`define MODULE_IF_ID
`timescale 1ns / 1ps

module IF_ID (
    input               clk,
                        stall,
                        IF_ID_flush,
    input       [31:0]  IF_ra,
                        IF_ins,
    output reg  [31:0]  ID_ra,
                        ID_ins
);

    initial begin
        ID_ra = 32'b0;
        ID_ins = 32'b0;
    end

    always @ (posedge clk) begin
        if (IF_ID_flush) begin
            ID_ra <= 32'b0;
            ID_ins <= 32'b0;
        end else if (!stall) begin
            ID_ra <= IF_ra;
            ID_ins <= IF_ins;
        end
    end

endmodule // IF_ID


`endif // MODULE_IF_ID
