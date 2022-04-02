//--------------------------------------------------------------------
// File name         : video_format_detect.v
// Module name       : video_format_detect
// Module Description: video format messure
// Created by        : Caojie
// -------------------------------------------------------------------
// Release history
// VERSION|      Date   |   AUTHOR     |        DESCRIPTION
// -------------------------------------------------------------------
//   1.0  | 23-Jul-2009 | Caojie       |      initial version
// -------------------------------------------------------------------
//   1.1  |  9-Mar-2010 | Caojie       |      model changed
// -------------------------------------------------------------------
//   2.0  |  8-Feb-2017 | Caojie       |  add more information
// -------------------------------------------------------------------

module video_format_detect
(
  input             rst_n         ,  //active low
  input             vd_clk        ,  //����ʱ�ӣ�pixel_clock
  input             vd_vs         ,  //���븺����
  input             vd_de         ,             
  output reg [15:0] vd_hres_reg      //horizontal resolution
);

//=============================================================================
  //�� vd_clk ����2��
  reg          vs_tmp1 = 1'b0;
  reg          vs_tmp2 = 1'b0;
  reg          de_tmp1 = 1'b0;
  reg          de_tmp2 = 1'b0;
  
  //-----------------------------------------------
  //ˮƽ�ֱ���
  reg  [15:0]  hcnt;  // horizontal counter by vd_clk
  reg  [15:0]  vd_hres;

//====================== vd_vs/vd_hs/vd_de/ ===============================
// �� vd_clk �ֱ��vd_de�ź���ʱ����
//=========================================================================
  always@(posedge vd_clk)
  begin
    vs_tmp1 <= vd_vs;
    vs_tmp2 <= vs_tmp1;
  end

  always@(posedge vd_clk)
  begin
    de_tmp1 <= vd_de;
    de_tmp2 <= de_tmp1;
  end

//==================== hcnt ================================================
// ͳ��ˮƽ�ֱ��ʣ���ÿһ����de��Ч�����ʱ����
// ��de�ź�Ϊ��ʱ����ʱ�ӽ��м�����ͳ��ʱ�Ӹ�����
// �ڵ�16�е�hs�ź��½��أ���ȡ����ֵ
//==========================================================================
  always@(posedge vd_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0)
      hcnt <= 16'd0;
    else if(de_tmp1 == 1'b0 && vd_de == 1'b1)  // de rising edge
      hcnt <= 16'd0;
    else if(de_tmp1 == 1'b1)
      hcnt <= hcnt + 1'b1;
    else
      hcnt <= hcnt;
  end
  
  always@(posedge vd_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0) 
      vd_hres <= 16'd0;
    else if(de_tmp2 & !de_tmp1)  // hs falling edge 
      vd_hres <= hcnt;
    else
      vd_hres <= vd_hres;
  end

//==========================================================================
//======��ÿ��VS֮�����Ƶ�ʣ��ֱ��ʼ��ֵ========
//==========================================================================
//vd_clkʱ����
  always@(posedge vd_clk or negedge rst_n)
  begin
    if(rst_n == 1'b0) 
      begin
        vd_hres_reg    <= 16'd0;  
      end
    else if(vs_tmp2 & !vs_tmp1)  // vs falling edge, and not halt
      begin 
        vd_hres_reg    <= vd_hres   ; 
     end
    else 
      begin   
        vd_hres_reg    <= vd_hres_reg   ;
      end
  end
//==========================================================================

endmodule

