//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.3.01 Beta
//Created Time: 2020-02-17 11:59:40
create_clock -name clk_x4i -period 3.333 -waveform {0 1.667} [get_nets {DDR3_Memory_Interface_Top_inst/gw3mc_top/u_ddr_phy_top/clk_x4i}] -add
create_clock -name clk_x4 -period 3.333 -waveform {0 1.667} [get_nets {DDR3_Memory_Interface_Top_inst/gw3mc_top/u_ddr_phy_top/clk_x4}] -add
create_clock -name I_clk -period 20 -waveform {0 10} [get_ports {I_clk}] -add
create_clock -name dma_clk -period 13.333 -waveform {0 6.667} [get_nets {dma_clk}] -add