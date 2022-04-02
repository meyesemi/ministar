// ===========Oooo==========================================Oooo========
// =  Copyright (C) 2014-2020 Shandong Gowin Semiconductor Technology Co.,Ltd.
// =                     All rights reserved.
// =====================================================================
//
//  __      __      __
//  \ \    /  \    / /   [File name   ] TOP.v
//   \ \  / /\ \  / /    [Description ] TOP Verilog file for the DPHY RefDesign design
//    \ \/ /  \ \/ /     [Timestamp   ] Tue Mar 27 15:30:00 2018
//     \  /    \  /      [version     ] 1.0
//      \/      \/
// --------------------------------------------------------------------
// Code Revision History :
// --------------------------------------------------------------------
// Ver: | Author |Mod. Date |Changes Made:
// V1.0 | XX     |23/03/20  |Initial version
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


//====================================================//
//
// 4. TX use INTERNAL PLL or Not
//
//****************************************************//
//
   `define INTERNAL_PLL
//
//****************************************************//
//====================================================//




///////////////////////////////////////////////////
// Uesd ELVDS/TLVDS IOTYPE & 4 HS LANE & INTERNAL_PLL
///////////////////////////////////////////////////
`ifndef DPHY_MIPI_IO
       
module DPHY_TOP(
          output        HS_CLK_TX_P         ,      //HS (High Speed) Clock
          output        HS_CLK_TX_N         ,      //HS (High Speed) Clock
     `ifdef HS_DATA3
          output        HS_DATA3_TX_P       ,      //HS (High Speed) Data Lane 3
          output        HS_DATA3_TX_N       ,      //HS (High Speed) Data Lane 3
     `endif
     `ifdef HS_DATA2
          output        HS_DATA2_TX_P       ,      //HS (High Speed) Data Lane 2
          output        HS_DATA2_TX_N       ,      //HS (High Speed) Data Lane 2
     `endif
     `ifdef HS_DATA1
          output        HS_DATA1_TX_P       ,      //HS (High Speed) Data Lane 1
          output        HS_DATA1_TX_N       ,      //HS (High Speed) Data Lane 1
     `endif
     `ifdef HS_DATA0
          output        HS_DATA0_TX_P       ,      //HS (High Speed) Data Lane 0
          output        HS_DATA0_TX_N       ,      //HS (High Speed) Data Lane 0
     `endif
          input         HS_CLK_RX_P         ,      //HS (High Speed) Clock
          input         HS_CLK_RX_N         ,      //HS (High Speed) Clock
     `ifdef HS_DATA3
          input         HS_DATA3_RX_P       ,      //HS (High Speed) Data Lane 3
          input         HS_DATA3_RX_N       ,      //HS (High Speed) Data Lane 3
     `endif
     `ifdef HS_DATA2
          input         HS_DATA2_RX_P       ,      //HS (High Speed) Data Lane 2
          input         HS_DATA2_RX_N       ,      //HS (High Speed) Data Lane 2
     `endif
     `ifdef HS_DATA1
          input         HS_DATA1_RX_P       ,      //HS (High Speed) Data Lane 1
          input         HS_DATA1_RX_N       ,      //HS (High Speed) Data Lane 1
     `endif
     `ifdef HS_DATA0
          input         HS_DATA0_RX_P       ,      //HS (High Speed) Data Lane 0
          input         HS_DATA0_RX_N       ,      //HS (High Speed) Data Lane 0
     `endif
     `ifdef LP_CLK
          inout   [1:0] LP_CLK_TX           ,        //LP (Low Power) External Interface Signals for Clock Lane
          inout   [1:0] LP_CLK_RX           ,        //LP (Low Power) External Interface Signals for Clock Lane
     `endif
     `ifdef LP_DATA3
          inout   [1:0] LP_DATA3_TX         ,        //LP (Low Power) External Interface Signals for Data Lane 3
          inout   [1:0] LP_DATA3_RX         ,        //LP (Low Power) External Interface Signals for Data Lane 3
     `endif
     `ifdef LP_DATA2
          inout   [1:0] LP_DATA2_TX         ,        //LP (Low Power) External Interface Signals for Data Lane 2
          inout   [1:0] LP_DATA2_RX         ,        //LP (Low Power) External Interface Signals for Data Lane 2

     `endif
     `ifdef LP_DATA1
          inout   [1:0] LP_DATA1_TX         ,        //LP (Low Power) External Interface Signals for Data Lane 1
          inout   [1:0] LP_DATA1_RX         ,        //LP (Low Power) External Interface Signals for Data Lane 1
     `endif
     `ifdef LP_DATA0
          inout   [1:0] LP_DATA0_TX         ,        //LP (Low Power) External Interface Signals for Data Lane 0
          inout   [1:0] LP_DATA0_RX         ,        //LP (Low Power) External Interface Signals for Data Lane 0
     `endif
          input         rstn             ,
          input         clkx2x4          ,
          output  reg   hactive_flag     ,
          output  [1:0] probe            ,
          output        ready            
        );


