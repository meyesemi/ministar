`timescale 1ps /1ps

module ddr3_syn_top
      (
     clk,
     rst_nn,//rst_n,
     display,
     start,
     ddr_addr,
     //ddr_addr_15,
     ddr_bank,

     ddr_cs,
     ddr_ras,
     ddr_cas,
     ddr_we,
     ddr_ck,
     ddr_ck_n,
     ddr_cke,
     ddr_odt,
     ddr_reset_n,
     ddr_dm,
     ddr_dq,
     ddr_dqs,
     ddr_dqs_n,
     init_calib_complete,
     show_data,
     seg_en,
     sw,
     out
     
);

  //`include "gwmc_param.v"
  //`include "gwmc_local_param.v"

    input                                   clk;
    input                                   rst_nn;
    input                                   display;
    input                                   start;
    output [15-1:0]                         ddr_addr;       //ROW_WIDTH=15
    //output                  ddr_addr_15;
    output [3-1:0]                          ddr_bank;       //BANK_WIDTH=3

    output                                  ddr_cs;
    output                                  ddr_ras;
    output                                  ddr_cas;
    output                                  ddr_we;
    output                                  ddr_ck;
    output                                  ddr_ck_n;
    output                                  ddr_cke;
    output                                  ddr_odt;
    output                                  ddr_reset_n;
    output [2-1:0]                          ddr_dm;         //DM_WIDTH=2
    inout [16-1:0]                          ddr_dq;         //DQ_WIDTH=16
    inout [2-1:0]                           ddr_dqs;        //DQS_WIDTH=2
    inout [2-1:0]                           ddr_dqs_n;      //DQS_WIDTH=2
    output                                  init_calib_complete;

    output [3:0]                            seg_en;
    output [3:0]                            show_data;
    input                                   sw;
    
    output [9:0]                            out;
    

    //assign ddr_addr_15 =  0; 
    assign ddr_cs = 1'b0;

    
    wire                                    app_wdf_wren;
    wire  [8-1:0]                           app_wdf_mask;       //APP_MASK_WIDTH=8
    wire                                    app_wdf_end; 
    wire [64-1:0]                           app_wdf_data;       //APP_DATA_WIDTH=64
    reg [2*2-1:0]                           app_raw_not_ecc;     //nCK_PER_CLK=2
    wire                                    app_en;
    wire [2:0]                              app_cmd;
    wire [29-1:0]                           app_addr;            //ADDR_WIDTH=29
    reg                                     app_correct_en;
    wire                                    app_sre_req;
    wire                                    app_ref_req;

    wire                                    app_burst;



    wire                                    app_sre_act;
    wire                                    app_ref_ack;
    wire                                    app_wdf_rdy;
    wire                                    complete_done;

    wire                                    app_rdy;
    wire                                    app_rd_data_valid; 
    wire                                    app_rd_data_end;
    wire [64-1:0]                           app_rd_data;        //APP_DATA_WIDTH=64
    wire [64/32-1:0]                        app_ecc_multiple_err;    //APP_DATA_WIDTH=64

    wire [2-1:0]                            mc_ras_n;      //nCK_PER_CLK=2
    wire [2-1:0]                            mc_cas_n;      //nCK_PER_CLK=2
    wire [2-1:0]                            mc_we_n;       //nCK_PER_CLK=2
    wire [2*15-1:0]                         mc_address;    //nCK_PER_CLK=2, ROW_WIDTH=15
    wire [2*3-1:0]                          mc_bank;        //nCK_PER_CLK=2,BANK_WIDTH=3
    wire [2*1*2-1:0]                        mc_cs_n;   //CS_WIDTH=2, nCS_PER_RANK=1,nCK_PER_CLK=2
    wire [1:0]                              mc_odt;
    wire [2-1:0]                            mc_cke;    //nCK_PER_CLK=2
    wire                                    mc_reset_n;
    wire [2*2*16-1:0]                       mc_wrdata;     //nCK_PER_CLK=2, DQ_WIDTH=16
    wire [2*2*16/8-1:0]                     mc_wrdata_mask;      //nCK_PER_CLK=2, DQ_WIDTH=16, nDq_pre_Dqs=8
    wire                                    mc_wrdata_en;
    
    wire                                    mc_cmd_wren;
    wire [1:0]                              mc_cas_slot;
    // From PHY to MC
    wire                                    phy_mc_ctl_full;
    wire                                    phy_mc_cmd_full;
    wire                                    phy_mc_data_full;
    wire [2*2*16-1:0]                       phy_rd_data;       //nCK_PER_CLK=2, DQ_WIDTH=16
    wire                                    phy_rd_data_valid;
   
    wire [7:0]                              seg;

    reg                                     sr_in,read_in;
    wire                                    sr_req,ref_req;
    wire                                    ddr_rst;


