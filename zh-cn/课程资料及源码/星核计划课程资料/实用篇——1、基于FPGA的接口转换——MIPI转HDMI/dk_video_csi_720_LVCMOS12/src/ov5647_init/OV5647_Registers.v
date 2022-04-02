module OV5647_Registers 
(
    input clk, 
    input resend, 
    input taken, 
    output waitnull, //wait signal. 1 wait
    output [23:0] command, 
    output finished
);

//------------------------------------------------
localparam STARTTIME = 32'd4_000;
localparam WAITTIME  = 32'd5_000_000; //32'd5_000_000; //10ms 

reg [31:0] wait_cnt;
reg        wait_flag;

    // Internal signals
    reg [23:0] sreg;
    reg finished_temp;
    reg [8:0] address;
    
    // Assign values to outputs
    assign command = sreg; 
    assign finished = finished_temp;
    
    assign waitnull = wait_flag;
    
    // When register and value is FFFF
    // a flag is asserted indicating the configuration is finished
    always @ (sreg) begin
        if(sreg == 24'hFFFFFF) begin
            finished_temp <= 1;
        end
        else begin
            finished_temp <= 0;
        end
    end
 
    //--------------------------------------------------------
	//wait at least 5ms
    always @ (posedge clk)
    begin
    	if(resend == 1)
    		wait_cnt <= 32'd0;
    	else if(address == 1)
    		begin
    			if(wait_cnt>=(STARTTIME+WAITTIME))
    				wait_cnt <= wait_cnt;
    			else
    				wait_cnt <= wait_cnt + 1'b1;
    		end
    	else
    		wait_cnt <= 32'd0;
    end
    
    always @ (posedge clk)
    begin
    	if(resend == 1)
    		wait_flag <= 1'b0;
    	else if(wait_cnt > STARTTIME && wait_cnt < WAITTIME)
    		wait_flag <= 1'b1;
    	else
    		wait_flag <= 1'b0;
    end

    //--------------------------------------------------------
    
    // Get value out of the LUT
    always @ (posedge clk) begin
        if(resend == 1) begin           // reset the configuration
            address <= 9'd0;
        end
        else if(taken == 1) begin     // Get the next value
            address <= address+1;
        end

           
        case (address) 
			000 : sreg <= 24'h0100_00; //0x0100[0] software standby                   //////////////// Global Initial
			001 : sreg <= 24'h0103_01; //0x0103[0] software reset, 1 reset     // then need to wait at least 5ms
			002 : sreg <= 24'h3016_08; //[3] mipi pad enable
			003 : sreg <= 24'h3018_44; //0x3018[7:5] MIPI lane, 0x3018[2] MIPI enable
			004 : sreg <= 24'h4800_04; //MIPI CTRL 00 [4] 1:send line short packet   0:not send
			005 : sreg <= 24'h3106_05; //SRB CTRL  PLL clock divider     //05             
			006 : sreg <= 24'h0100_01; //0x0100[0] wake up from software standby      //////////////// End Global Initial 
			007 : sreg <= 24'h0100_00; //0x0100[0] software standby                   //////////////// Set 720p:1280*720@30fps
			008 : sreg <= 24'h3034_08; //[3:0] 8:8 bit mode  A:10 bit mode 
			009 : sreg <= 24'h3035_11; //0x3035[7:4] pll_div, 0x3035[3:0] divider_mipi 
			010 : sreg <= 24'h3036_50; //0x3036[7:0] pll_multiplier 
			011 : sreg <= 24'h303c_11; //PLL ctrol 
			012 : sreg <= 24'h3800_00; //0x3800[3:0] = dvp_hstart[11:8]
			013 : sreg <= 24'h3801_18; //0x3801[7:0] = dvp_hstart[7:0]   //24
			014 : sreg <= 24'h3802_00; //0x3802[3:0] = dvp_vstart[11:8]
			015 : sreg <= 24'h3803_f8; //0x3803[7:0] = dvp_vstart[7:0]   //248
			016 : sreg <= 24'h3804_0a; //0x3804[3:0] = dvp_hend[11:8]
			017 : sreg <= 24'h3805_27; //0x3805[7:0] = dvp_hend[7:0]     //2599
			018 : sreg <= 24'h3806_06; //0x3806[3:0] = dvp_vend[11:8]
			019 : sreg <= 24'h3807_a7; //0x3807[7:0] = dvp_vend[7:0]     //1703
			020 : sreg <= 24'h3808_05; //0x3808[3:0] = dvp_hout[11:8]
			021 : sreg <= 24'h3809_00; //0x3809[7:0] = dvp_hout[7:0]     //1280
			022 : sreg <= 24'h380a_02; //0x380a[3:0] = dvp_vout[11:8]
			023 : sreg <= 24'h380b_d0; //0x380b[7:0] = dvp_vout[7:0]     //720
			024 : sreg <= 24'h380c_06; //0x380c[4:0] = h_total[12:8]
			025 : sreg <= 24'h380d_82; //0x380d[7:0] = h_total[7:0]      //1666  
			026 : sreg <= 24'h380e_03; //0x380e[4:0] = v_total[12:8]     
			027 : sreg <= 24'h380f_20; //0x380f[7:0] = v_total[7:0]      //800    
			028 : sreg <= 24'h3814_31; //h subsample inc
			029 : sreg <= 24'h3815_31; //v subsample inc  
			030 : sreg <= 24'h3820_06; //TC_REG20 [2:1] filp
			031 : sreg <= 24'h3821_00; //TC_REG21 [2:1] mirror 
			032 : sreg <= 24'h503d_00; //[7] testpattern_en 0:disable, 1:enable //80 //82 //92
			033 : sreg <= 24'h3612_5b; //0x3600~0x3637 Analog control registers
			034 : sreg <= 24'h3618_04; //0x3600~0x3637 Analog control registers
			035 : sreg <= 24'h3708_64; //0x3700~0x373a Analog control registers //64
			036 : sreg <= 24'h3709_12; //0x3700~0x373a Analog control registers
			037 : sreg <= 24'h370c_03; //0x3700~0x373a Analog control registers ////03 or 0f
			038 : sreg <= 24'h3630_2e; //0x3600~0x3637 Analog control registers
			039 : sreg <= 24'h3632_e2; //0x3600~0x3637 Analog control registers
			040 : sreg <= 24'h3633_23; //0x3600~0x3637 Analog control registers
			041 : sreg <= 24'h3634_44; //0x3600~0x3637 Analog control registers	
			042 : sreg <= 24'h0100_01; //0x0100[0] wake up from software standby      //////////////// End Set 720p
			default : sreg <= 24'hFFFF_FF;    // End configuration
        endcase  
            
    end 
    
endmodule               
                        
    //-------------------------------------------------------------------------------  
    // PLL MY_OUTPUT clock(fclk)  
    // fclk = (0x40 - 0x300E[5:0]) x N x Bit8Div x MCLK / M, where  
    //      N = 1, 1.5, 2, 3 for 0x300F[7:6] = 0~3, respectively  
    //      M = 1, 1.5, 2, 3 for 0x300F[1:0] = 0~3, respectively  
    //      Bit8Div = 1, 1, 4, 5 for 0x300F[5:4] = 0~3, respectively  
    // Sys Clk = fclk / Bit8Div / SenDiv  
    // Sensor MY_OUTPUT clock(DVP PCLK)  
    // DVP PCLK = ISP CLK / DVPDiv, where  
    //      ISP CLK =  fclk / Bit8Div / SenDiv / CLKDiv / 2, where  
    //          Bit8Div = 1, 1, 4, 5 for 0x300F[5:4] = 0~3, respectively  
    //          SenDiv = 1, 2 for 0x3010[4] = 0 or 1 repectively  
    //          CLKDiv = (0x3011[5:0] + 1)  
    //      DVPDiv = 0x304C[3:0] * (2 ^ 0x304C[4]), if 0x304C[3:0] = 0, use 16 instead  
    //  
    // Base shutter calculation  
    //      60Hz: (1/120) * ISP Clk / QXGA_MODE_WITHOUT_DUMMY_PIXELS  
    //      50Hz: (1/100) * ISP Clk / QXGA_MODE_WITHOUT_DUMMY_PIXELS  
    //-------------------------------------------------------------------------------                          
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        