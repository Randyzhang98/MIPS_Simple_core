`ifndef MODULE_LOOKINGFORWARD
`define MODULE_LOOKINGFORWARD

    
`timescale 1ns / 1ps

module Looking_forward_detection (
    input       MEM_WB_RegWrite, 
                EX_MEM_RegWrite,


    input [4:0] EX_MEM_RegisterRd,

                MEM_WB_RegisterRd,

                ID_EX_RegisterRt,
                ID_EX_RegisterRs,

                IF_ID_RegisterRt,
                IF_ID_RegisterRs,

    output reg [1:0]   ALU_in1_sel,
                    ALU_in2_sel,

    output reg      branch_eq_in1_sel,
                    branch_eq_in2_sel
);

initial 
begin
    ALU_in1_sel = 2'b00;
    ALU_in2_sel = 2'b00;
    end

always @ ( * ) begin

    if ( (EX_MEM_RegWrite != 1'b0) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRs) )
    begin
        ALU_in1_sel = 2'b10;
    end
    // && !( (EX_MEM_RegWrite != 1'b0) && (EX_MEM_RegisterRd != 0 ) && (EX_MEM_RegisterRd = ID_EX_RegisterRs)
    else if ( (MEM_WB_RegWrite != 1'b0) && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRs)   ) 
    begin 
        ALU_in1_sel = 2'b01;
    end
    else 
    begin
        ALU_in1_sel = 2'b00;
    end

    
    if ( (EX_MEM_RegWrite != 1'b0) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == ID_EX_RegisterRt) )
    begin 
        ALU_in2_sel = 2'b10;
    end
    // && !( (EX_MEM_RegWrite != 1'b0) && (EX_MEM_RegisterRd != 0 ) && (EX_MEM_RegisterRd = ID_EX_RegisterRt)
    else if ( (MEM_WB_RegWrite != 1'b0) && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegisterRd == ID_EX_RegisterRt)   ) 
    begin 
        ALU_in2_sel = 2'b01;
    end
    else 
    begin
        ALU_in2_sel = 2'b00;
    end

    if ( (EX_MEM_RegWrite != 1'b0) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == IF_ID_RegisterRs) )
    begin 
        branch_eq_in1_sel = 1'b1;
    end
    else 
    begin
        branch_eq_in1_sel = 1'b0;
    end

    if ( (EX_MEM_RegWrite != 1'b0) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegisterRd == IF_ID_RegisterRt) )
    begin 
        branch_eq_in2_sel = 1'b1;
    end
    else 
    begin
        branch_eq_in2_sel = 1'b0;
    end



    

end


endmodule
    
`endif