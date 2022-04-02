// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2019 Gowin Semiconductor Technology Co.,Ltd.
// =					 All rights reserved.
// ====================================================================================
// 
//  __	    __	    __
//  \ \	   /  \	   / /   [File name   ] video_top.v
//   \ \  / /\ \  / /	 [Description ] Video demo
//	  \ \/ /  \ \/ /	 [Timestamp   ] Friday May 26 14:00:30 2019
//	   \  /	   \  /	     [version	  ] 1.0.0
//	    \/	    \/
//
// ==============0ooo===================================================0ooo===========
// Code Revision History :
// ----------------------------------------------------------------------------------
// Ver:	|  Author	| Mod. Date	| Changes Made:
// ----------------------------------------------------------------------------------
// V1.0	| Caojie	 | 11/22/19	 | Initial version 
// ----------------------------------------------------------------------------------
// ==============0ooo===================================================0ooo===========

`include "vfb_defines.v"

module video_top
(
	input             I_clk           , //50Mhz
    input             I_clk_27m       ,
	input             I_rst_n         ,
	input             I_key1          ,
	input             I_sw1           ,
	output     [3:0]  O_led           ,
	input             I_CSI_CKP       , 
	input             I_CSI_CKN       ,                          
	input             I_CSI_D0P       , 
	input             I_CSI_D0N       ,
	input             I_CSI_D1P       , 
	input             I_CSI_D1N       ,
	inout [1:0]       I_CSI_LPCLK     ,
	inout [1:0]       I_CSI_LP0       ,
	inout [1:0]       I_CSI_LP1       ,
	output            O_csi_resetb    ,
	output            O_csi_pwdn      ,//O_csi_clk
	output            O_csi_scl       ,
	inout             IO_csi_sda      ,
    output  [1:0]     O_gpio          ,
	output	   		  O_tmds_clk_p      ,
	// output	   		  O_tmds_clk_n      ,
	output	   [2:0]  O_tmds_data_p     ,//{r,g,b}
	// output	   [2:0]  O_tmds_data_n     ,
	output	   [13:0] O_ddr_addr      ,
	output	   [2:0]  O_ddr_ba        ,
	output 	   	      O_ddr_cs_n      ,
	output 	   	      O_ddr_ras_n     ,
	output 	   	      O_ddr_cas_n     ,
	output 	   	      O_ddr_we_n      ,
	output 	   	      O_ddr_clk       ,
	output 	   	      O_ddr_clk_n     ,
	output 	   	      O_ddr_cke       ,
	output 	   	      O_ddr_odt       ,
	output 	   	      O_ddr_reset_n   ,
	output 	   [1:0]  O_ddr_dqm       ,
	inout  	   [15:0] IO_ddr_dq       ,
	inout  	   [1:0]  IO_ddr_dqs      ,
	inout  	   [1:0]  IO_ddr_dqs_n    
);

//=========================================================
//SRAM parameters
parameter IMAGE_SIZE          = 28'h080_0000;//--8MB,byte address  //frame base address
parameter BURST_WRITE_LENGTH  = 1024;  //bytes
parameter BURST_READ_LENGTH   = 1024;  //bytes
parameter ADDR_WIDTH          = 28;    //存储单元是byte，总容量=2^27*16bit = 2Gbit,增加1位rank地址，{rank[0],bank[2:0],row[13:0],cloumn[9:0]}
parameter DATA_WIDTH          = 128;   //与生成DDR3IP有关，此ddr3 2Gbit, x16， 时钟比例1:4 ，则固定128bit
parameter DQ_WIDTH            = 16;
parameter VIDEO_WIDTH	      = `DEF_VIDEO_WIDTH;  

//==================================================
wire        rst_n1;
wire        rst_n2;
wire        ddr_rstn;

//--------------------------
reg  [31:0] run_cnt;
wire        running;

wire        config_finished;

////--------------------------
wire        pixel_clk;
wire        pixel_clk_phs;

//--------------------------
wire        tp0_vs_in  ;
wire        tp0_hs_in  ;
wire        tp0_de_in ;
wire [ 7:0] tp0_data_r;
wire [ 7:0] tp0_data_g;
wire [ 7:0] tp0_data_b;

reg         vs_r;
reg  [9:0]  cnt_vs;

//--------------------------------------
wire        csi_clk ;
wire        csi_vs  ;
wire        csi_de  ;
wire [7:0]  csi_data/*synthesis syn_keep=1*/;

