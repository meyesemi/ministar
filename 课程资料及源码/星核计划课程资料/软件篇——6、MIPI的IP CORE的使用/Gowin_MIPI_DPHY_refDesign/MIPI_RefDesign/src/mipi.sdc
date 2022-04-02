//Copyright (C)2014-2020 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.3 beta
//Created Time: 2020-03-23 16:19:23

create_clock -name clk_tx -period 10 -waveform {0 5} [get_pins {u_DPHY_TX_TOP/DPHY_TX_INST/u_oserx8/U3_CLKDIV/CLKOUT}]
create_clock -name clk_rx -period 10 -waveform {0 5} [get_pins {u_DPHY_RX_TOP/DPHY_RX_INST/u_idesx8/Inst3_CLKDIV/CLKOUT}]
