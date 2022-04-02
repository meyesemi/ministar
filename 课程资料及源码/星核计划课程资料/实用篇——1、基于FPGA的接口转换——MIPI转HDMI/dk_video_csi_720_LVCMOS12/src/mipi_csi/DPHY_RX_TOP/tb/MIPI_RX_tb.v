
`timescale 1ns/1ps
module DPHY_RX_tb () ;
    parameter lane_width = 2 ; 
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
    wire [7:0] byte_D3, byte_D2, byte_D1, byte_D0 ; 
    wire [1:0] LP_CLK, LP3, LP2, LP1, LP0 ; 
    wire HS_CLK_RX_P, HS_CLK_RX_N ; 
    wire HS_DATA3_RX_P, HS_DATA3_RX_N ; 
    wire HS_DATA2_RX_P, HS_DATA2_RX_N ; 
    wire HS_DATA1_RX_P, HS_DATA1_RX_N ; 
    wire HS_DATA0_RX_P, HS_DATA0_RX_N ; 
    wire clk_byte_out ; 
    reg dout, dout1, dout2, dout3 ; 
    reg [31:0] data_in ; 
    reg [7:0] data0, data1, data2, data3 ; 
    reg [7:0] data_cntr ; 
    wire [7:0] data_out3, data_out2, data_out1, data_out0 ; 
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
                            data_in = 'b011101000111010001110100011101 ;
                            @(negedge clkx2)
                            data_in = 'b10111000011000000000011001010100 ;
                            repeat (hactive_8bit)
                                @(negedge clkx2)
                                begin
                                    data_in = {data0,data1,data2,data3} ;
                                end
                            @(negedge clkx2)
                            data_in = 'b11001010101110101100101010111010 ;
                            @(negedge clkx2)
                            data_in = 'b11001010101110101100101010111010 ;
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
                                data_in = 'b0 ;
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
                    data0 <=  0 ;
                    data1 <=  0 ;
                    data2 <=  0 ;
                    data3 <=  0 ;
                    data_cntr <=  0 ;
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
    integer i ; 
    always
        @(posedge clkx16 or negedge rstn)
        begin
            if ((~rstn)) 
                i <=  7 ;
            else
                if ((i > 0)) 
                    i <=  (i - 1) ;
                else
                    i <=  7 ;
        end
    always
        @(posedge clkx16 or negedge rstn)
        begin
            if ((~rstn)) 
                begin
                    dout <=  0 ;
                    dout1 <=  0 ;
                    dout2 <=  0 ;
                    dout3 <=  0 ;
                end
            else
                begin
                    dout <=  data_in[i] ;
                    dout1 <=  data_in[(i + 8)] ;
                    dout2 <=  data_in[(i + 16)] ;
                    dout3 <=  data_in[(i + 24)] ;
                end
        end
    assign HS_CLK_RX_P = clkx8 ; 
    assign HS_CLK_RX_N = (!clkx8) ; 
    assign HS_DATA3_RX_P = dout3 ; 
    assign HS_DATA3_RX_N = (!dout3) ; 
    assign HS_DATA2_RX_P = dout2 ; 
    assign HS_DATA2_RX_N = (!dout2) ; 
    assign HS_DATA1_RX_P = dout1 ; 
    assign HS_DATA1_RX_N = (!dout1) ; 
    assign HS_DATA0_RX_P = dout ; 
    assign HS_DATA0_RX_N = (!dout) ; 
    DPHY_RX_TOP u_DPHY_RX_TOP (.reset_n(rstn), .HS_CLK_P(HS_CLK_RX_P), .HS_CLK_N(HS_CLK_RX_N), .clk_byte_out(clk_byte_out), .HS_DATA1_P(HS_DATA1_RX_P), .HS_DATA1_N(HS_DATA1_RX_N), .data_out1(data_out1), .HS_DATA0_P(HS_DATA0_RX_P), .HS_DATA0_N(HS_DATA0_RX_N), .data_out0(data_out0), .LP_CLK(LP_CLK), .lp_clk_out(), .lp_clk_in(2'b11), .lp_clk_dir(1'b0), .LP_DATA1(LP1), 
                .lp_data1_out(), .lp_data1_in(2'b11), .lp_data1_dir(1'b0), .LP_DATA0(LP0), .lp_data0_out(), .lp_data0_in(2'b11), .lp_data0_dir(1'b0), .hs_en(hactive_flag), .term_en(1'b1), .ready(ready)) ; 
endmodule


