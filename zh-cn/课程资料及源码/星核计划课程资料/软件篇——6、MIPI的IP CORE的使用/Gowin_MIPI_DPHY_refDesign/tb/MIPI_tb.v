// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2020 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] MIPI_tb.v
//   \ \  / /\ \  / /    [Description ] Testbech file for the DPHY  design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue Mar 23 15:30:00 2020
//     \  /    \  /      [version     ] 1.0
//      \/      \/
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | XX     |24/03/20  |Initial version
// ===========Oooo==========================================Oooo========

`timescale 1ns / 1ps   

//====================================================//
// 1. Choose to use 1:8 mode or 1:16 mode
//****************************************************//
//
//               Used for 1:8 Mode
//
//`define GEN_MIPI_TX_8
//`define GEN_MIPI_RX_8
//
///////////////////////////////////////////////////
//
//               Used for 1:16 Mode
//
  `define GEN_MIPI_TX_16
  `define GEN_MIPI_RX_16
//
//****************************************************//
//====================================================//

//====================================================//
// 2. Choose the IO_TPYE: MIPI_IO or ELVDS/TLVDS
// 3. Choose the HS/LP LANE Number
//****************************************************//
//
//     Uesd for MIPI_IO IOTYPE & MIPI LANE Num.
//
/*
  `define DPHY_MIPI_IO
  `define MIPI_LANE3                                  //Defines HS (High Speed) Data Lanes 3 Enable;
  `define MIPI_LANE2                                  //Defines HS (High Speed) Data Lanes 2 Enable;
  `define MIPI_LANE1                                  //Defines HS (High Speed) Data Lanes 1 Enable;
  `define MIPI_LANE0                                  //Defines HS (High Speed) Data Lanes 0 Enable;
  */
//
///////////////////////////////////////////////////
//
// Uesd for ELVDS/TLVDS IOTYPE & HS/LP LANE Num.
//
////////////////// HS DATA LANE ///////////////////

  `define HS_DATA3                                  //Defines HS (High Speed) Data Lanes 3 Enable;
  `define HS_DATA2                                  //Defines HS (High Speed) Data Lanes 2 Enable;
  `define HS_DATA1                                  //Defines HS (High Speed) Data Lanes 1 Enable;
  `define HS_DATA0                                  //Defines HS (High Speed) Data Lanes 0 Enable;

//
////////////////// LP CLK/DATA LANE ///////////////////

//  `define LP_CLK                                                                                                        
  `define LP_DATA0                                                                                                      
//  `define LP_DATA1                                                                                                      
//  `define LP_DATA2                                                                                                      
//  `define LP_DATA3                                  

//
//****************************************************//
//====================================================//



`ifndef DPHY_MIPI_IO

       
module MIPI_tb();


   GSR GSR(.GSRI(1'b1));
   //PUR PUR_INST(.PUR(1'b1));

   reg                      rstn           ;
   reg                      clk            ;
   reg                      hs_en;

/*
  initial
  begin
    $fsdbDumpfile("dsi_tx_to_rx.fsdb");
    $fsdbDumpvars;
  end
*/

   initial begin
   clk = 0;
   rstn = 0;
   hs_en = 0;
   #1000;
   rstn = 1;
   #100;
   hs_en= 1;
   forever #10 clk = ~clk;
   end




   initial begin
   #1_000_000;
//   $finish;
   end   

 DPHY_TOP u_DPHY_TOP(
          .HS_CLK_TX_P         (HS_CLK_P),      //HS (High Speed) Clock
          .HS_CLK_TX_N         (HS_CLK_N),      //HS (High Speed) Clock
     `ifdef HS_DATA3
          .HS_DATA3_TX_P       (HS_DATA3_P),      //HS (High Speed) Data Lane 3
          .HS_DATA3_TX_N       (HS_DATA3_N),      //HS (High Speed) Data Lane 3
     `endif
     `ifdef HS_DATA2
          .HS_DATA2_TX_P       (HS_DATA2_P),      //HS (High Speed) Data Lane 2
          .HS_DATA2_TX_N       (HS_DATA2_N),      //HS (High Speed) Data Lane 2
     `endif
     `ifdef HS_DATA1
          .HS_DATA1_TX_P       (HS_DATA1_P),      //HS (High Speed) Data Lane 1
          .HS_DATA1_TX_N       (HS_DATA1_N),      //HS (High Speed) Data Lane 1
     `endif
     `ifdef HS_DATA0
          .HS_DATA0_TX_P       (HS_DATA0_P),      //HS (High Speed) Data Lane 0
          .HS_DATA0_TX_N       (HS_DATA0_N),      //HS (High Speed) Data Lane 0
     `endif
          .HS_CLK_RX_P         (HS_CLK_P),      //HS (High Speed) Clock
          .HS_CLK_RX_N         (HS_CLK_N),      //HS (High Speed) Clock
     `ifdef HS_DATA3
          .HS_DATA3_RX_P       (HS_DATA3_P),      //HS (High Speed) Data Lane 3
          .HS_DATA3_RX_N       (HS_DATA3_N),      //HS (High Speed) Data Lane 3
     `endif
     `ifdef HS_DATA2
          .HS_DATA2_RX_P       (HS_DATA2_P),      //HS (High Speed) Data Lane 2
          .HS_DATA2_RX_N       (HS_DATA2_N),      //HS (High Speed) Data Lane 2
     `endif
     `ifdef HS_DATA1
          .HS_DATA1_RX_P       (HS_DATA1_P),      //HS (High Speed) Data Lane 1
          .HS_DATA1_RX_N       (HS_DATA1_N),      //HS (High Speed) Data Lane 1
     `endif
     `ifdef HS_DATA0
          .HS_DATA0_RX_P       (HS_DATA0_P),      //HS (High Speed) Data Lane 0
          .HS_DATA0_RX_N       (HS_DATA0_N),      //HS (High Speed) Data Lane 0
     `endif
     `ifdef LP_CLK
          .LP_CLK_TX           (),        //LP (Low Power) External Interface Signals for Clock Lane
          .LP_CLK_RX           (),        //LP (Low Power) External Interface Signals for Clock Lane
     `endif
     `ifdef LP_DATA3
          .LP_DATA3_TX         (),        //LP (Low Power) External Interface Signals for Data Lane 3
          .LP_DATA3_RX         (),        //LP (Low Power) External Interface Signals for Data Lane 3
     `endif
     `ifdef LP_DATA2
          .LP_DATA2_TX         (),        //LP (Low Power) External Interface Signals for Data Lane 2
          .LP_DATA2_RX         (),        //LP (Low Power) External Interface Signals for Data Lane 2
     `endif
     `ifdef LP_DATA1
          .LP_DATA1_TX         (),        //LP (Low Power) External Interface Signals for Data Lane 1
          .LP_DATA1_RX         (),        //LP (Low Power) External Interface Signals for Data Lane 1
     `endif
     `ifdef LP_DATA0
          .LP_DATA0_TX         (),        //LP (Low Power) External Interface Signals for Data Lane 0
          .LP_DATA0_RX         (),        //LP (Low Power) External Interface Signals for Data Lane 0
     `endif
          .rstn             (rstn),
          .clkx2x4          (clk),
          .hactive_flag     (),
          .probe            (),
          .ready            ()
        );


endmodule


`endif 

