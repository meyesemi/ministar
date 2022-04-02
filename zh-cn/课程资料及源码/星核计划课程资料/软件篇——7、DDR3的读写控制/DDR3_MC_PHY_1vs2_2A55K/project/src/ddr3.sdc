//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.5.02 Beta
//Created Time: 2020-05-21 14:53:58
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
create_clock -name clk_x1 -period 8 -waveform {0 4} [get_nets {clk_x1}]
create_clock -name clk_x2 -period 4 -waveform {0 2} [get_nets {u_ddr3/genblk1.gw3mc_top/u_ddr_phy_top/clk_x2i}]
set_clock_groups -exclusive -group [get_clocks {clk_x1}] -group [get_clocks {clk_x2}] -group [get_clocks {clk}]
