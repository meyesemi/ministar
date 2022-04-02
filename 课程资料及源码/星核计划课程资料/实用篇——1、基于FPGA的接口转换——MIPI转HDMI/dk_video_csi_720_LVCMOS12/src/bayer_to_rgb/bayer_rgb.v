//---------------------------------------------------------------------
// File name  : bayer_rgb.v
// Module name: bayer_rgb
// Created by : 
// ---------------------------------------------------------------------
// Release history
// VERSION |  Date       | AUTHOR     |    DESCRIPTION
// ---------------------------------------------------------------------
//  1.0    | 12-Jue-2017 |            |     initial 
// ---------------------------------------------------------------------

module bayer_rgb
(
  input             rst_n     ,
  input             pix_clk   ,
  input             vs_i      , //���븺����
  input             de_i      ,
  input      [7:0]  data_i    ,
  output reg        vs_o      ,
  output reg        de_o      ,
  output reg [7:0]  r_o       ,
  output reg [7:0]  g_o       ,
  output reg [7:0]  b_o       
);

//==================================================================== 
wire [15:0] hres  ;

//---------------------------
//�� pix_clk ����
reg          vs_tmp1   = 1'b0;
reg          vs_tmp2   = 1'b0;
reg          vs_tmp3   = 1'b0;
reg          de_tmp1   = 1'b0;
reg          de_tmp2   = 1'b0;
reg          de_tmp3   = 1'b0;
reg  [7:0]   data_tmp1 = 8'd0;
reg  [7:0]   data_tmp2 = 8'd0;
reg  [7:0]   data_tmp3 = 8'd0;
reg  [7:0]   data_tmp4 = 8'd0;

reg  [15:0] dehcnt;
reg  [15:0] devcnt;

reg  [15:0] dehcnt_d1;
reg  [15:0] devcnt_d1;

//---------------------
wire [7:0]  shift_data1  ;

reg  [7:0]  shift_data1_d1 = 8'd0  ;
reg  [7:0]  shift_data1_d2 = 8'd0  ;

//====================================================================================
video_format_detect video_format_detect_inst
(
  .rst_n       (rst_n  ),  //active low
  .vd_clk      (pix_clk),  //����ʱ�ӣ�pixel_clock
  .vd_vs       (vs_i   ),  //���븺����
  .vd_de       (de_i   ),             
  .vd_hres_reg (hres   )   //horizontal resolution
);

//====================================================================================
//----------------------------------------------------------------
// �� pix_clk �ֱ��vd_de�ź���ʱ����
//----------------------------------------------------------------
  always@(posedge pix_clk)
  begin
    vs_tmp1 <= vs_i;
    vs_tmp2 <= vs_tmp1;
    vs_tmp3 <= vs_tmp2;
  end

  always@(posedge pix_clk)
  begin
    de_tmp1 <= de_i;
    de_tmp2 <= de_tmp1;
    de_tmp3 <= de_tmp2;
  end
  
  always@(posedge pix_clk)
  begin
    data_tmp1 <= data_i;
    data_tmp2 <= data_tmp1;
    data_tmp3 <= data_tmp2;
    data_tmp4 <= data_tmp3;
  end
  
//----------------------------------------------------------------
// vcntͳ�ƴ�ֱ�ֱ��ʣ���һ��ͼ����de��Ч������
// ��de�ź��½��ؼ�������vs�ź������ؼ��������㣬��0,1,2,3,...
//----------------------------------------------------------------
  always@(posedge pix_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      devcnt <= 16'd0;
    else if(!vs_tmp2 & vs_tmp1)  // vs rising edge
      devcnt <= 16'd0;
    else if(de_tmp2 & !de_tmp1)  // de falling edge
      devcnt <= devcnt + 1'b1;
    else
      devcnt <= devcnt;
  end

//----------------------------------------------------------------
// hcntͳ��ˮƽ�ֱ��ʣ���ÿһ����de��Ч�����ʱ����
// ��de�ź�Ϊ��ʱ����ʱ�ӽ��м�����ͳ��ʱ�Ӹ�������ȡ����ֵ, ��0,1,2,...
//----------------------------------------------------------------
  always@(posedge pix_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      dehcnt <= 16'd0;
    else if(de_tmp1 == 1'b0 && de_i == 1'b1)  // de rising edge
      dehcnt <= 16'd0;
    else if(de_tmp2 == 1'b1)
      dehcnt <= dehcnt + 1'b1;
    else
      dehcnt <= dehcnt;
  end

//====================================================================================
//line buffer
shift_line # 
(
  .ADDR_WIDTH  (11),
  .DATA_WIDTH  (8 )
)
shift_line_inst0  
(  
  .aclr      (~rst_n           ),
  .clken     (de_tmp2          ),
  .clock     (pix_clk          ),
  .shiftin   (data_tmp2        ),
  .shiftout  (shift_data1      ),
  .delay_num (hres             )
);

//==========================================================================
//�г�������ʱ
always @(posedge pix_clk or negedge rst_n)
begin
  if(~rst_n)
    begin
      dehcnt_d1 <= 16'd0;
      devcnt_d1 <= 16'd0;
    end
  else
    begin
      dehcnt_d1 <= dehcnt;
      devcnt_d1 <= devcnt;
    end
end

//���������ʱ1��
always @(posedge pix_clk)
begin
  shift_data1_d1 <= shift_data1   ;
  shift_data1_d2 <= shift_data1_d1;
end

//===========================================================================
//bayer RGB to RGB��������4��Ϊ��λ����ɫ������ȡ�ڽ�ֵ
// B G B G ...
// G R G R ...
// B G B G ...
// G R G R ...
//�г�������ʱ
always @(posedge pix_clk or negedge rst_n)
begin
  if(~rst_n)
    begin
      r_o <= 8'd0;
      g_o <= 8'd0;
      b_o <= 8'd0;
    end
  else if(devcnt_d1>=16'd1)
    begin
      case({devcnt_d1[0],dehcnt_d1[0]})
        2'b00:
          begin
            r_o <= shift_data1   ; //ǰһ��
            g_o <= shift_data1_d1; //ǰһ��
            b_o <= data_tmp3     ; //��ǰ��
          end
        2'b01:
          begin
            r_o <= shift_data1_d1; //ǰһ��
            g_o <= shift_data1_d2; //ǰһ��
            b_o <= data_tmp4     ; //��ǰ��
          end
        2'b10:
          begin
            r_o <= data_tmp2     ; //��ǰ��
            g_o <= shift_data1   ; //ǰһ��
            b_o <= shift_data1_d1; //ǰһ��
          end                    
        2'b11:                   
          begin                  
            r_o <= data_tmp3     ; //��ǰ��
            g_o <= shift_data1_d1; //ǰһ��
            b_o <= shift_data1_d2; //ǰһ��
          end
      endcase
    end
  else
    begin
      r_o <= 8'd0;
      g_o <= 8'd0;
      b_o <= 8'd0;
    end
end

always@(posedge pix_clk)
begin
  vs_o   <= vs_tmp3;
end

always@(posedge pix_clk)
begin
  if(devcnt_d1>=16'd1)
    de_o <= de_tmp3;
  else
    de_o <= 1'b0;
end
  
endmodule