`ifdef GEN_MIPI_RX_16   
   reg  [63:0] data_in;
   reg  [15:0] data0, data1, data2, data3;
   reg  [15:0] dout, dout1;
   reg  [15:0] data_cntr;
   reg         hactive_flag_RX;

   wire [1:0]  lp_clk_out,lp_data0_out,lp_data1_out,lp_data2_out,lp_data3_out ;

   wire [15:0] data_out3, data_out2, data_out1, data_out0;
   reg  [63:0] data_out_reg;
   wire        clk_byte_out /* synthesis syn_keep=1 */;
   wire        sclk_tx ;
`endif

`ifdef GEN_MIPI_RX_8   
   reg  [31:0] data_in;
   reg  [7:0]  data0, data1, data2, data3;
   reg  [7:0]  dout, dout1;
   reg  [7:0]  data_cntr;
   reg         hactive_flag_RX;

   wire [1:0]  lp_clk_out,lp_data0_out,lp_data1_out,lp_data2_out,lp_data3_out ;

   wire [7:0]  data_out3, data_out2, data_out1, data_out0;
   reg  [31:0] data_out_reg;
   wire        clk_byte_out /* synthesis syn_keep=1 */;
   wire        sclk_tx ;
`endif

   reg   [1:0]  hs_en;
   wire  [16:0] dout_rom;

/////////////////////////////////////////////////////
// u_plld4 : Used to change the input clock frequency of MIPI DPHY TX

    GW_PLL u_plld4(
        .clkout(clkx2), //output clkout
        .clkin(clkx2x4) //input clkin
    );

/////////////////////////////////////////////////////
// Generate HS Data & HS_EN
/////////////////////////////////////////////////////

    ROM549x17 u_ROM549x17(
     .clk   (sclk_tx),
     .rstn  (rstn),
     .dout  (dout_rom)
     );


`ifdef GEN_MIPI_TX_16 
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         {hactive_flag,dout1} <= 0;
       else
         {hactive_flag,dout1} <= dout_rom;
  end
`endif

`ifdef GEN_MIPI_TX_8 
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         {hactive_flag,dout1} <= 0;
       else
         {hactive_flag,dout1} <= {dout_rom[16],dout_rom[7:0]};
  end
`endif

