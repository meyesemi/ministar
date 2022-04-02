`timescale 1ns/1ps
module raw8_lane2 #
(
 parameter bus_width = 8
,parameter lane_width = 2
)
(
 input rstn
,input clk
,input [15:0] din
,input fv_sclk    //vs
,input lv_sclk    //de
,input        pixclk
,output [8:0] pixdata
,output       fv_pclk //vs
,output reg   lv_pclk //de
);

wire w_lv_n;

fifo16b_8b 
u_fifo16b_8b
(
 .Reset(~rstn  )
,.WrClk(clk    )
,.WrEn (lv_sclk)
,.Data (din    )
,.RdClk(pixclk )
,.RdEn (~w_lv_n)
,.Q    (pixdata)
,.Empty(w_lv_n )
,.Full (       )
);

assign fv_pclk = fv_sclk;

always @(posedge pixclk or negedge rstn) begin  
     if(~rstn)
         lv_pclk <= 0;
     else
         lv_pclk <= ~w_lv_n;
end


endmodule