//-------------------------
wire        vs_rgb;  
wire        hs_rgb;  
wire        de_rgb;  
wire [7:0]  data_rgb_r;
wire [7:0]  data_rgb_g;
wire [7:0]  data_rgb_b;

//--------------------------------------
wire         vd_2fp_clk ;
wire         vd_2fp_vs  ;
wire         vd_2fp_hs  ;
wire         vd_2fp_de  ;
wire [23:0]  vd_2fp_data;

//--------------------------------------
wire         uni_clk    ;
wire         uni_vs     ;//Negative
wire         uni_hs     ;//Negative
wire         uni_de     ;
wire [23:0]  uni_data   ;

//-------------------------
//frame buffer in
wire                   ch0_vfb_clk_in ;
wire                   ch0_vfb_vs_in  ;
wire                   ch0_vfb_de_in  ;
wire [VIDEO_WIDTH-1:0] ch0_vfb_data_in;    

//-----------------------------
//ddr
wire        dma_clk  ;  

//-------------------------------------------------
//memory interface
wire                   cmd_ready          ;
wire[2:0]              cmd                ;
wire                   cmd_en             ;
wire[5:0]              app_burst_number   ;
wire[ADDR_WIDTH-1:0]   addr               ;
wire                   wr_data_rdy        ;
wire                   wr_data_en         ;//
wire                   wr_data_end        ;//
wire[DATA_WIDTH-1:0]   wr_data            ;   
wire[DATA_WIDTH/8-1:0] wr_data_mask       ;   
wire                   rd_data_valid      ;  
wire                   rd_data_end        ;//unused 
wire[DATA_WIDTH-1:0]   rd_data            ;   
wire                   init_calib_complete;

//-------------------
//syn_code
wire                   syn_off0_re;  // ofifo read enable signal
wire                   syn_off0_vs;
wire                   syn_off0_hs;
                       
wire                   off0_syn_de  ;
wire [VIDEO_WIDTH-1:0] off0_syn_data;
wire                   vout0fifo_empty;

//------------------------------------------
//rgb data
wire        rgb_vs     ;
wire        rgb_hs     ;
wire        rgb_de     ;
wire [23:0] rgb_data   ;  

//------------------------------------
//HDMI4 TX
wire pix_clk/*synthesis syn_keep=1*/;
wire serial_clk;

wire pll_lock;

wire hdmi4_rst_n;

assign O_gpio = 3'b11;