/*
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         hs_en[1:0] <= 0;
       else 
         hs_en[1:0] <={ hs_en[0],!(!hactive_flag & dout_rom[16])};
  end
*/

    DPHY_TX_TOP u_DPHY_TX_TOP(
          .reset_n      (rstn)           ,
          .HS_CLK_P     (HS_CLK_TX_P)    ,
          .HS_CLK_N     (HS_CLK_TX_N)    ,
     `ifdef INTERNAL_PLL
          .clk_byte     (clkx2)          ,
     `else
          .clk_bit      (CLKOP)          ,
          .clk_bit_90   (CLKOS)          ,
     `endif
     `ifdef HS_DATA3
          .HS_DATA3_P   (HS_DATA3_TX_P)     ,
          .HS_DATA3_N   (HS_DATA3_TX_N)     ,
          .data_in3     (dout1)             ,
     `endif
     `ifdef HS_DATA2
          .HS_DATA2_P   (HS_DATA2_TX_P)     ,
          .HS_DATA2_N   (HS_DATA2_TX_N)     ,
          .data_in2     (dout1)             ,
     `endif
     `ifdef HS_DATA1
          .HS_DATA1_P   (HS_DATA1_TX_P)     ,
          .HS_DATA1_N   (HS_DATA1_TX_N)     ,
          .data_in1     (dout1)             ,
     `endif
     `ifdef HS_DATA0
          .HS_DATA0_P   (HS_DATA0_TX_P)     ,
          .HS_DATA0_N   (HS_DATA0_TX_N)     ,
          .data_in0     (dout1)             ,
     `endif
     `ifdef LP_CLK
          .LP_CLK       (LP_CLK_TX)         ,
          .lp_clk_out   (2'b11)          ,
          .lp_clk_in    ()               ,
          .lp_clk_dir   (1'b1)           ,
     `endif
     `ifdef LP_DATA3
          .LP_DATA3     (LP_DATA3_TX)       ,
          .lp_data3_out (2'b11)          ,
          .lp_data3_in  ()               ,
          .lp_data3_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA2
          .LP_DATA2     (LP_DATA2_TX)       ,
          .lp_data2_out (2'b11)          ,
          .lp_data2_in  ()               ,
          .lp_data2_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA1
          .LP_DATA1     (LP_DATA1_TX)       ,
          .lp_data1_out (2'b11)          ,
          .lp_data1_in  ()               ,
          .lp_data1_dir (1'b1)           ,
     `endif
     `ifdef LP_DATA0
          .LP_DATA0     (LP_DATA0_TX)       ,
          .lp_data0_out (2'b11)          ,
          .lp_data0_in  ()               ,
          .lp_data0_dir (1'b1)           ,
     `endif
          .hs_clk_en    (hactive_flag)   ,
          .hs_data_en   (hactive_flag)   ,    
          .sclk         (sclk_tx)
      );
   


    DPHY_RX_TOP u_DPHY_RX_TOP(
                .reset_n        (rstn)          ,  
                .HS_CLK_P       (HS_CLK_RX_P)   ,  
                .HS_CLK_N       (HS_CLK_RX_N)   ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
     `ifdef HS_DATA3
                .HS_DATA3_P     (HS_DATA3_RX_P) ,  
                .HS_DATA3_N     (HS_DATA3_RX_N) ,  
                .data_out3      (data_out3)     ,  
     `endif
     `ifdef HS_DATA2
                .HS_DATA2_P     (HS_DATA2_RX_P) ,  
                .HS_DATA2_N     (HS_DATA2_RX_N) ,  
                .data_out2      (data_out2)     ,  
     `endif
     `ifdef HS_DATA1
                .HS_DATA1_P     (HS_DATA1_RX_P) ,  
                .HS_DATA1_N     (HS_DATA1_RX_N) ,  
                .data_out1      (data_out1)     ,  
     `endif
     `ifdef HS_DATA0
                .HS_DATA0_P     (HS_DATA0_RX_P) ,  
                .HS_DATA0_N     (HS_DATA0_RX_N) ,  
                .data_out0      (data_out0)     ,  
     `endif
     `ifdef LP_CLK
                .LP_CLK         (LP_CLK_RX)     ,  
                .lp_clk_out     ()  ,  
                .lp_clk_in      ()   ,  
                .lp_clk_dir     ()  ,  
     `endif
     `ifdef LP_DATA3
                .LP_DATA3       (LP_DATA3_RX)   ,  
                .lp_data3_out   () ,  
                .lp_data3_in    ()   ,  
                .lp_data3_dir   ()  ,  
     `endif
     `ifdef LP_DATA2
                .LP_DATA2       (LP_DATA2_RX)   ,  
                .lp_data2_out   ()  ,  
                .lp_data2_in    ()   ,  
                .lp_data2_dir   ()  ,  
     `endif
     `ifdef LP_DATA1
                .LP_DATA1       (LP_DATA1_RX)   ,  
                .lp_data1_out   ()  ,  
                .lp_data1_in    ()   ,  
                .lp_data1_dir   ()  ,  
     `endif
     `ifdef LP_DATA0
                .LP_DATA0       (LP_DATA0_RX)   ,  
                .lp_data0_out   ()  ,  
                .lp_data0_in    ()   ,  
                .lp_data0_dir   ()  ,  
     `endif

                .hs_en          (hactive_flag)   ,
                .term_en        (1'b1   )       , 
                .ready          (ready)                              
      );


always @(posedge clk_byte_out or negedge rstn)
  begin
       if(~rstn)
         data_out_reg <= 0;
       else
         data_out_reg <= {data_out3,data_out2,data_out1,data_out0};
  end

assign probe[0] = ^data_out_reg;
assign probe[1] = (|lp_clk_out) | (|lp_data0_out) | (|lp_data1_out) |  (|lp_data2_out) |  (|lp_data3_out) ;

endmodule


`endif 



///////////////////////////////////////////////////
// Uesd  MIPI_IO IOTYPE & 4 MIPI LANE & INTERNAL_PLL
///////////////////////////////////////////////////

`ifdef DPHY_MIPI_IO
   
module DPHY_TOP(
          output        HS_CLK_TX_P         ,      //HS (High Speed) Clock
          output        HS_CLK_TX_N         ,      //HS (High Speed) Clock
     `ifdef MIPI_LANE3
          output        HS_DATA3_TX_P       ,      //HS (High Speed) Data Lane 3
          output        HS_DATA3_TX_N       ,      //HS (High Speed) Data Lane 3
     `endif
     `ifdef MIPI_LANE2
          output        HS_DATA2_TX_P       ,      //HS (High Speed) Data Lane 2
          output        HS_DATA2_TX_N       ,      //HS (High Speed) Data Lane 2
     `endif
     `ifdef MIPI_LANE1
          output        HS_DATA1_TX_P       ,      //HS (High Speed) Data Lane 1
          output        HS_DATA1_TX_N       ,      //HS (High Speed) Data Lane 1
     `endif
     `ifdef MIPI_LANE0
          output        HS_DATA0_TX_P       ,      //HS (High Speed) Data Lane 0
          output        HS_DATA0_TX_N       ,      //HS (High Speed) Data Lane 0
     `endif
          inout         HS_CLK_RX_P         ,      //HS (High Speed) Clock
          inout         HS_CLK_RX_N         ,      //HS (High Speed) Clock
     `ifdef MIPI_LANE3
          inout         HS_DATA3_RX_P       ,      //HS (High Speed) Data Lane 3
          inout         HS_DATA3_RX_N       ,      //HS (High Speed) Data Lane 3
     `endif
     `ifdef MIPI_LANE2
          inout         HS_DATA2_RX_P       ,      //HS (High Speed) Data Lane 2
          inout         HS_DATA2_RX_N       ,      //HS (High Speed) Data Lane 2
     `endif
     `ifdef MIPI_LANE1
          inout         HS_DATA1_RX_P       ,      //HS (High Speed) Data Lane 1
          inout         HS_DATA1_RX_N       ,      //HS (High Speed) Data Lane 1
     `endif
     `ifdef MIPI_LANE0
          inout         HS_DATA0_RX_P       ,      //HS (High Speed) Data Lane 0
          inout         HS_DATA0_RX_N       ,      //HS (High Speed) Data Lane 0
     `endif

          input         rstn             ,

          input         clkx2x4          ,
          output  reg   hactive_flag     ,
          output  [1:0] probe            ,
          output        ready            
        );


`ifdef GEN_MIPI_RX_16   
   reg  [63:0] data_in;
   reg  [15:0] data0, data1, data2, data3;
   reg  [15:0] dout, dout1;
   reg  [15:0] data_cntr;
   reg         hactive_flag_RX;

   wire [1:0]  lp_clk_out,lp_data0_out,lp_data1_out,lp_data2_out,lp_data3_out ;

   wire [15:0] data_out3, data_out2, data_out1, data_out0;
   reg  [63:0] data_out_reg;
   wire        clk_byte_out/* synthesis syn_keep=1 */;
   wire        sclk_tx ;
`endif

`ifdef GEN_MIPI_RX_8   
   reg  [31:0] data_in;
   reg  [7:0]  data0, data1, data2, data3;
   reg  [7:0]  dout, dout1;
   reg  [7:0]  data_cntr;
   reg         hactive_flag_RX;

   wire [1:0]  lp_clk_out,lp_data0_out,lp_data1_out,lp_data2_out,lp_data3_out ;

   wire [7:0]  data_out3, data_out2, data_out1, data_out0;
   reg  [31:0] data_out_reg;
   wire        clk_byte_out /* synthesis syn_keep=1 */ ;
   wire        sclk_tx ;
`endif

   reg  [1:0]  hs_en;
   wire [16:0] dout_rom;

/////////////////////////////////////////////////////
// u_plld4 : Used to change the input clock frequency of MIPI DPHY TX

    GW_PLL u_plld4(
        .clkout(clkx2), //output clkout
        .clkin(clkx2x4) //input clkin
    );

/////////////////////////////////////////////////////
// Generate HS Data & HS_EN
/////////////////////////////////////////////////////
    ROM549x17 u_ROM549x17(
     .clk   (sclk_tx),
     .rstn  (rstn),
     .dout  (dout_rom)
     );


`ifdef GEN_MIPI_TX_16 
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         {hactive_flag,dout1} <= 0;
       else
         {hactive_flag,dout1} <= dout_rom;
  end
`endif

`ifdef GEN_MIPI_TX_8 
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         {hactive_flag,dout1} <= 0;
       else
         {hactive_flag,dout1} <= {dout_rom[16],dout_rom[7:0]};
  end
`endif

/*
  always @(posedge sclk_tx or negedge rstn)
  begin
       if(~rstn)
         hs_en[1:0] <= 0;
       else 
         hs_en[1:0] <={ hs_en[0],!(!hactive_flag & dout_rom[16])};
  end
*/

/////////////////////////////////////////////////////
// Generate LP Data
//
// lp_dir_clk = 1 ; lp_data3/2/1/0_dir =1 ;
// RX LP is OUTPUT
//
// lp_dir_clk = 0 ; lp_data3/2/1/0_dir =0 ;
// RX LP is INPUT
//
/////////////////////////////////////////////////////
  reg   [7:0] cnt_lp;
  wire  [1:0] lp_data;
  wire          lp_clk_dir, lp_data3_dir,lp_data2_dir,lp_data1_dir,lp_data0_dir; 
  wire  [1:0]   lp_clk_in , lp_data3_in, lp_data2_in, lp_data1_in, lp_data0_in;

  always @(posedge clkx2 or negedge rstn)
  begin
       if(~rstn)
         cnt_lp <= 'b0;
       else 
         cnt_lp <= cnt_lp +1'b1 ;
  end

  assign  lp_data[0] = 1'b1;//(cnt_lp > 8'h3F) ?  cnt_lp[7] : cnt_lp[3] ;
  assign  lp_data[1] = 1'b1;//(cnt_lp > 8'h3F) ?  cnt_lp[4] : cnt_lp[6] ; 

  assign   lp_clk_dir   = 1'b0;
  assign   lp_data3_dir = 1'b0;
  assign   lp_data2_dir = 1'b0;
  assign   lp_data1_dir = 1'b0;
  assign   lp_data0_dir = 1'b0;

  assign   lp_clk_in    =  2'b00;
  assign   lp_data3_in  = 2'b00;
  assign   lp_data2_in  = 2'b00;
  assign   lp_data1_in  = 2'b00;
  assign   lp_data0_in  = 2'b00;

/*
  assign   lp_clk_in    = {cnt_lp[5],cnt_lp[4]};// 2'b00;
  assign   lp_data3_in  = {cnt_lp[4],cnt_lp[3]};//2'b00;
  assign   lp_data2_in  = {cnt_lp[3],cnt_lp[2]};//2'b00;
  assign   lp_data1_in  = {cnt_lp[2],cnt_lp[1]};//2'b00;
  assign   lp_data0_in  = {cnt_lp[1],cnt_lp[0]};//2'b00;
*/



`ifdef DPHY_MIPI_IO

    DPHY_TX_TOP u_DPHY_TX_TOP(
          .reset_n        (rstn)           ,
          .MIPI_CLK_P     (HS_CLK_TX_P)    ,
          .MIPI_CLK_N     (HS_CLK_TX_N)    ,
     `ifdef INTERNAL_PLL
          .clk_byte       (clkx2)          ,
     `else
          .clk_bit        (CLKOP)          ,
          .clk_bit_90     (CLKOS)          ,
     `endif
          .lp_clk_out     (lp_data)    , 
     `ifdef MIPI_LANE3
          .MIPI_LANE3_P   (HS_DATA3_TX_P)  ,   
          .MIPI_LANE3_N   (HS_DATA3_TX_N)  ,   
          .data_in3       (dout1)      , 
          .lp_data3_out   (lp_data)  ,    
     `endif
     `ifdef MIPI_LANE2
          .MIPI_LANE2_P   (HS_DATA2_TX_P)  ,   
          .MIPI_LANE2_N   (HS_DATA2_TX_N)  ,   
          .data_in2       (dout1)      ,   
          .lp_data2_out   (lp_data)  ,  
     `endif
     `ifdef MIPI_LANE1
          .MIPI_LANE1_P   (HS_DATA1_TX_P)  ,   
          .MIPI_LANE1_N   (HS_DATA1_TX_N)  ,   
          .data_in1       (dout1)      ,  
          .lp_data1_out   (lp_data)  ,   
     `endif
     `ifdef MIPI_LANE0
          .MIPI_LANE0_P   (HS_DATA0_TX_P)  ,   
          .MIPI_LANE0_N   (HS_DATA0_TX_N)  ,   
          .data_in0       (dout1)      ,  
          .lp_data0_out   (lp_data)  ,   
     `endif

          .hs_clk_en      (hactive_flag)   ,
          .hs_data_en     (hactive_flag)   ,    
          .sclk           (sclk_tx)
      );


    DPHY_RX_TOP u_DPHY_RX_TOP(
                .reset_n        (rstn)          ,  
                .MIPI_CLK_P       (HS_CLK_RX_P)   ,  
                .MIPI_CLK_N       (HS_CLK_RX_N)   ,  

     `ifdef CROSS_FIFO
                .clk_byte       (clk_byte)      ,  
     `endif
                .clk_byte_out   (clk_byte_out)  ,  
                .lp_clk_out     (lp_clk_out)    ,
                .lp_clk_in      (lp_clk_in)     ,   
                .lp_clk_dir     (lp_clk_dir)    ,
     `ifdef MIPI_LANE3
                .MIPI_LANE3_P   (HS_DATA3_RX_P)  ,  
                .MIPI_LANE3_N   (HS_DATA3_RX_N)  ,  
                .data_out3      (data_out3)     , 
                .lp_data3_out   (lp_data3_out)  , 
                .lp_data3_in    (lp_data3_in)   ,   
                .lp_data3_dir   (lp_data3_dir)  ,  
     `endif
     `ifdef MIPI_LANE2
                .MIPI_LANE2_P   (HS_DATA2_RX_P)  ,  
                .MIPI_LANE2_N   (HS_DATA2_RX_N)  ,  
                .data_out2      (data_out2)     ,  
                .lp_data2_out   (lp_data2_out)  ,
                .lp_data2_in    (lp_data2_in)   ,   
                .lp_data2_dir   (lp_data2_dir)  ,  
     `endif
     `ifdef MIPI_LANE1
                .MIPI_LANE1_P   (HS_DATA1_RX_P)  ,  
                .MIPI_LANE1_N   (HS_DATA1_RX_N)  ,  
                .data_out1      (data_out1)     ,  
                .lp_data1_out   (lp_data1_out)  ,
                .lp_data1_in    (lp_data1_in)   ,   
                .lp_data1_dir   (lp_data1_dir)  ,   
     `endif
     `ifdef MIPI_LANE0
                .MIPI_LANE0_P   (HS_DATA0_RX_P) ,  
                .MIPI_LANE0_N   (HS_DATA0_RX_N) ,  
                .data_out0      (data_out0)     ,  
                .lp_data0_out   (lp_data0_out)  ,
                .lp_data0_in    (lp_data0_in)   ,   
                .lp_data0_dir   (lp_data0_dir)  ,  
     `endif
                .hs_en          (hactive_flag   ),
                .term_en        (term_en)      ,
                .ready          (ready)                              
      );



`endif


always @(posedge clk_byte_out or negedge rstn)
  begin
       if(~rstn)
         data_out_reg <= 0;
       else
         data_out_reg <= {data_out3,data_out2,data_out1,data_out0};
  end

assign probe[0] = ^data_out_reg;
assign probe[1] = (|lp_clk_out) | (|lp_data0_out) | (|lp_data1_out) |  (|lp_data2_out) |  (|lp_data3_out) ;



endmodule

`endif





