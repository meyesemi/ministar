
`timescale 1ns/1ps
module DPHY_TX_tb () ;
    parameter lane_width = 4 ; 
    parameter word_width = 8 ; 
    GSR GSR (.GSRI(1'b1)) ; 
    parameter num_frames = 1 ; 
    parameter htotal = (2200 / lane_width) ; 
    parameter hactive = (1920 / lane_width) ; 
    parameter htotal_8bit = ((word_width * htotal) / 8) ; 
    parameter hactive_8bit = ((word_width * hactive) / 8) ; 
    parameter vtotal = 112 ; 
    parameter vactive = 100 ; 
    reg rstn ; 
    reg clk ; 
    reg clkx2 ; 
    reg clkx4 ; 
    reg clkx8 ; 
    reg clkx16 ; 
    reg hactive_flag ; 
    wire [1:0] LPCLK, LP3, LP2, LP1, LP0 ; 
    wire HS_CLK_TX_P, HS_CLK_TX_N ; 
    wire HS_DATA3_TX_P, HS_DATA3_TX_N ; 
    wire HS_DATA2_TX_P, HS_DATA2_TX_N ; 
    wire HS_DATA1_TX_P, HS_DATA1_TX_N ; 
    wire HS_DATA0_TX_P, HS_DATA0_TX_N ; 
    wire sclk_tx ; 
    reg [63:0] data_in ; 
    reg [15:0] data0, data1, data2, data3 ; 
    reg [15:0] dout, dout1 ; 
    reg [15:0] data_cntr ; 
    initial
        begin
            rstn = 1'b0 ;
            clk = 1'b0 ;
            clkx2 = 1'b0 ;
            clkx4 = 1'b0 ;
            clkx8 = 1'b0 ;
            clkx16 = 1'b0 ;
            data_in = 'b0 ;
            data_cntr = 'b0 ;
            hactive_flag = 'b0 ;
            #(1200) rstn = 1'b1 ;
            #(1200) ;
            repeat (num_frames)
                begin
                    repeat (vactive)
                        begin
                            @(negedge clkx2)
                            hactive_flag = 1 ;
                            @(negedge clkx2)
                            data_in = 'h001D_001D_001D_001D ;
                            @(negedge clkx2)
                            data_in = 'h00B8_0060_0006_0054 ;
                            repeat (hactive_8bit)
                                @(negedge clkx2)
                                begin
                                    data_in = {data0,data1,data2,data3} ;
                                end
                            @(negedge clkx2)
                            data_in = 'h00CA_00BA_00CA_00BA ;
                            @(negedge clkx2)
                            data_in = 'h00CA_00BA_00CA_00BA ;
                            @(negedge clkx2)
                            hactive_flag = 0 ;
                            repeat ((((htotal_8bit - hactive_8bit) - 3) - 2))
                                @(negedge clkx2)
                                data_in = 0 ;
                        end
                    repeat ((((vtotal - vactive) - 1) - 1))
                        begin
                            repeat (htotal_8bit)
                                @(negedge clkx2)
                                data_in = 'h0000_0000_0000_0000 ;
                        end
                end
            $finish  ;
        end
    parameter periode_16 = 1 ; 
    parameter periode_8 = 2 ; 
    parameter periode_4 = 4 ; 
    parameter periode_2 = 8 ; 
    parameter periode_1 = 16 ; 
    always
        clk = #(periode_1)  (~clk) ;
    always
        clkx2 = #(periode_2)  (~clkx2) ;
    always
        clkx4 = #(periode_4)  (~clkx4) ;
    always
        clkx8 = #(periode_8)  (~clkx8) ;
    always
        clkx16 = #(periode_16)  (~clkx16) ;
    always
        @(posedge clkx2 or negedge rstn)
        begin
            if ((~hactive_flag)) 
                begin
                    data0 <=  'b0 ;
                    data1 <=  'b0 ;
                    data2 <=  'b0 ;
                    data3 <=  'b0 ;
                    data_cntr <=  'b0 ;
                end
            else
                begin
                    data0 <=  data_cntr ;
                    data1 <=  data_cntr ;
                    data2 <=  data_cntr ;
                    data3 <=  data_cntr ;
                    data_cntr <=  (data_cntr + 1) ;
                end
        end
    always
        @(posedge clkx2 or negedge rstn)
        begin
            if ((~rstn)) 
                begin
                    dout <=  'b0 ;
                    dout1 <=  'b0 ;
                end
            else
                begin
                    dout <=  {data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7],data_in[8],data_in[9],data_in[10],data_in[11],data_in[12],data_in[13],data_in[14],
                            data_in[15]} ;
                    dout1 <=  dout ;
                end
        end
    DPHY_TX_TOP u_DPHY_TX_TOP (.reset_n(rstn), .HS_CLK_P(HS_CLK_TX_P), .HS_CLK_N(HS_CLK_TX_N), .clk_byte(clkx2), .HS_DATA3_P(HS_DATA3_TX_P), .HS_DATA3_N(HS_DATA3_TX_N), .data_in3(dout1), .HS_DATA2_P(HS_DATA2_TX_P), .HS_DATA2_N(HS_DATA2_TX_N), .data_in2(dout1), .HS_DATA1_P(HS_DATA1_TX_P), .HS_DATA1_N(HS_DATA1_TX_N), .data_in1(dout1), .HS_DATA0_P(HS_DATA0_TX_P), .HS_DATA0_N(HS_DATA0_TX_N), 
                .data_in0(dout1), .LP_DATA0(LP0), .lp_data0_out(2'b00), .lp_data0_in(), .lp_data0_dir(1'b1), .hs_clk_en(hactive_flag), .hs_data_en(hactive_flag), .sclk(sclk_tx)) ; 
endmodule