//==================================================
key_debounceN #
(
	.DEBCNT1 (32'd50000000 ),//1s
	.DEBCNT2 (32'd200000000) //4s
) 
key_debounceN_inst0
(
	.clk       (I_clk   ), 
	.rst_n     (1'b1    ), 
	.key_in    (I_key1  ),//I_rst_n ), 
	.key_n_out1(rst_n1  ),
	.key_n_out2(rst_n2  )
);

key_debounceN #
(
	.DEBCNT1 (32'd50000000 ),//1s
	.DEBCNT2 (32'd100000000) //2s
)
key_debounceN_inst1
(
	.clk       (I_clk   ), 
	.rst_n     (1'b1    ), 
	.key_in    (I_rst_n ), 
	.key_n_out1(        ),
	.key_n_out2(ddr_rstn )
);

//===================================================
//LED灯测试
always @(posedge I_clk or negedge rst_n1)//I_clk
begin
	if(!rst_n1)
		run_cnt <= 32'd0;
	else if(run_cnt >= 32'd50_000_000)
		run_cnt <= 32'd0;
	else
		run_cnt <= run_cnt + 1'b1;
end

assign  running = (run_cnt < 32'd25_000_000) ? 1'b1 : 1'b0;

assign  O_led[0] = ~init_calib_complete;
assign  O_led[1] = running;
assign  O_led[2] = ~config_finished;
assign  O_led[3] = running;

////===========================================================================
pix_pll pix_pll_inst
(
	.clkout (pixel_clk), //output clkout
	.lock   (         ), //output lock
	.clkoutp(pixel_clk_phs), //output clkoutp
	.reset  (~rst_n1   ), //input reset
	.clkin  (I_clk    ) //input clkin
);

//===========================================================================
//------------------------------------------------------------------
//测试图
// testpattern testpattern_inst
// (
	// .I_pxl_clk   (pixel_clk             ),//pixel clock
	// .I_rst_n     (rst_n1              ),//low active 
	// .I_mode      ({1'b0,cnt_vs[9:7]} ),//data select
	// .I_single_r  (8'd0               ),
	// .I_single_g  (8'd255             ),
	// .I_single_b  (8'd0               ),                  //800x600    //1024x768   //1280x720   //1920x1080 
	// .I_h_total   (16'd1650           ),//hor total time  // 16'd1056  // 16'd1344  // 16'd1650  // 16'd2200
	// .I_h_sync    (16'd40             ),//hor sync time   // 16'd128   // 16'd136   // 16'd40    // 16'd44  
	// .I_h_bporch  (16'd220            ),//hor back porch  // 16'd88    // 16'd160   // 16'd220   // 16'd148 
	// .I_h_res     (16'd1280           ),//hor resolution  // 16'd800   // 16'd1024  // 16'd1280  // 16'd1920
	// .I_v_total   (16'd750            ),//ver total time  // 16'd628   // 16'd806   // 16'd750   // 16'd1125 
	// .I_v_sync    (16'd5              ),//ver sync time   // 16'd4     // 16'd6     // 16'd5     // 16'd5   
	// .I_v_bporch  (16'd20             ),//ver back porch  // 16'd23    // 16'd29    // 16'd20    // 16'd36  
	// .I_v_res     (16'd720            ),//ver resolution  // 16'd600   // 16'd768   // 16'd720   // 16'd1080 
	// .I_hs_pol    (1'b0               ),//0,负极性;1,正极性
	// .I_vs_pol    (1'b0               ),//0,负极性;1,正极性
	// .O_de        (tp0_de_in          ),   
	// .O_hs        (tp0_hs_in          ),
	// .O_vs        (tp0_vs_in          ),
	// .O_data_r    (tp0_data_r         ),   
	// .O_data_g    (tp0_data_g         ),
	// .O_data_b    (tp0_data_b         )
// );

// always@(posedge pixel_clk)//clkout )
// begin
	// vs_r<=tp0_vs_in;
// end

// always@(posedge pixel_clk or negedge rst_n1)//clkout )
// begin
	// if(!rst_n1)
		// cnt_vs<=0;
	// else if(vs_r && !tp0_vs_in) //vs24 falling edge
		// cnt_vs<=cnt_vs+1;
// end 

//================================================================
//OV5647 Camera
//----------------------------
//initial
OV5647_Controller OV5647_Controller_inst
(
	.clk            (I_clk   ),   // 50Mhz clock signal
	.rstn           (ddr_rstn    ),
	.config_finished(config_finished),   // Flag to indicate that the configuration is finished
	.sioc           (O_csi_scl   ),   // SCCB interface - clock signal
	.siod           (IO_csi_sda  ),   // SCCB interface - data signal
	.resetb         (O_csi_resetb),   // RESET signal for OV5647
	.pwdn           (O_csi_pwdn  )    // PWDN signal for OV5647
);

//===================================================================
CSI2RAW8 CSI2RAW8_inst
(
	 .rstn      (rst_n2     ) 
	,.DCK_P     (I_CSI_CKP  )                                
	,.CH0_P     (I_CSI_D0P  )
	,.CH1_P     (I_CSI_D1P  )
	,.DCK_N     (I_CSI_CKN  )
	,.CH0_N     (I_CSI_D0N  )
	,.CH1_N     (I_CSI_D1N  )
	,.LPCLK     (I_CSI_LPCLK)
	,.LP0       (I_CSI_LP0  )
	,.LP1       (I_CSI_LP1  )
	,.pixclk    (csi_clk    ) 
	,.pixdata   (csi_data   )  
	,.fv        (csi_vs     ) 
	,.lv        (csi_de     )
);

//==============================================
//bayer_rgb to rgb
bayer_rgb bayer_rgb_inst
(
  .rst_n     (rst_n2      ),
  .pix_clk   (csi_clk     ),
  .vs_i      (csi_vs      ),
  .de_i      (csi_de      ),
  .data_i    (csi_data    ),
  .vs_o      (vs_rgb      ),
  .de_o      (de_rgb      ),
  .r_o       (data_rgb_r  ),
  .g_o       (data_rgb_g  ),
  .b_o       (data_rgb_b  )
);


//========================================================================
// `ifdef VIDEO_WIDTH_16     
	// assign ch0_vfb_clk_in  = pixel_clk;//clkout     ; //I_adv7611_clk  
	// assign ch0_vfb_vs_in   = tp0_vs_in;
	// assign ch0_vfb_de_in   = tp0_de_in;
	// assign ch0_vfb_data_in = {tp0_data_r[7:3],tp0_data_g[7:2],tp0_data_b[7:3]};
// `endif

`ifdef VIDEO_WIDTH_16     
	assign ch0_vfb_clk_in  = csi_clk;//clkout     ; //I_adv7611_clk  
	assign ch0_vfb_vs_in   = vs_rgb;
	assign ch0_vfb_de_in   = de_rgb;
	assign ch0_vfb_data_in = {data_rgb_r[7:3],data_rgb_g[7:2],data_rgb_b[7:3]};
`endif

//------------------------------------------------------------------
//SRAM 控制模块 
vfb_top#
(
	.IMAGE_SIZE        (IMAGE_SIZE        ),     
	.BURST_WRITE_LENGTH(BURST_WRITE_LENGTH),
	.BURST_READ_LENGTH (BURST_READ_LENGTH ),
	.ADDR_WIDTH        (ADDR_WIDTH        ),
	.DATA_WIDTH        (DATA_WIDTH        ),
	.DQ_WIDTH          (DQ_WIDTH          ),
	.VIDEO_WIDTH       (VIDEO_WIDTH       )
)
vfb_top_inst
( 
	.I_rst_n		    (init_calib_complete ),//rst_n            ),
	.I_dma_clk		    (dma_clk          ),   //sram_clk         ),
	.I_wr_halt		    (1'd0             ), //1:halt,  0:no halt
	.I_rd_halt		    (1'd0             ), //1:halt,  0:no halt
	// video data input           
	.I_vin0_clk		    (ch0_vfb_clk_in   ),
	.I_vin0_vs_n	    (ch0_vfb_vs_in    ),//只接收负极性
	.I_vin0_de		    (ch0_vfb_de_in    ),
	.I_vin0_data	    (ch0_vfb_data_in  ),
	// video data output          
	.I_vout0_clk	    (pix_clk          ),
	.I_vout0_vs_n	    (~syn_off0_vs     ),//只接收负极性
	.I_vout0_de		    (syn_off0_re      ),
	.O_vout0_den	    (off0_syn_de      ),
	.O_vout0_data	    (off0_syn_data    ),
	.O_vout0fifo_empty  (vout0fifo_empty  ),
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

//----------------------------------------------------- 
//ddr3 ip
DDR3_Memory_Interface_Top DDR3_Memory_Interface_Top_inst 
(
	.clk                (I_clk              ),
	.rst_n              (ddr_rstn            ), //rst_n1
	.app_burst_number   (app_burst_number   ),
	.cmd_ready          (cmd_ready          ),
	.cmd                (cmd                ),
	.cmd_en             (cmd_en             ),
	.addr               (addr               ),
	.wr_data_rdy        (wr_data_rdy        ),
	.wr_data            (wr_data            ),
	.wr_data_en         (wr_data_en         ),
	.wr_data_end        (wr_data_end        ),
	.wr_data_mask       (wr_data_mask       ),
	.rd_data            (rd_data            ),
	.rd_data_valid      (rd_data_valid      ),
	.rd_data_end        (rd_data_end        ),
	.sr_req             (                   ),
	.ref_req            (                   ),
	.sr_ack             (                   ),
	.ref_ack            (                   ),
	.init_calib_complete(init_calib_complete),
	.clk_out            (dma_clk            ),
	.burst              (1'b1               ),
	// mem interface
	.ddr_rst            (                   ),
	.O_ddr_addr         (O_ddr_addr         ),
	.O_ddr_ba           (O_ddr_ba           ),
	.O_ddr_cs_n         (O_ddr_cs_n         ),
	.O_ddr_ras_n        (O_ddr_ras_n        ),
	.O_ddr_cas_n        (O_ddr_cas_n        ),
	.O_ddr_we_n         (O_ddr_we_n         ),
	.O_ddr_clk          (O_ddr_clk          ),
	.O_ddr_clk_n        (O_ddr_clk_n        ),
	.O_ddr_cke          (O_ddr_cke          ),
	.O_ddr_odt          (O_ddr_odt          ),
	.O_ddr_reset_n      (O_ddr_reset_n      ),
	.O_ddr_dqm          (O_ddr_dqm          ),
	.IO_ddr_dq          (IO_ddr_dq          ),
	.IO_ddr_dqs         (IO_ddr_dqs         ),
	.IO_ddr_dqs_n       (IO_ddr_dqs_n       )
);

//---------------------------------------------------
//输出同步时序模块
wire out_de;
syn_gen syn_gen_inst
(                                   
    .I_pxl_clk   (pix_clk       ),//40MHz      //65MHz      //74.25MHz    //148.5
    .I_rst_n     (rst_n1           ),//800x600    //1024x768   //1280x720    //1920x1080    
    .I_h_total   (16'd1650        ),// 16'd1056  // 16'd1344  // 16'd1650   // 16'd2200  
    .I_h_sync    (16'd40          ),// 16'd128   // 16'd136   // 16'd40     // 16'd44   
    .I_h_bporch  (16'd220         ),// 16'd88    // 16'd160   // 16'd220    // 16'd148   
    .I_h_res     (16'd1280        ),// 16'd800   // 16'd1024  // 16'd1280   // 16'd1920  
    .I_v_total   (16'd750         ),// 16'd628   // 16'd806   // 16'd750    // 16'd1125   
    .I_v_sync    (16'd5           ),// 16'd4     // 16'd6     // 16'd5      // 16'd5      
    .I_v_bporch  (16'd20          ),// 16'd23    // 16'd29    // 16'd20     // 16'd36      
    .I_v_res     (16'd720         ),// 16'd600   // 16'd768   // 16'd720    // 16'd1080   
    .I_rd_hres   (16'd1280        ),
    .I_rd_vres   (16'd720         ),
    .I_hs_pol    (1'b1            ),//HS polarity , 0:负极性，1：正极性
    .I_vs_pol    (1'b1            ),//VS polarity , 0:负极性，1：正极性
    .O_rden      (syn_off0_re     ),
    .O_de        (out_de          ),   
    .O_hs        (syn_off0_hs     ),
    .O_vs        (syn_off0_vs     )
);

localparam N = 5; //delay N clocks
                          
reg  [N-1:0]  Pout_hs_dn   ;
reg  [N-1:0]  Pout_vs_dn   ;
reg  [N-1:0]  Pout_de_dn   ;

always@(posedge pix_clk or negedge rst_n1)
begin
	if(!rst_n1)
		begin                          
			Pout_hs_dn  <= {N{1'b1}};
			Pout_vs_dn  <= {N{1'b1}}; 
			Pout_de_dn  <= {N{1'b0}}; 
		end
	else 
		begin                          
			Pout_hs_dn  <= {Pout_hs_dn[N-2:0],syn_off0_hs};
			Pout_vs_dn  <= {Pout_vs_dn[N-2:0],syn_off0_vs}; 
			Pout_de_dn  <= {Pout_de_dn[N-2:0],out_de}; 
		end
end

//==============================================================================
//HDMI4 TX output
//---------------------------------------------
`ifdef VIDEO_WIDTH_16  
	assign rgb_data    = {off0_syn_data[15:11],3'd0,off0_syn_data[10:5],2'd0,off0_syn_data[4:0],3'd0};//{r,g,b}
	assign rgb_vs      = Pout_vs_dn[4];//syn_off0_vs;
	assign rgb_hs      = Pout_hs_dn[4];//syn_off0_hs;
	assign rgb_de 	   = Pout_de_dn[1];//off0_syn_de;
`endif

TMDS_PLL u_tmds_pll
(.clkin		(I_clk     ) 	//input clk  
,.clkout	(serial_clk) 	//output clk 
,.lock		(pll_lock  ) 	//output lock
);

assign hdmi4_rst_n = rst_n1 & pll_lock;

CLKDIV u_clkdiv
(.RESETN(hdmi4_rst_n)
,.HCLKIN(serial_clk) //clk  x5
,.CLKOUT(pix_clk)    //clk  x1
,.CALIB(1)
);
defparam u_clkdiv.DIV_MODE="5";
defparam u_clkdiv.GSREN="false";

DVI_TX_Top DVI_TX_Top_inst
(
	.I_rst_n       (hdmi4_rst_n    ),  //asynchronous reset, low active
	.I_serial_clk  (serial_clk     ),
	.I_rgb_clk     (pix_clk        ),  //pixel clock
	.I_rgb_vs      (rgb_vs         ), 
	.I_rgb_hs      (rgb_hs         ),    
	.I_rgb_de      (rgb_de         ), 
	.I_rgb_r       (rgb_data[23:16]),  
	.I_rgb_g       (rgb_data[15: 8]),  
	.I_rgb_b       (rgb_data[ 7: 0]),  
	.O_tmds_clk_p  (O_tmds_clk_p   ),
	// .O_tmds_clk_n  (O_tmds_clk_n   ),
	.O_tmds_data_p (O_tmds_data_p  )  //{r,g,b}
	// .O_tmds_data_n (O_tmds_data_n  )
);

endmodule