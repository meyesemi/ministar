// ==============0ooo===================================================0ooo===========
// =  Copyright (C) 2014-2020 Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// ====================================================================================
// 
//  __      __      __
//  \ \    /  \    / /   [File name   ] rgb2dvi.v
//   \ \  / /\ \  / /    [Description ] rgb2dvi
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

//module list
//(1)rgb2dvi
//(2)TMDS8b10b

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//(1)
module rgb2dvi
(input			I_rst_n           //asynchronous reset, low active
`ifdef USE_EXTERNAL_CLK
,input          I_serial_clk 
`endif
,input			I_rgb_clk       //pixel clock
,input          I_rgb_vs       
,input          I_rgb_hs          
,input          I_rgb_de       
,input  [7:0]   I_rgb_r      
,input  [7:0]   I_rgb_g      
,input  [7:0]   I_rgb_b   
,output			O_tmds_clk_p 
// ,output			O_tmds_clk_n 
,output [2:0]	O_tmds_data_p //{r,g,b}
// ,output [2:0]	O_tmds_data_n
);

//===========================================================
wire serial_clk;

wire rst_n1;

wire [9:0] q_out_r;
wire [9:0] q_out_g;
wire [9:0] q_out_b;

//===========================================================
`ifdef USE_EXTERNAL_CLK
	assign serial_clk = I_serial_clk;
	assign rst_n1 = I_rst_n;
`else
	wire pll_lock;
	PLL TMDSTX_PLL_inst 
	(
		.CLKOUT  (serial_clk), //x5
		.LOCK    (pll_lock  ),
		.CLKOUTP (          ),
		.CLKOUTD (          ),
		.CLKOUTD3(          ),
		.RESET   (1'b0),
		.RESET_P (1'b0),
		.RESET_I (1'b0),
		.RESET_S (1'b0),
		.CLKIN   (I_rgb_clk), //x1
		.CLKFB   (1'b0),
		.FBDSEL  ({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
		.IDSEL   ({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
		.ODSEL   ({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
		.PSDA    ({1'b0,1'b0,1'b0,1'b0}),
		.DUTYDA  ({1'b0,1'b0,1'b0,1'b0}),
		.FDLY    ({1'b0,1'b0,1'b0,1'b0})
	);
	defparam TMDSTX_PLL_inst.FCLKIN = `TX_PLL_CLKIN_FRE;//"74.25";
	defparam TMDSTX_PLL_inst.DYN_IDIV_SEL = "false";
	defparam TMDSTX_PLL_inst.IDIV_SEL = 0;
	defparam TMDSTX_PLL_inst.DYN_FBDIV_SEL = "false";
	defparam TMDSTX_PLL_inst.FBDIV_SEL = 4;
	defparam TMDSTX_PLL_inst.DYN_ODIV_SEL = "false";
	defparam TMDSTX_PLL_inst.ODIV_SEL = `TX_PLL_ODIV_SEL;//2;
	defparam TMDSTX_PLL_inst.PSDA_SEL = "0000";
	defparam TMDSTX_PLL_inst.DYN_DA_EN = "false";
	defparam TMDSTX_PLL_inst.DUTYDA_SEL = "1000";
	defparam TMDSTX_PLL_inst.CLKOUT_FT_DIR = 1'b1;
	defparam TMDSTX_PLL_inst.CLKOUTP_FT_DIR = 1'b1;
	defparam TMDSTX_PLL_inst.CLKOUT_DLY_STEP = 0;
	defparam TMDSTX_PLL_inst.CLKOUTP_DLY_STEP = 0;
	defparam TMDSTX_PLL_inst.CLKFB_SEL = "internal";
	defparam TMDSTX_PLL_inst.CLKOUT_BYPASS = "false";
	defparam TMDSTX_PLL_inst.CLKOUTP_BYPASS = "false";
	defparam TMDSTX_PLL_inst.CLKOUTD_BYPASS = "false";
	defparam TMDSTX_PLL_inst.DYN_SDIV_SEL = 2;
	defparam TMDSTX_PLL_inst.CLKOUTD_SRC = "CLKOUT";
	defparam TMDSTX_PLL_inst.CLKOUTD3_SRC = "CLKOUT";
	
	//------------
	assign rst_n1 = I_rst_n & pll_lock;
`endif

//===========================================================
//Data Code
TMDS8b10b TMDS8b10b_inst_r
(
	.rstn(rst_n1         ),
	.clk (I_rgb_clk        ),
	.din (I_rgb_r          ), // 8 bits data input
	.de  (I_rgb_de         ), // data enable
	.c0  (1'b0           ), // h_sync
	.c1  (1'b0           ), // v_sync
	.dout(q_out_r        )  // 10 bits data output
);

TMDS8b10b TMDS8b10b_inst_g
(
	.rstn(rst_n1         ),
	.clk (I_rgb_clk        ),
	.din (I_rgb_g          ), // 8 bits data input
	.de  (I_rgb_de         ), // data enable
	.c0  (1'b0           ), // h_sync
	.c1  (1'b0           ), // v_sync
	.dout(q_out_g        )  // 10 bits data output
);

TMDS8b10b TMDS8b10b_inst_b //包含行，场信息
(
	.rstn(rst_n1         ),
	.clk (I_rgb_clk        ),
	.din (I_rgb_b          ), // 8 bits data input
	.de  (I_rgb_de         ), // data enable
	.c0  (I_rgb_hs         ), // h_sync
	.c1  (I_rgb_vs         ), // v_sync
	.dout(q_out_b        )  // 10 bits data output
);

//===========================================================
//Data serializer
//-----------------------------------
wire sdataout_r;

OSER10 u_OSER10_r
(.RESET(~rst_n1)
,.PCLK (I_rgb_clk) //TMDS clock x1
,.D0   (q_out_r[0])
,.D1   (q_out_r[1])
,.D2   (q_out_r[2])
,.D3   (q_out_r[3])
,.D4   (q_out_r[4])
,.D5   (q_out_r[5])
,.D6   (q_out_r[6])
,.D7   (q_out_r[7])
,.D8   (q_out_r[8])
,.D9   (q_out_r[9])
,.FCLK (serial_clk) //TMDS clock x5
,.Q    (sdataout_r)
);
defparam u_OSER10_clk.GSREN="false";
defparam u_OSER10_clk.LSREN ="true";

// TLVDS_OBUF u_TLVDS_r
// (.I (sdataout_r)
// ,.O (O_tmds_data_p[2])
// ,.OB(O_tmds_data_n[2])
// );
assign O_tmds_data_p[2] = sdataout_r;

//-----------------------------------
wire sdataout_g;

OSER10 u_OSER10_g
(.RESET(~rst_n1)
,.PCLK (I_rgb_clk) //TMDS clock x1
,.D0   (q_out_g[0])
,.D1   (q_out_g[1])
,.D2   (q_out_g[2])
,.D3   (q_out_g[3])
,.D4   (q_out_g[4])
,.D5   (q_out_g[5])
,.D6   (q_out_g[6])
,.D7   (q_out_g[7])
,.D8   (q_out_g[8])
,.D9   (q_out_g[9])
,.FCLK (serial_clk) //TMDS clock x5
,.Q    (sdataout_g)
);
defparam u_OSER10_clk.GSREN="false";
defparam u_OSER10_clk.LSREN ="true";

// TLVDS_OBUF u_TLVDS_g
// (.I (sdataout_g)
// ,.O (O_tmds_data_p[1])
// ,.OB(O_tmds_data_n[1])
// );
assign O_tmds_data_p[1] = sdataout_g;

//-----------------------------------
wire sdataout_b;

OSER10 u_OSER10_b
(.RESET(~rst_n1)
,.PCLK (I_rgb_clk) //TMDS clock x1
,.D0   (q_out_b[0])
,.D1   (q_out_b[1])
,.D2   (q_out_b[2])
,.D3   (q_out_b[3])
,.D4   (q_out_b[4])
,.D5   (q_out_b[5])
,.D6   (q_out_b[6])
,.D7   (q_out_b[7])
,.D8   (q_out_b[8])
,.D9   (q_out_b[9])
,.FCLK (serial_clk) //TMDS clock x5
,.Q    (sdataout_b)
);
defparam u_OSER10_clk.GSREN="false";
defparam u_OSER10_clk.LSREN ="true";

// TLVDS_OBUF u_TLVDS_b
// (.I (sdataout_b)
// ,.O (O_tmds_data_p[0])
// ,.OB(O_tmds_data_n[0])
// );
assign O_tmds_data_p[0] = sdataout_b;

//========================================================
//Clock serializer, clock don't need to code
wire [9:0] pclk_data;
assign pclk_data = 10'b1111100000; //clock parallel data in
wire sdataout_clk;

OSER10 u_OSER10_clk
(.RESET(~rst_n1)
,.PCLK (I_rgb_clk) //TMDS clock x1
,.D0   (pclk_data[0])
,.D1   (pclk_data[1])
,.D2   (pclk_data[2])
,.D3   (pclk_data[3])
,.D4   (pclk_data[4])
,.D5   (pclk_data[5])
,.D6   (pclk_data[6])
,.D7   (pclk_data[7])
,.D8   (pclk_data[8])
,.D9   (pclk_data[9])
,.FCLK (serial_clk) //TMDS clock x5
,.Q    (sdataout_clk)
);
defparam u_OSER10_clk.GSREN="false";
defparam u_OSER10_clk.LSREN ="true";

// TLVDS_OBUF u_TLVDS_clk
// (.I (sdataout_clk)
// ,.O (O_tmds_clk_p)
// ,.OB(O_tmds_clk_n)
// );
assign O_tmds_clk_p = sdataout_clk;

endmodule



//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//(2)
module TMDS8b10b
(
input            rstn,
input            clk ,
input            de  ,       // data enable
input      [7:0] din ,       // 8 bits data input
input            c0  ,       // h_sync
input            c1  ,       // v_sync
output reg [9:0] dout        // 10 bits data output
)/* synthesis UGROUP= "encoder_group"*/;

reg    [7:0] din_d;
reg          de_d;
reg          c0_d, c1_d;
reg          sel_xnor; 
reg signed [4:0] cnt;        

wire   [3:0] cnt_one;  
wire   [8:0] q_m;
wire   [3:0] cnt_one_9bit;

// counter the bit number of the 8-bit input data
assign cnt_one = din[0] + din[1] + din[2] + din[3] + din[4] + din[5] + din[6] + din[7];

// convert 8-bit input data to 9-bit data
assign q_m[0] = din_d[0];
assign q_m[1] = sel_xnor ? ~( q_m[0] ^ din_d[1] ) : ( q_m[0] ^ din_d[1] );
assign q_m[2] = sel_xnor ? ~( q_m[1] ^ din_d[2] ) : ( q_m[1] ^ din_d[2] );
assign q_m[3] = sel_xnor ? ~( q_m[2] ^ din_d[3] ) : ( q_m[2] ^ din_d[3] );
assign q_m[4] = sel_xnor ? ~( q_m[3] ^ din_d[4] ) : ( q_m[3] ^ din_d[4] );
assign q_m[5] = sel_xnor ? ~( q_m[4] ^ din_d[5] ) : ( q_m[4] ^ din_d[5] );
assign q_m[6] = sel_xnor ? ~( q_m[5] ^ din_d[6] ) : ( q_m[5] ^ din_d[6] );
assign q_m[7] = sel_xnor ? ~( q_m[6] ^ din_d[7] ) : ( q_m[6] ^ din_d[7] );
assign q_m[8] = ~sel_xnor;

// counter the bit number of the lower 8 bits of the 9-bit data
assign cnt_one_9bit = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7]; 

always @ ( posedge clk or negedge rstn )
    if ( !rstn ) begin
        din_d <= 8'd0;
        de_d  <= 1'b0;
        c0_d  <= 1'b1;
        c1_d  <= 1'b1;
    end
    else begin
        din_d <= din;
        de_d  <= de;
        c0_d  <= c0;
        c1_d  <= c1;
    end

always @ ( posedge clk or negedge rstn )
    if ( !rstn )
        sel_xnor <= 1'b0;
    else
        sel_xnor <= ( cnt_one > 4'd4 ) || ( ( cnt_one == 4'd4 ) && ( din[0] == 1'b0 ) );

// the bit number difference between "1" and "0" of the input data
always @ ( posedge clk or negedge rstn )
    if ( !rstn )
        cnt <= 5'b00000;
    else if ( ~de_d )
        cnt <= 5'b00000; 
    // (cnt(t-1)==0) OR (N1{q_m[7:0]}==N0{q_m[7:0]})
    else if ( ( cnt == 5'd0 ) || ( cnt_one_9bit == 4'd4 ) ) begin
        if ( q_m[8] )
            cnt <= cnt + cnt_one_9bit + cnt_one_9bit - 8;
        else
            cnt <= cnt - cnt_one_9bit - cnt_one_9bit + 8;
    end
    // (cnt(t-1)>0 AND (N1{q_m[7:0]}>N0{q_m[7:0]}) OR (cnt(t-1)<0 AND N0{q_m[7:0]}>N1{q_m[7:0]})
    else if ( ( ( cnt > 0 ) && ( cnt_one_9bit > 4 ) ) || ( cnt[4] && ( cnt_one_9bit < 4 ) ) )
        cnt <= cnt + q_m[8] + q_m[8] - cnt_one_9bit -cnt_one_9bit + 8;
    else
        cnt <= cnt + 2 - q_m[8] - q_m[8] + cnt_one_9bit + cnt_one_9bit - 8;

always @ ( posedge clk or negedge rstn )
    if ( !rstn )
        dout <= 10'd0;
    else if ( ~de_d ) begin
        case ( { c1_d, c0_d } )
            2'b00   : dout <= 10'b1101010100; //0x354 -> hs = 0, vs = 0
            2'b01   : dout <= 10'b0010101011; //0x0AB -> hs = 1, vs = 0
            2'b10   : dout <= 10'b0101010100; //0x154 -> hs = 0, vs = 1
            default : dout <= 10'b1010101011; //0x2AB -> hs = 1, vs = 1
        endcase
    end
    // (cnt(t-1)==0) OR (N1{q_m[7:0]}==N0{q_m[7:0]})
    else if ( ( cnt == 5'd0 ) || ( cnt_one_9bit == 4'd4 ) ) begin
        dout[9]   <= ~q_m[8];
        dout[8]   <= q_m[8];
        dout[7:0] <= ( q_m[8] ? q_m[7:0] : ~q_m[7:0] );
    end
    // (cnt(t-1)>0 AND (N1{q_m[7:0]}>N0{q_m[7:0]}) OR (cnt(t-1)<0 AND N0{q_m[7:0]}>N1{q_m[7:0]})
    else if ( ( ( cnt > 0 ) && ( cnt_one_9bit > 4 ) ) || ( cnt[4] && ( cnt_one_9bit < 4 ) ) ) begin
        dout[9]   <= 1'b1;
        dout[8]   <= q_m[8];
        dout[7:0] <= ~q_m[7:0];
    end
    else begin
        dout[9]   <= 1'b0;
        dout[8]   <= q_m[8];
        dout[7:0] <= q_m[7:0];
    end


endmodule



