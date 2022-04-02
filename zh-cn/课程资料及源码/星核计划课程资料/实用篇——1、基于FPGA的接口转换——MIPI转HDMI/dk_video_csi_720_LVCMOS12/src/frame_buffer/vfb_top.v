// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
// =					 All rights reserved.
// ====================================================================================
// 
//  __	    __	    __
//  \ \	   /  \	   / /   [File name   ] vfb_top.v
//   \ \  / /\ \  / /	 [Description ] video frame buffer
//	  \ \/ /  \ \/ /	 [Timestamp   ] Friday May 26 14:00:30 2019
//	   \  /	   \  /	     [version	  ] 1.0.0
//	    \/	    \/
//
// ==============0ooo===================================================0ooo===========
// Code Revision History :
// ----------------------------------------------------------------------------------
// Ver:	|  Author	| Mod. Date	| Changes Made:
// ----------------------------------------------------------------------------------
// V1.0	| Caojie	 | 05/26/19	 | Initial version 
// ----------------------------------------------------------------------------------
// ==============0ooo===================================================0ooo===========

`timescale 1ns / 1ps

`include "vfb_defines.v"
	
module vfb_top #
(   
	parameter IMAGE_SIZE		  = 32'h0080_0000   ,//--8MB,byte address  //frame base address
	parameter BURST_WRITE_LENGTH  = 1024            ,  //bytes
	parameter BURST_READ_LENGTH   = 1024            ,  //bytes		
	parameter ADDR_WIDTH		  = 26              ,
	parameter DATA_WIDTH		  = 128             ,
	parameter DQ_WIDTH            = 16              ,
	parameter VIDEO_WIDTH		  = 16              
)
( 
	input                     I_rst_n       ,
	input                     I_dma_clk     ,
	input  [0:0]              I_wr_halt     , //1:halt,  0:no halt
	input  [0:0]              I_rd_halt     , //1:halt,  0:no halt
	// video data input                        
	input                     I_vin0_clk    ,
	input                     I_vin0_vs_n   ,
	input                     I_vin0_de     ,
	input  [VIDEO_WIDTH-1:0]  I_vin0_data   ,                                
	// video data output                    
	input                     I_vout0_clk   ,
	input                     I_vout0_vs_n  ,
	input                     I_vout0_de    ,
	output                    O_vout0_den   ,
	output [VIDEO_WIDTH-1:0]  O_vout0_data  ,
	output                    O_vout0fifo_empty,
	// ddr write request
    input                     cmd_ready          ,
	output [2:0]              cmd                ,//0:write;  1:read
	output                    cmd_en             ,
	output [5:0]              app_burst_number   ,
	output [ADDR_WIDTH-1:0]   addr               ,//[ADDR_WIDTH-1:0]
	input                     wr_data_rdy        ,
	output                    wr_data_en         ,//
	output                    wr_data_end        ,//
	output [DATA_WIDTH-1:0]   wr_data            ,//[DATA_WIDTH-1:0]
	output [DATA_WIDTH/8-1:0] wr_data_mask       ,
	input                     rd_data_valid      ,
	input                     rd_data_end        ,//unused 
	input  [DATA_WIDTH-1:0]   rd_data            ,//[DATA_WIDTH-1:0]
	input                     init_calib_complete  
);
  

vfb_wrapper #
(
	.IMAGE_SIZE        (IMAGE_SIZE        ),     
	.BURST_WRITE_LENGTH(BURST_WRITE_LENGTH),
	.BURST_READ_LENGTH (BURST_READ_LENGTH ),
	.ADDR_WIDTH        (ADDR_WIDTH        ),
	.DATA_WIDTH        (DATA_WIDTH        ),
	.DQ_WIDTH          (DQ_WIDTH          ),
	.VIDEO_WIDTH       (VIDEO_WIDTH       )
)
vfb_wrapper_inst
( 
	.I_rst_n		    (I_rst_n          ),
	.I_dma_clk		    (I_dma_clk        ),
	.I_wr_halt		    (I_wr_halt        ), //1:halt,  0:no halt
	.I_rd_halt		    (I_rd_halt        ), //1:halt,  0:no halt
	// video data input           
	.I_vin0_clk		    (I_vin0_clk       ),
	.I_vin0_vs_n	    (I_vin0_vs_n      ),
	.I_vin0_de		    (I_vin0_de        ),
	.I_vin0_data	    (I_vin0_data      ),
	// video data output          
	.I_vout0_clk	    (I_vout0_clk	  ),
	.I_vout0_vs_n	    (I_vout0_vs_n	  ),
	.I_vout0_de		    (I_vout0_de		  ),
	.O_vout0_den	    (O_vout0_den	  ),
	.O_vout0_data	    (O_vout0_data	  ),
	.O_vout0fifo_empty  (O_vout0fifo_empty),
	// ddr write request
	.cmd_ready          (cmd_ready          ),
	.cmd                (cmd                ),//0:write;  1:read
	.cmd_en             (cmd_en             ),
	.app_burst_number   (app_burst_number   ),
	.addr               (addr               ),//[ADDR_WIDTH-1:0]
	.wr_data_rdy        (wr_data_rdy        ),
	.wr_data_en         (wr_data_en         ),//
	.wr_data_end        (wr_data_end        ),//
	.wr_data            (wr_data            ),//[DATA_WIDTH-1:0]
	.wr_data_mask       (wr_data_mask       ),
	.rd_data_valid      (rd_data_valid      ),
	.rd_data_end        (rd_data_end        ),//unused 
	.rd_data            (rd_data            ),//[DATA_WIDTH-1:0]
	.init_calib_complete(init_calib_complete)
);  

endmodule   
  