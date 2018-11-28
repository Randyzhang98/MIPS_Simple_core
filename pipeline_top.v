`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/11/22 11:08:50
// Design Name: 
// Module Name: pipeline_top
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


module pipeline_top( clk, system_clk, AN, swpc, sw4, sw3, sw2, sw1, sw0, SSD_out);
    
     input clk;
       input system_clk;
       
       output reg [3:0] AN;
       input swpc, sw4, sw3, sw2,sw1, sw0;
      
       output reg [6:0] SSD_out;
     wire [31:0] pcOut;
     wire [4:0] regIn;
     wire [31:0] regOut;
     wire [31:0] In;
      reg [3:0] Num;
      
      wire out_clk;
     
     assign regIn = {sw4,sw3, sw2, sw1, sw0};
     
     initial 
     begin
     AN = 4'b0111;
     end
     
    
     
     pipeline_zsj pipeline (
        .clk(clk),
        .regIn(regIn),
        .pcOut(pcOut),
        .regOut(regOut)
     );
     
     assign In = (swpc == 1'b1) ? pcOut : regOut;
     
     clock_divider clk_d (
        .inputclock(system_clk),
        .outputclock (out_clk)
     );
     
//     clock_divider #(100000000)  clk_aaba (
//        .inputclock (system_clk),
//        .outputclock(clk)
     
//     );
     
     always @ (posedge out_clk)
         begin
            if (AN == 4'b0111) begin AN <= 4'b1011;  Num = In[11:8]; end
            else if (AN == 4'b1011) begin AN <= 4'b1101; Num = In[7:4]; end
            else if (AN == 4'b1101) begin AN <= 4'b1110; Num = In[3:0] ;end
            else if (AN == 4'b1110) begin AN <= 4'b0111; Num = In[15:12] ; end
            else begin AN <=4'b0111;  Num = In[15:12]; end
         end    

     always @(Num[0] or Num[1] or Num[2] or Num[3])
     case(Num)
        4'b0000: SSD_out=7'b0000001;
        4'b0001: SSD_out=7'b1001111;
        4'b0010: SSD_out=7'b0010010;
        4'b0011: SSD_out=7'b0000110;
        4'b0100: SSD_out=7'b1001100;
        4'b0101: SSD_out=7'b0100100;
        4'b0110: SSD_out=7'b0100000;
        4'b0111: SSD_out=7'b0001111;
        4'b1000: SSD_out=7'b0000000;
        4'b1001: SSD_out=7'b0000100;
        4'b1010: SSD_out=7'b0001000;
        4'b1011: SSD_out=7'b1100000;
        4'b1100: SSD_out=7'b0110001;
        4'b1101: SSD_out=7'b1000010;
        4'b1110: SSD_out=7'b0110000;
        4'b1111: SSD_out=7'b0111000;
        endcase
     
     
endmodule
