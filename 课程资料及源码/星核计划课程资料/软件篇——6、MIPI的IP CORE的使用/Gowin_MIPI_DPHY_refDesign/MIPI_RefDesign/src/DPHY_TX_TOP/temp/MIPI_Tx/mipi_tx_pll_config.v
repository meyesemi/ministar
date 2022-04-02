`ifdef GEN_MIPI_TX_8
`ifdef PLLVR
defparam pllvr_mipi_tx.FCLKIN = "50";
defparam pllvr_mipi_tx.DYN_IDIV_SEL= "false";
defparam pllvr_mipi_tx.IDIV_SEL = 0;
defparam pllvr_mipi_tx.DYN_FBDIV_SEL= "false";
defparam pllvr_mipi_tx.FBDIV_SEL = 7;
defparam pllvr_mipi_tx.PSDA_SEL= "0100";
defparam pllvr_mipi_tx.DYN_DA_EN = "false";
defparam pllvr_mipi_tx.DYN_ODIV_SEL = "false";
defparam pllvr_mipi_tx.DUTYDA_SEL= "1000";
defparam pllvr_mipi_tx.CLKOUT_FT_DIR = 1'b1;
defparam pllvr_mipi_tx.CLKOUTP_FT_DIR = 1'b1;
defparam pllvr_mipi_tx.CLKFB_SEL = "internal";
defparam pllvr_mipi_tx.ODIV_SEL = 2;
defparam pllvr_mipi_tx.CLKOUT_BYPASS = "false";
defparam pllvr_mipi_tx.CLKOUTP_BYPASS = "false";
defparam pllvr_mipi_tx.CLKOUTD_BYPASS = "false";
defparam pllvr_mipi_tx.DYN_SDIV_SEL = 2;
defparam pllvr_mipi_tx.CLKOUTD_SRC = "CLKOUT";
defparam pllvr_mipi_tx.CLKOUTD3_SRC = "CLKOUT";
defparam pllvr_mipi_tx.DEVICE = "GW1N-9";
`else
defparam pll_mipi_tx.FCLKIN = "50";
defparam pll_mipi_tx.DYN_IDIV_SEL= "false";
defparam pll_mipi_tx.IDIV_SEL = 0;
defparam pll_mipi_tx.DYN_FBDIV_SEL= "false";
defparam pll_mipi_tx.FBDIV_SEL = 7;
defparam pll_mipi_tx.PSDA_SEL= "0100";
defparam pll_mipi_tx.DYN_DA_EN = "false";
defparam pll_mipi_tx.DYN_ODIV_SEL = "false";
defparam pll_mipi_tx.DUTYDA_SEL= "1000";
defparam pll_mipi_tx.CLKOUT_FT_DIR = 1'b1;
defparam pll_mipi_tx.CLKOUTP_FT_DIR = 1'b1;
defparam pll_mipi_tx.CLKFB_SEL = "internal";
defparam pll_mipi_tx.ODIV_SEL = 2;
defparam pll_mipi_tx.CLKOUT_BYPASS = "false";
defparam pll_mipi_tx.CLKOUTP_BYPASS = "false";
defparam pll_mipi_tx.CLKOUTD_BYPASS = "false";
defparam pll_mipi_tx.DYN_SDIV_SEL = 2;
defparam pll_mipi_tx.CLKOUTD_SRC = "CLKOUT";
defparam pll_mipi_tx.CLKOUTD3_SRC = "CLKOUT";
defparam pll_mipi_tx.DEVICE = "GW1N-9";
`endif
`endif
`ifdef GEN_MIPI_TX_16
`ifdef PLLVR
defparam pllvr_mipi_tx.FCLKIN = "50";
defparam pllvr_mipi_tx.DYN_IDIV_SEL= "false";
defparam pllvr_mipi_tx.IDIV_SEL = 0;
defparam pllvr_mipi_tx.DYN_FBDIV_SEL= "false";
defparam pllvr_mipi_tx.FBDIV_SEL = 7;
defparam pllvr_mipi_tx.PSDA_SEL= "0100";
defparam pllvr_mipi_tx.DYN_DA_EN = "false";
defparam pllvr_mipi_tx.DYN_ODIV_SEL = "false";
defparam pllvr_mipi_tx.DUTYDA_SEL= "1000";
defparam pllvr_mipi_tx.CLKOUT_FT_DIR = 1'b1;
defparam pllvr_mipi_tx.CLKOUTP_FT_DIR = 1'b1;
defparam pllvr_mipi_tx.CLKFB_SEL = "internal";
defparam pllvr_mipi_tx.ODIV_SEL = 2;
defparam pllvr_mipi_tx.CLKOUT_BYPASS = "false";
defparam pllvr_mipi_tx.CLKOUTP_BYPASS = "false";
defparam pllvr_mipi_tx.CLKOUTD_BYPASS = "false";
defparam pllvr_mipi_tx.DYN_SDIV_SEL = 2;
defparam pllvr_mipi_tx.CLKOUTD_SRC = "CLKOUT";
defparam pllvr_mipi_tx.CLKOUTD3_SRC = "CLKOUT";
defparam pllvr_mipi_tx.DEVICE = "GW1N-9";
`else
defparam pll_mipi_tx.FCLKIN = "50";
defparam pll_mipi_tx.DYN_IDIV_SEL= "false";
defparam pll_mipi_tx.IDIV_SEL = 0;
defparam pll_mipi_tx.DYN_FBDIV_SEL= "false";
defparam pll_mipi_tx.FBDIV_SEL = 7;
defparam pll_mipi_tx.PSDA_SEL= "0100";
defparam pll_mipi_tx.DYN_DA_EN = "false";
defparam pll_mipi_tx.DYN_ODIV_SEL = "false";
defparam pll_mipi_tx.DUTYDA_SEL= "1000";
defparam pll_mipi_tx.CLKOUT_FT_DIR = 1'b1;
defparam pll_mipi_tx.CLKOUTP_FT_DIR = 1'b1;
defparam pll_mipi_tx.CLKFB_SEL = "internal";
defparam pll_mipi_tx.ODIV_SEL = 2;
defparam pll_mipi_tx.CLKOUT_BYPASS = "false";
defparam pll_mipi_tx.CLKOUTP_BYPASS = "false";
defparam pll_mipi_tx.CLKOUTD_BYPASS = "false";
defparam pll_mipi_tx.DYN_SDIV_SEL = 2;
defparam pll_mipi_tx.CLKOUTD_SRC = "CLKOUT";
defparam pll_mipi_tx.CLKOUTD3_SRC = "CLKOUT";
defparam pll_mipi_tx.DEVICE = "GW1N-9";
`endif
`endif
