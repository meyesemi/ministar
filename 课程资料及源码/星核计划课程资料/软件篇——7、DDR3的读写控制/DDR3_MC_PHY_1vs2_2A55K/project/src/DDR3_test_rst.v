`timescale 1ps/1ps
`ifdef SIM
  `define SCANCNT 16'hC7FF //16'hC7FF
`else
  `define SCANCNT 16'hC7FF
`endif

module DDR3_test #(
    parameter ADDR_WIDTH = 32,
    parameter APP_DATA_WIDTH = 32,
    parameter APP_MASK_WIDTH = 4,
    parameter BURST_MODE = "4",
    parameter USER_REFRESH = "OFF"
    )
    (
    //input
    clk, rst, app_rdy, app_rd_data_valid, app_rd_data, start, display,sw,sr_in,read_in,init_calib_complete,
    //output
    app_en, app_cmd, app_addr, app_wdf_data, app_wdf_wren,
    app_wdf_end, app_wdf_mask, app_burst,sr_req, ref_req,seg_en,seg, show_data
    );

    input clk, rst, app_rdy, app_rd_data_valid, start, display, sw, sr_in, read_in,init_calib_complete;
    input [APP_DATA_WIDTH-1:0] app_rd_data;

    output reg app_en;
    output reg [2:0] app_cmd;
    output reg [ADDR_WIDTH-1:0] app_addr /* synthesis syn_keep=1 */;
    output reg [APP_DATA_WIDTH-1:0] app_wdf_data /* synthesis syn_keep=1 */;
    output reg app_wdf_wren;
    output reg app_wdf_end;
    output reg [APP_MASK_WIDTH-1:0] app_wdf_mask /* synthesis syn_keep=1 */;
    output reg app_burst;
    output reg sr_req;
    output reg ref_req;
    output reg [7:0]seg;
    output [3:0] seg_en;
    output [3:0] show_data;

    reg [3:0]wr_cnt, rd_cnt;
    reg app_rdy_r;
   

    // start sync
    reg [2:0]   start_syn;
    reg [9:0]   sys_cnt;
    
    wire        start_pos;
    reg   [5:0]                  burst_8_cnt;
    reg   [5:0]                  burst8_rd_cnt;
    reg [4:0] rd_encnt; 
    
    wire start_pose;
    assign start_pose = init_calib_complete;
    wire  [2*APP_DATA_WIDTH-1:0] mem_data   [0:31] /* synthesis syn_romstyle = "block_ram" */;
    wire  [ADDR_WIDTH-1:0]       mem_addr   [0:7]  /* synthesis syn_romstyle = "block_ram" */;
    wire  [ADDR_WIDTH-1:0]       mem_addr_8 [0:31] /* synthesis syn_romstyle = "block_ram" */;


    assign  mem_data[0] = 64'h8808_7728_e878_f685;
    assign  mem_data[1] = 64'h1505_5a21_25b5_fa1a;
    assign  mem_data[2] = 64'h2404_0bf2_d464_ab25;
    assign  mem_data[3] = 64'h3303_45e3_f173_213a;
    assign  mem_data[4] = 64'h42e2_6694_42b2_f245;
    assign  mem_data[5] = 64'h5101_6735_d351_435a;
    assign  mem_data[6] = 64'h6000_0826_d440_f465;
    assign  mem_data[7] = 64'h7606_8947_86b6_357a;

    assign mem_data[8]  = 64'h1000_0100_2180_f290;
    assign mem_data[9]  = 64'h3000_0300_429e_d4a1;
    assign mem_data[10] = 64'h5000_0500_63ac_b6b2;
    assign mem_data[11] = 64'h7000_0700_84ba_98c3;
    assign mem_data[12] = 64'h9000_0900_a5c8_7ad4;
    assign mem_data[13] = 64'hb000_0b00_c6d6_5ce5;
    assign mem_data[14] = 64'hd000_0d00_e7e4_3ef6;
    assign mem_data[15] = 64'hf000_0f00_08f2_1f07;
   
    assign  mem_data[16] = 64'h8808_7728_b870_f688;
    assign  mem_data[17] = 64'h1505_5a21_25b1_fa19;
    assign  mem_data[18] = 64'h2404_0bf2_a462_ab2a;
    assign  mem_data[19] = 64'h3303_45e3_d173_213b;
    assign  mem_data[20] = 64'h42e2_6694_42b4_f24c;
    assign  mem_data[21] = 64'h5101_6735_d355_435d;
    assign  mem_data[22] = 64'h6000_0826_f446_f46e;
    assign  mem_data[23] = 64'h7606_8947_86b7_357f;

    assign  mem_data[24] = 64'h1000_0100_1c42_12ce;
    assign  mem_data[25] = 64'h3000_0300_3a54_34df;
    assign  mem_data[26] = 64'h5000_0500_5a66_56ea;
    assign  mem_data[27] = 64'h7000_0700_7a78_78f3;
    assign  mem_data[28] = 64'h9000_0900_9b8a_9a02;
    assign  mem_data[29] = 64'hb000_0b00_bb9c_bc11;
    assign  mem_data[30] = 64'hd000_0d00_dbae_de20;
    assign  mem_data[31] = 64'hf000_0f00_fcb0_f03d;

    assign  mem_addr[0] = 32'h0000_0000;
    assign  mem_addr[1] = 32'h0000_0100;
    assign  mem_addr[2] = 32'h0000_0210;
    assign  mem_addr[3] = 32'h0000_0310;
    assign  mem_addr[4] = 32'h0000_0420;
    assign  mem_addr[5] = 32'h0000_0520;
    assign  mem_addr[6] = 32'h0000_0630;
    assign  mem_addr[7] = 32'hF300_0730;

    assign  mem_addr_8[0]  = 32'h0000_0000;
    assign  mem_addr_8[4]  = 32'h0000_0100;
    assign  mem_addr_8[8]  = 32'h0000_0210;
    assign  mem_addr_8[12] = 32'h0000_0310;
    assign  mem_addr_8[16] = 32'h0000_0420;
    assign  mem_addr_8[20] = 32'h0000_0520;
    assign  mem_addr_8[24] = 32'h0000_0630;
    assign  mem_addr_8[28] = 32'hF300_0730;


    always@(posedge clk or posedge rst)
    begin
      if (rst)
        start_syn <= 3'b000;
      else
        start_syn <= {start_syn[1:0], start};
    end

    assign start_pos = start_syn[1] & ~start_syn[2];
    
    always@(posedge clk or posedge rst)
    begin
      if(rst)
        sys_cnt <= 10'h3FF;
      else if(start_pos)
        sys_cnt <= 10'h000;
      else if(sys_cnt != 10'h3FF)
        sys_cnt <= sys_cnt + 1'b1;
    end

    reg [1:0] start_cnt;

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        start_cnt <= 0;
      else if(start_pos)
        start_cnt <= 0;//start_cnt +1;
    end

/////////////// refresh/////////////////
    reg [2:0]   sr_syn;
    always@(posedge clk or posedge rst)
    begin
      if (rst)
        sr_syn <= 3'b000;
      else
        sr_syn <= {sr_syn[1:0], sr_in};
    end


    always@(posedge clk or posedge rst)
    begin
      if(rst)
        sr_req <= 0;
      else if(sr_syn[2])
        sr_req <= 1;
      else if(!sr_syn[2])
        sr_req <= 0;
   //   else if(mem_rdaddr >= 6'd4)
   //      sr_req <= 1'b1;
    end


    reg [9:0] user_ref_cnt;

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        user_ref_cnt <= 10'h000;
      else if(user_ref_cnt == 10'h3FF)
        user_ref_cnt <= user_ref_cnt;
      else if(wr_cnt == 8 )
        user_ref_cnt <= user_ref_cnt + 1'b1;
    end


generate 
   if(USER_REFRESH == "ON") begin: user_refresh_on
    always@(posedge clk or posedge rst)
      begin
       if(rst)
         ref_req <= 0;
       else if(user_ref_cnt == 10'h300)
         ref_req <= 1;
       else
         ref_req <= 0;
      end
   end
   else begin:user_refresh_off
     always@(posedge clk or posedge rst)
      begin
       if(rst)
         ref_req <= 0;
      end
   end

endgenerate
     

////////////////////////////////////////////////////

    reg [2:0]  read_syn;
    wire       read_pos;

    always@(posedge clk or posedge rst)
    begin
      if (rst)
        read_syn <= 3'b000;
      else
        read_syn  <= {read_syn[1:0], read_in};
    end

    assign read_pos = read_syn[1] & ~read_syn[2];


////////////////////////////////////////////////////



    always@(posedge clk or posedge rst)
    begin
      if(rst)
        wr_cnt <= 4'hF;
      else if(start_pos)
        wr_cnt <= 4'h0;
      else if( wr_cnt == 8 )
        wr_cnt <= wr_cnt;
      else if( app_en )
        wr_cnt <= wr_cnt + 1'b1;
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        rd_cnt <= 4'hF;
      else if(start_pos || read_pos )
        rd_cnt <= 4'h0;
      else if( rd_cnt == 8 )
        rd_cnt <= rd_cnt;
      else if( wr_cnt == 8 && app_en )
        rd_cnt <= rd_cnt + 1'b1;
    end
    always@(posedge clk or posedge rst)
    begin
      if(rst)
        rd_encnt <= 4'b0;
      else if( rd_encnt == 8 )
        rd_encnt <= rd_encnt;
      else if( burst_8_cnt == 34 && app_rdy  )
        rd_encnt <= rd_encnt + 1'b1;
    end


generate
    if(BURST_MODE == "4") begin: app_burst_4
    always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
        end
      else if(!app_rdy || app_en || start_pos)
        begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
        end
      else if(app_rdy && (wr_cnt < 8) )
         begin
                 if(start_cnt[1] == 1) begin
                    app_en        <= 1'b1;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b1;
                    app_wdf_end   <= 1'b1;
                    app_addr      <= mem_addr[wr_cnt];
                    app_wdf_mask  <= 8'b11110000;
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b1}};
                  end
                 else begin
                    app_en        <= 1'b1;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b1;
                    app_wdf_end   <= 1'b1;
                    app_addr      <= mem_addr[wr_cnt];
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_wdf_data  <= mem_data[wr_cnt][APP_DATA_WIDTH-1:0];
                  end
         end
      else if(app_rdy && (wr_cnt == 8) &&  (rd_cnt < 8) )
         begin
                    app_en        <= 1'b1;
                    app_cmd       <= 3'b001;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_addr      <= mem_addr[rd_cnt];
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};

         end
     end
 
  end // app_burst_4

  else if(BURST_MODE == "8") begin: app_burst_8

  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
                    burst_8_cnt   <= 0;
                    burst8_rd_cnt <= 0;
        end
      else if(!app_rdy || start_pos)
        begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
        end
      else if(app_rdy && (burst_8_cnt != 32) && ((burst_8_cnt  == 3) || (burst_8_cnt  == 7) || (burst_8_cnt  == 11) || (burst_8_cnt  == 15) || 
             (burst_8_cnt  == 19) || (burst_8_cnt  == 23) || (burst_8_cnt  == 27) || (burst_8_cnt  == 31)))

        begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b1;
                    app_wdf_end   <= 1'b1;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= mem_data[burst_8_cnt][APP_DATA_WIDTH-1:0];
                    burst_8_cnt   <= burst_8_cnt+1'b1;

        end

      else if( burst_8_cnt == 32)
        begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
                    burst_8_cnt   <= burst_8_cnt+1'b1;
        end

      else if(app_rdy && init_calib_complete && (burst_8_cnt  < 32) && ((burst_8_cnt  == 0) || (burst_8_cnt  == 4) || (burst_8_cnt  == 8) || (burst_8_cnt  == 12) || 
             (burst_8_cnt  == 16) || (burst_8_cnt  == 20) || (burst_8_cnt  == 24) || (burst_8_cnt  == 28)))
         begin
                    app_en        <= 1'b1;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b1;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_addr      <= mem_addr_8[burst_8_cnt];
                    app_wdf_data  <= mem_data[burst_8_cnt][APP_DATA_WIDTH-1:0];
                    burst_8_cnt   <= burst_8_cnt+1'b1;
                    

         end
        else if(app_rdy && init_calib_complete  && (burst_8_cnt  < 32) && ((burst_8_cnt  !== 0) || (burst_8_cnt  !== 4) || (burst_8_cnt  !== 8) || 
               (burst_8_cnt  !== 12) || (burst_8_cnt !== 16) ||(burst_8_cnt  !== 20) || (burst_8_cnt  !== 24) || (burst_8_cnt  !== 28) || (burst_8_cnt  !== 3) || 
               (burst_8_cnt  !== 7) || (burst_8_cnt  !== 11) || 
               (burst_8_cnt  !== 15) || (burst_8_cnt  !== 19) ||  (burst_8_cnt  !== 23) || (burst_8_cnt  !== 27) || (burst_8_cnt  !== 31)))
         begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b1;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_wdf_data  <= mem_data[burst_8_cnt][APP_DATA_WIDTH-1:0];
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    burst_8_cnt   <= burst_8_cnt+1'b1;
                    

         end

             else if(burst_8_cnt==33)
         begin
                    app_en        <= 1'b0;
                    app_cmd       <= 3'b000;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_burst     <= 1'b0;
                    app_addr      <= {ADDR_WIDTH{1'b0}};
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
                    burst_8_cnt   <= burst_8_cnt+1'b1;
        end


      else if(app_rdy && (burst_8_cnt == 34) &&  (rd_encnt < 8))
         begin
                    app_en        <= 1'b1;
                    app_cmd       <= 3'b001;
                    app_wdf_wren  <= 1'b0;
                    app_wdf_end   <= 1'b0;
                    app_wdf_mask  <= {APP_MASK_WIDTH{1'b0}};
                    app_addr      <= mem_addr[burst8_rd_cnt];
                    app_wdf_data  <= {APP_DATA_WIDTH{1'b0}};
                    burst8_rd_cnt <= burst8_rd_cnt+1'b1;

         end
     end//app_burst_8
   end

endgenerate

////////////////////////////////////////////////////////////
    // read data store
    reg [5:0]                 mem_rdaddr;
    reg [APP_DATA_WIDTH-1:0]  mem_rddata [0:31];
    reg                       display_en;

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        mem_rdaddr <= 6'b000000;
      else if(app_rd_data_valid)
        mem_rdaddr <= mem_rdaddr + 1'b1;
    end

  /*  always@(posedge clk)
    begin
        if(mem_rdaddr >= 6'd4)
            sr_req <= 1'b1;
        else    sr_req <= 1'b0 ;
    end
*/
    always@(posedge clk)
    begin
      if(app_rd_data_valid)
        mem_rddata[mem_rdaddr] <= app_rd_data;
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        display_en <= 1'b0;
      else if(app_rd_data_valid)
        display_en <= 1'b1;
    end 

    // read data display
    // scan cnt 1khz
    reg [15:0]    scan_cnt;
    reg           scan_en;
    reg [3:0]     seg_en;
    reg [6:0]     seg_cnt;
    reg [3:0]     show_data;
    reg [APP_DATA_WIDTH-1:0] rd_data;
    reg [2:0]     display_syn;
    reg [4:0]     display_cnt;

    reg [2:0]     sw_syn;


    always@(posedge clk or posedge rst)
    begin
      if(rst)
        display_syn <= 3'b000;
      else
        display_syn <= {display_syn[1:0], display};
    end
    
    assign display_pos = !display_syn[2] & display_syn[1];

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        display_cnt <= 5'b00000;
      else if(display_pos)
        display_cnt <= display_cnt + 1'b1;
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        sw_syn <= 3'b000;
      else
        sw_syn <= {sw_syn[1:0], sw};
    end
    
    assign sw_pos = !sw_syn[2] & sw_syn[1];

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        scan_cnt <= 16'b0;
      else if(scan_cnt >= `SCANCNT)
        scan_cnt <= 16'b0;
      else
        scan_cnt <= scan_cnt + 1'b1;
    end
      
    always@(posedge clk or posedge rst)
    begin
      if(rst)
        scan_en <= 1'b0;
      else if((scan_cnt == `SCANCNT) & display_en)
        scan_en <= 1'b1;
      else
        scan_en <= 1'b0;
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        seg_cnt <= 8'h00;
      else
      begin
        if(scan_en)
          seg_cnt[1:0] <= seg_cnt[1:0] + 1'b1;

        if(sw_pos)
          seg_cnt[3:2] <= seg_cnt[3:2] + 1'b1;
      end
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        seg_en <= 4'b1111;
      else 
      begin
        case(seg_cnt[1:0])
          2'b00 : seg_en <= 4'b0111;
          2'b01 : seg_en <= 4'b1011;
          2'b10 : seg_en <= 4'b1101;
          2'b11 : seg_en <= 4'b1110;
        endcase
      end
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        rd_data <= 'b0;
      else 
        rd_data <= mem_rddata[display_cnt];
    end

    always@(posedge clk or posedge rst)
    begin
      if(rst)
        show_data <= 'b0;
      else
        show_data <= rd_data[(seg_cnt[3:0]*4)+:4];
    end


    always@(show_data)
    begin
      case(show_data)
        4'b0000:seg=8'b1100_0000;   //c0
        4'b0001:seg=8'b1111_1001;   //f9
        4'b0010:seg=8'b1010_0100;   //a4
        4'b0011:seg=8'b1011_0000;   //b0
        4'b0100:seg=8'b1001_1001;   //99
        4'b0101:seg=8'b1001_0010;   //92
        4'b0110:seg=8'b1000_0010;   //82
        4'b0111:seg=8'b1111_1000;   //f8
        4'b1000:seg=8'b1000_0000;   //80
        4'b1001:seg=8'b1001_0000;   //90
        4'b1010:seg=8'b1000_1000;   //88
        4'b1011:seg=8'b1000_0011;   //83
        4'b1100:seg=8'b1100_0110;   //c6
        4'b1101:seg=8'b1010_0001;   //a1
        4'b1110:seg=8'b1000_0110;   //86
        4'b1111:seg=8'b1000_1110;   //8e
        default:seg=8'b1000_0110;   //86
      endcase
    end
 
endmodule





