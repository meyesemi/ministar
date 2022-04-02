//Copyright (C)2014-2021 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: GowinSynthesis V1.9.7.03Beta
//Part Number: GW1N-LV9PG256C6/I5
//Device: GW1N-9
//Created Time: Tue Apr 27 18:52:03 2021

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	DPHY_RX_TOP your_instance_name(
		.reset_n(reset_n_i), //input reset_n
		.HS_CLK_P(HS_CLK_P_i), //input HS_CLK_P
		.HS_CLK_N(HS_CLK_N_i), //input HS_CLK_N
		.clk_byte_out(clk_byte_out_o), //output clk_byte_out
		.HS_DATA3_P(HS_DATA3_P_i), //input HS_DATA3_P
		.HS_DATA3_N(HS_DATA3_N_i), //input HS_DATA3_N
		.data_out3(data_out3_o), //output [15:0] data_out3
		.HS_DATA2_P(HS_DATA2_P_i), //input HS_DATA2_P
		.HS_DATA2_N(HS_DATA2_N_i), //input HS_DATA2_N
		.data_out2(data_out2_o), //output [15:0] data_out2
		.HS_DATA1_P(HS_DATA1_P_i), //input HS_DATA1_P
		.HS_DATA1_N(HS_DATA1_N_i), //input HS_DATA1_N
		.data_out1(data_out1_o), //output [15:0] data_out1
		.HS_DATA0_P(HS_DATA0_P_i), //input HS_DATA0_P
		.HS_DATA0_N(HS_DATA0_N_i), //input HS_DATA0_N
		.data_out0(data_out0_o), //output [15:0] data_out0
		.LP_DATA0(LP_DATA0_io), //inout [1:0] LP_DATA0
		.lp_data0_out(lp_data0_out_o), //output [1:0] lp_data0_out
		.lp_data0_in(lp_data0_in_i), //input [1:0] lp_data0_in
		.lp_data0_dir(lp_data0_dir_i), //input lp_data0_dir
		.hs_en(hs_en_i), //input hs_en
		.term_en(term_en_i), //input term_en
		.ready(ready_o) //output ready
	);

//--------Copy end-------------------
