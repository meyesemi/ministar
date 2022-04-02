//Copyright (C)2014-2019 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.3.01Beta
//Part Number: GW2A-LV18PG484C8/I7
//Created Time: Mon Mar 16 09:52:19 2020

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    pix_pll your_instance_name(
        .clkout(clkout_o), //output clkout
        .lock(lock_o), //output lock
        .clkoutp(clkoutp_o), //output clkoutp
        .reset(reset_i), //input reset
        .clkin(clkin_i) //input clkin
    );

//--------Copy end-------------------