/////////////////////////////////////////////////////////////////////////


`ifdef DPHY_MIPI_IO
  
module MIPI_tb();


   GSR GSR(.GSRI(1'b1));

   reg                      rstn           ;
   reg                      clk            ;
   wire                     MIPI_CLK_P       ; 

/*
  initial
  begin
    $fsdbDumpfile("dsi_tx_to_rx.fsdb");
    $fsdbDumpvars;
  end
*/

   initial begin
   clk = 0;
   rstn = 0;
   #1000;
   rstn = 1;
   #100;
   forever #10 clk = ~clk;
   end


   initial begin
   #5_000_000;
   $finish;
   end   





/////////////////////////////////////////////////////////////////////////////////////////////////

 DPHY_TOP u_DPHY_TOP(
          .HS_CLK_TX_P         (HS_CLK_P),      //HS (High Speed) Clock
          .HS_CLK_TX_N         (HS_CLK_N),      //HS (High Speed) Clock
     `ifdef MIPI_LANE3
          .HS_DATA3_TX_P       (HS_DATA3_P),      //HS (High Speed) Data Lane 3
          .HS_DATA3_TX_N       (HS_DATA3_N),      //HS (High Speed) Data Lane 3
     `endif
     `ifdef MIPI_LANE2
          .HS_DATA2_TX_P       (HS_DATA2_P),      //HS (High Speed) Data Lane 2
          .HS_DATA2_TX_N       (HS_DATA2_N),      //HS (High Speed) Data Lane 2
     `endif
     `ifdef MIPI_LANE1
          .HS_DATA1_TX_P       (HS_DATA1_P),      //HS (High Speed) Data Lane 1
          .HS_DATA1_TX_N       (HS_DATA1_N),      //HS (High Speed) Data Lane 1
     `endif
     `ifdef MIPI_LANE0
          .HS_DATA0_TX_P       (HS_DATA0_P),      //HS (High Speed) Data Lane 0
          .HS_DATA0_TX_N       (HS_DATA0_N),      //HS (High Speed) Data Lane 0
     `endif
          .HS_CLK_RX_P         (HS_CLK_P),      //HS (High Speed) Clock
          .HS_CLK_RX_N         (HS_CLK_N),      //HS (High Speed) Clock
     `ifdef MIPI_LANE3
          .HS_DATA3_RX_P       (HS_DATA3_P),      //HS (High Speed) Data Lane 3
          .HS_DATA3_RX_N       (HS_DATA3_N),      //HS (High Speed) Data Lane 3
     `endif
     `ifdef MIPI_LANE2
          .HS_DATA2_RX_P       (HS_DATA2_P),      //HS (High Speed) Data Lane 2
          .HS_DATA2_RX_N       (HS_DATA2_N),      //HS (High Speed) Data Lane 2
     `endif
     `ifdef MIPI_LANE1
          .HS_DATA1_RX_P       (HS_DATA1_P),      //HS (High Speed) Data Lane 1
          .HS_DATA1_RX_N       (HS_DATA1_N),      //HS (High Speed) Data Lane 1
     `endif
     `ifdef MIPI_LANE0
          .HS_DATA0_RX_P       (HS_DATA0_P),      //HS (High Speed) Data Lane 0
          .HS_DATA0_RX_N       (HS_DATA0_N),      //HS (High Speed) Data Lane 0
     `endif
          .rstn             (rstn),
          .clkx2x4          (clk),
          .hactive_flag     (),
          .probe            (),
          .ready            ()
        );


endmodule



`endif


