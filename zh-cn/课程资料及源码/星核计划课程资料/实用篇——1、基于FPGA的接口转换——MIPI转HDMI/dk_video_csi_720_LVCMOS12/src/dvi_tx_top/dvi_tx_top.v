// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2020 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// ====================================================================================
// 
//  __      __      __
//  \ \    /  \    / /   [File name   ] DVI_TX_Top.v
//   \ \  / /\ \  / /    [Description ] DVI TX
//    \ \/ /  \ \/ /     [Timestamp   ] Friday April 3 14:00:30 2020
//     \  /    \  /      [version     ] 1.0
//      \/      \/
//
// ==============0ooo===================================================0ooo===========
// Code Revision History :
// ----------------------------------------------------------------------------------
// Ver:    |  Author    | Mod. Date    | Changes Made:
// ----------------------------------------------------------------------------------
// V1.0.0  | Caojie     | 04/03/20     | Initial version 
// ----------------------------------------------------------------------------------
// ==============0ooo===================================================0ooo===========

`include "dvi_tx_defines.v"

module DVI_TX_Top
(
	input  		  I_rst_n       ,  //asynchronous reset, low active
`ifdef USE_EXTERNAL_CLK
	input         I_serial_clk  ,
`endif
	input  		  I_rgb_clk     ,  //pixel clock
	input         I_rgb_vs      , 
	input         I_rgb_hs      ,    
	input         I_rgb_de      , 
	input  [7:0]  I_rgb_r       ,  
	input  [7:0]  I_rgb_g       ,
	input  [7:0]  I_rgb_b       ,
	output		  O_tmds_clk_p  ,
	// output		  O_tmds_clk_n  ,
	output [2:0]  O_tmds_data_p //{r,g,b}
	// output [2:0]  O_tmds_data_n
);

rgb2dvi rgb2dvi_inst
(
	.I_rst_n       (I_rst_n       ),   //asynchronous reset, low active
`ifdef USE_EXTERNAL_CLK
	.I_serial_clk  (I_serial_clk  ),
`endif
	.I_rgb_clk     (I_rgb_clk     ),   //pixel clock
	.I_rgb_vs      (I_rgb_vs      ), 
	.I_rgb_hs      (I_rgb_hs      ),    
	.I_rgb_de      (I_rgb_de      ), 
	.I_rgb_r       (I_rgb_r       ),  
	.I_rgb_g       (I_rgb_g       ),  
	.I_rgb_b       (I_rgb_b       ),  
	.O_tmds_clk_p  (O_tmds_clk_p  ),
	// .O_tmds_clk_n  (O_tmds_clk_n  ),
	.O_tmds_data_p (O_tmds_data_p )  //{r,g,b}
	// .O_tmds_data_n (O_tmds_data_n )
);

endmodule