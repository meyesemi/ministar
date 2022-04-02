module CSI2RAW8 #
(parameter bus_width          = 8           
,parameter lane_width         = 2            
,parameter lp_mode            = "OFF"        
,parameter line_length_detect = 1            
,parameter line_length        = 1920 //1600         
,parameter format             = "RAW8"    
)
(input                  rstn       
,input                  DCK_P                                     
,input                  CH0_P    
,input                  CH1_P  
,input                  DCK_N    
,input                  CH0_N    
,input                  CH1_N 
,inout [1:0]            LPCLK
,inout [1:0]            LP0
,inout [1:0]            LP1
//,output                 pixclk_adj 
,output                 pixclk
,output [bus_width-1:0] pixdata     
,output                 fv         
,output                 lv 
);

wire [15:0] din16;
wire        sclk_l/*synthesis syn_keep=1*/;
wire [1:0]  lp_data0_out/*synthesis syn_keep=1*/;
reg  [3:0]  lp_out_dly;
wire        hs_en/*synthesis syn_keep=1*/;
reg         hs_en_d1;
reg         term_en;

wire        burst_done;


//========================================================================
assign hs_en = ~(|lp_data0_out); //LP be 0, hs_en be 1, enter HS, initial word alignment

always @(posedge sclk_l or negedge rstn)
begin
	if(!rstn)
		hs_en_d1    <= 0;
	else 
		hs_en_d1    <= hs_en;
end

always @(posedge sclk_l or negedge rstn)
begin
	if(!rstn)
		term_en    <= 0;
	else 
		term_en    <= (~hs_en_d1 & hs_en) ? 1 : 
	                    burst_done        ? 0 : term_en;
		// term_en    <= ~hs_en;
end

//================================================================
DPHY_RX_TOP DPHY_RX_TOP_inst
(
	 .reset_n       (rstn)
	,.HS_CLK_P      (DCK_P)
	,.HS_CLK_N      (DCK_N)
	,.clk_byte_out  (sclk_l)
	,.HS_DATA1_P    (CH1_P)
	,.HS_DATA0_P    (CH0_P)
	,.HS_DATA1_N    (CH1_N)
	,.HS_DATA0_N    (CH0_N)
	,.data_out1     (din16[15:8])
	,.data_out0     (din16[7:0])
	,.LP_CLK        (LPCLK)
	,.lp_clk_out    ()
	,.lp_clk_in     (2'b11)
	,.lp_clk_dir    (1'b0 ) 
	,.LP_DATA1      (LP1)
	,.lp_data1_out  ()
	,.lp_data1_in   (2'b11)
	,.lp_data1_dir  (1'b0 )
	,.LP_DATA0      (LP0)
	,.lp_data0_out  (lp_data0_out)
	,.lp_data0_in   (2'b11)
	,.lp_data0_dir  (1'b0 )
	,.hs_en         (hs_en  )
	,.term_en       (term_en)//0:LP, 1:HS
	,.ready         ()
);              

wire fv_8bit, lv_8bit;
wire [15:0] data;

control_capture_lane2 #
(
	 .bus_width(bus_width)
	,.lane_width(lane_width)
	,.format(format)
) 
u_control_capture
(
	 .rstn(rstn)
	,.clk(sclk_l)
	,.din(din16)
	,.fv(fv_8bit) //vs
	,.lv(lv_8bit) //de
	,.dout(data)
	,.burst_done(burst_done)
	,.vc()
	,.dt()
	,.wc()
	,.ecc()
	,.line_length_detect()
	,.line_length()
);

raw8_lane2 #
(
	 .bus_width(bus_width)
	,.lane_width(lane_width)
) 
u_raw8_lane2
(
	 .rstn(rstn)
	,.clk(sclk_l)
	,.din(data)
	,.fv_sclk(fv_8bit) //vs
	,.lv_sclk(lv_8bit) //de
	,.pixclk(pixclk)
	,.pixdata(pixdata)
	,.fv_pclk(fv)      //vs
	,.lv_pclk(lv)      //de
);

pll_8bit_2lane  //16*sclk_l --> 8*pixclk
pll
(
	 .clkin  (sclk_l)
	,.reset  (~rstn)
	,.clkout (pixclk)
	,.clkoutp()//pixclk_adj)
	,.lock   (lock)
);
  
endmodule  