`define SIM   //used for simulation

`ifdef SIM

 assign   display_1 = display;
 assign    start_1  = start;
 assign    sw_1     = sw;
 assign    rst_n    = rst_nn;

`else
key_debounce u2(
.clk(clk),
.rst_n(rst_n),
.key_1(display_1),
.key1_n(display)
);   

key_debounce u3(
.clk(clk),
.rst_n(rst_n),
.key_1(start_1),
.key1_n(start)
);   

key_debounce u4(
.clk(clk),
.rst_n(rst_n),
.key_1(sw_1),
.key1_n(sw)
);  

key_debounce u5(
.clk(clk),
.rst_n(1'b1),
.key_1(rst_n),
.key1_n(rst_nn)
);  
`endif

DDR3_test  #
    (
     .ADDR_WIDTH(29) ,                  //ADDR_WIDTH=29
     .APP_DATA_WIDTH(64) ,              //APP_DATA_WIDTH=64
     .APP_MASK_WIDTH (8)                //APP_MASK_WIDTH=8
    )u_rd(
    .clk           (clk_x1),
    .rst           (~rst_n),    
    .app_rdy       (app_rdy),
    .app_en        (app_en),
    .app_cmd       (app_cmd),
    .app_addr      (app_addr),
    .app_wdf_data  (app_wdf_data),
    .app_wdf_wren  (app_wdf_wren),
    .app_wdf_end   (app_wdf_end),
    .app_wdf_mask  (app_wdf_mask),
    .app_burst     (app_burst),
    .app_rd_data_valid(app_rd_data_valid),
    .app_rd_data   (app_rd_data), 
    .start(start_1),
    .display(~display_1),
    .seg(seg),
    .seg_en(seg_en),
    .show_data(show_data),
    .sw(~sw_1),
    .init_calib_complete(init_calib_complete),
    .sr_in(sr_in),
    .read_in(read_in),
    .sr_req(sr_req),
    .ref_req(ref_req)
    );

DDR3_Memory_Interface_Top u_ddr3 (
    .clk            (clk),
    .rst_n           (rst_n),
    .cmd_ready       (app_rdy),
    .cmd             (app_cmd),
    .cmd_en          (app_en),
    .addr            (app_addr),
    .wr_data_rdy     (app_wdf_rdy),
    .wr_data         (app_wdf_data),
    .wr_data_en      (app_wdf_wren),
    .wr_data_end     (app_wdf_end),
    .wr_data_mask    (app_wdf_mask),
    .rd_data         (app_rd_data),
    .rd_data_valid   (app_rd_data_valid),
    .rd_data_end     (app_rd_data_end),
    .sr_req          (app_sre_req),
    .ref_req         (app_ref_req),
    .sr_ack          (app_sre_act),
    .ref_ack         (app_ref_ack),
    .init_calib_complete(init_calib_complete),
    .clk_out         (clk_x1),
    `ifdef ECC
    .ecc_err         (ecc_err),
    `endif
    .burst           (app_burst),
    // mem interface
    .ddr_rst         (ddr_rst),
    .O_ddr_addr      (ddr_addr),
    .O_ddr_ba        (ddr_bank),
    .O_ddr_cs_n      (ddr_cs1),
    .O_ddr_ras_n     (ddr_ras),
    .O_ddr_cas_n     (ddr_cas),
    .O_ddr_we_n      (ddr_we),
    .O_ddr_clk       (ddr_ck),
    .O_ddr_clk_n     (ddr_ck_n),
    .O_ddr_cke       (ddr_cke),
    .O_ddr_odt       (ddr_odt),
    .O_ddr_reset_n   (ddr_reset_n),
    .O_ddr_dqm       (ddr_dm),
    .IO_ddr_dq       (ddr_dq),
    .IO_ddr_dqs      (ddr_dqs),
    .IO_ddr_dqs_n    (ddr_dqs_n)
);


endmodule





