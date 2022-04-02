
`timescale 1ps /1ps
//`define SIM
module tb();

  //`include "gwmc_param.v"
  //`include "gwmc_local_param.v"


   reg clk,rst,rst_n,display,start;
   wire                  	ddr_cs;
   wire                  	ddr_ras;
   wire                  	ddr_cas;
   wire                  	ddr_we;
   wire                  	ddr_ck;
   wire                  	ddr_ck_n;
   wire                  	ddr_cke;
   wire                  	ddr_odt;
   wire                  	ddr_reset_n;
   wire [2-1:0]   			ddr_dm;			//DM_WIDTH=2
   wire [16-1:0]   			ddr_dq;			//DQ_WIDTH=16
   wire [2-1:0]  			ddr_dqs;		//DQS_WIDTH=2
   wire [2-1:0]  			ddr_dqs_n;		//DQS_WIDTH=2
   wire [15-1:0]  			ddr_addr;		//ROW_WIDTH=15
   wire [3-1:0] 			ddr_bank;		//BANK_WIDTH=3

   wire 					init_calib_complete;
   wire [3:0] 				show_data;
   wire [3:0] 				seg_en;
   wire [9:0] 				out;

GSR GSR(.GSRI(1'b1));

ddr3_syn_top u_top(
  .clk(clk),
  .rst_nn(rst_n),
  .start(start),
  .display(display),
  .ddr_addr(ddr_addr),
  .ddr_bank(ddr_bank),
  .ddr_cs(ddr_cs),
  .ddr_ras(ddr_ras),
  .ddr_cas(ddr_cas),
  .ddr_we(ddr_we),
  .ddr_ck(ddr_ck),
  .ddr_ck_n(ddr_ck_n),
  .ddr_cke(ddr_cke),
  .ddr_odt(ddr_odt),
  .ddr_reset_n(ddr_reset_n),
  .ddr_dm(ddr_dm),
  .ddr_dq(ddr_dq),
  .ddr_dqs(ddr_dqs),
  .ddr_dqs_n(ddr_dqs_n),
  .init_calib_complete(init_calib_complete),
  .show_data(show_data),
  .seg_en(seg_en),
  .sw(sw),
  .out(out)
);
 
localparam DQ_BITS  = 8;
localparam DQS_BITS = 1;

localparam  DQ_WIDTH = 16;

localparam nDRAM = DQ_WIDTH / DQ_BITS; 
generate 
  genvar o;
    for(o = 0; o < nDRAM; o = o + 1'b1) begin:ddr3_model
        ddr3_model ddr3_model(
          .rst_n            (ddr_reset_n),
          .ck               (ddr_ck),
          .ck_n             (ddr_ck_n),
          .cke              (ddr_cke),
          .cs_n             (ddr_cs),
          .ras_n            (ddr_ras),
          .cas_n            (ddr_cas),
          .we_n             (ddr_we),
          .dm_tdqs          (ddr_dm[((o+1)*DQS_BITS-1)-:DQS_BITS]),
          .ba               (ddr_bank),
          .addr             (ddr_addr),
          .dq               (ddr_dq[((o+1)*DQ_BITS-1)-:DQ_BITS]),
          .dqs              (ddr_dqs[((o+1)*DQS_BITS-1)-:DQS_BITS]),
          .dqs_n            (ddr_dqs_n[((o+1)*DQS_BITS-1)-:DQS_BITS]),
          .tdqs_n           (),
          .odt              (ddr_odt)
        );
      end
endgenerate

always #10000 clk = ~clk;

initial begin
  $fsdbDumpfile("ddr3.fsdb");
  $fsdbDumpvars;
end

initial
begin
    clk = 0;
    rst = 0;
    rst_n = 1;
    start = 0;
    display = 0;
    
    #2400000
    rst_n = 0;
    #480000 
    rst_n = 1;
    #160000000 

    #660_000_000;  
    start = 1'b1;
    #4800000
    start = 1'b0;
    #4800000;
    #136000000  
    start = 1'b1;
    #4800000
    start = 1'b0;
    #4800000;
    
    #4800000;
    display = 1'b1;
    #32000;
    display = 1'b0;

    #48000;
    display = 1'b1;
    #48000;
    display = 1'b0;
    #48000;
    display = 1'b1;
    #48000;
    display = 1'b0;

    #4800000;
    display = 1'b1;
    #32000;
    display = 1'b0;

    #48000;
    display = 1'b1;
    #48000;
    display = 1'b0;
    #48000;
    display = 1'b1;
    #48000;
    display = 1'b0;

    #4800000;
    display = 1'b1;
    #32000;
    display = 1'b0;

    #48000;
    display = 1'b1;
    #48000;
    display = 1'b0;
    #48000;
    display = 1'b1;
    #48000;
    display = 1'b0;
    
  #800000000;
   $finish;
end

endmodule


