//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.7.03Beta
//Part Number: GW1N-LV9PG256C6/I5
//Device: GW1N-9
//Created Time: Tue Apr 27 18:50:33 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	DPHY_TX_TOP your_instance_name(
		.reset_n(reset_n_i), //input reset_n
		.HS_CLK_P(HS_CLK_P_o), //output HS_CLK_P
		.HS_CLK_N(HS_CLK_N_o), //output HS_CLK_N
		.clk_byte(clk_byte_i), //input clk_byte
		.HS_DATA3_P(HS_DATA3_P_o), //output HS_DATA3_P
		.HS_DATA3_N(HS_DATA3_N_o), //output HS_DATA3_N
		.data_in3(data_in3_i), //input [15:0] data_in3
		.HS_DATA2_P(HS_DATA2_P_o), //output HS_DATA2_P
		.HS_DATA2_N(HS_DATA2_N_o), //output HS_DATA2_N
		.data_in2(data_in2_i), //input [15:0] data_in2
		.HS_DATA1_P(HS_DATA1_P_o), //output HS_DATA1_P
		.HS_DATA1_N(HS_DATA1_N_o), //output HS_DATA1_N
		.data_in1(data_in1_i), //input [15:0] data_in1
		.HS_DATA0_P(HS_DATA0_P_o), //output HS_DATA0_P
		.HS_DATA0_N(HS_DATA0_N_o), //output HS_DATA0_N
		.data_in0(data_in0_i), //input [15:0] data_in0
		.LP_DATA0(LP_DATA0_io), //inout [1:0] LP_DATA0
		.lp_data0_out(lp_data0_out_i), //input [1:0] lp_data0_out
		.lp_data0_in(lp_data0_in_o), //output [1:0] lp_data0_in
		.lp_data0_dir(lp_data0_dir_i), //input lp_data0_dir
		.hs_clk_en(hs_clk_en_i), //input hs_clk_en
		.hs_data_en(hs_data_en_i), //input hs_data_en
		.sclk(sclk_o) //output sclk
	);

//--------Copy end-------------------
