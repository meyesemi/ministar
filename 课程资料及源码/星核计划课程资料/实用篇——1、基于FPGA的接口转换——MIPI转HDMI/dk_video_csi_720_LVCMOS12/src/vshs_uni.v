//---------------------------------------------------------------------
// File name         : vshs_uni.v
// Module name       : vshs_uni
// Module Description: change the vs/hs signal to low active mode
// Created by        : caojie
// ---------------------------------------------------------------------
// Release history
// VERSION |  Date      | AUTHOR       |    DESCRIPTION
// ---------------------------------------------------------------------
// 1.0     |12-dec-2008 | caojie       |      initial
// ---------------------------------------------------------------------

module vshs_uni
(
	input              rst_n      ,
	input              vd_2fp_clk ,
	input              vd_2fp_vs  ,
	input              vd_2fp_hs  ,
	input              vd_2fp_de  ,
	input      [23:0]  vd_2fp_data,
	output     [1:0]   vhs_pol    ,//vs,hs polarity, 0,Negative; 1,Positive
	output             uni_clk    ,
	output reg         uni_vs     ,//Negative
	output reg         uni_hs     ,//Negative
	output reg         uni_de     ,
	output reg [23:0]  uni_data
);

//=======================================  
// regs
reg    vd_2fp_hs_d1  = 1'b0;
reg    vd_2fp_hs_d2  = 1'b0;
  
reg    vd_2fp_vs_d1  = 1'b0;
reg    vd_2fp_vs_d2  = 1'b0;

reg  [15:0]  hs_low_cnt;
reg  [15:0]  hs_hign_cnt;
reg          hs_low_active; 

reg  [15:0]  vs_low_cnt;
reg  [15:0]  vs_hign_cnt;
reg          vs_low_active;

wire         uni_hs_w;  
wire         uni_vs_w;  
wire         uni_de_w; 
wire  [23:0] uni_data_w;

//=======================================================================  
assign vhs_pol= {vs_low_active,hs_low_active};
assign uni_clk = vd_2fp_clk;
  
//========================================================================  
always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) 
    uni_hs <= 1'b0;
  else if(hs_low_active == 1'b0)
    uni_hs <= vd_2fp_hs;
  else
    uni_hs <= ~vd_2fp_hs; 
end 

always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) 
    uni_vs <= 1'b0;
  else if(vs_low_active == 1'b0)
    uni_vs <= vd_2fp_vs;
  else
    uni_vs <= ~vd_2fp_vs; 
end 

//----------------------------
always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) 
    uni_de <= 1'b0;
  else
    uni_de <= vd_2fp_de; 
end 

always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) 
    uni_data <= 24'd0;
  else 
    uni_data <= vd_2fp_data;
end  
    
//=================== vs/hs delay =========================
always@(posedge vd_2fp_clk)
begin
  vd_2fp_hs_d1 <= vd_2fp_hs;
  vd_2fp_hs_d2 <= vd_2fp_hs_d1;
end

//------------------------------------ 
always@(posedge vd_2fp_clk)
begin
  vd_2fp_vs_d1 <= vd_2fp_vs;
  vd_2fp_vs_d2 <= vd_2fp_vs_d1;
end

//=================== vs/hs counter ====================
//------------- hs low/high counter ------------
always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) begin
    hs_low_cnt <= 16'd0;
    hs_hign_cnt <= 16'd0;
  end 
  else if(vd_2fp_hs_d2 == 1'b1 && vd_2fp_hs_d1 == 1'b0) begin  // hs falling edge clear
    hs_low_cnt <= 16'd0;
    hs_hign_cnt <= 16'd0;
  end
  else if(vd_2fp_hs_d2 == 1'b0)  begin // low level counter
    hs_low_cnt <= hs_low_cnt + 1'b1;
    hs_hign_cnt <= hs_hign_cnt;
  end
  else if(vd_2fp_hs_d2 == 1'b1) begin  // hign level counter
    hs_low_cnt <= hs_low_cnt;
    hs_hign_cnt <= hs_hign_cnt + 1'b1;
  end
end

always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) begin
    hs_low_active <= 1'b0;
  end
  else if(vd_2fp_hs_d2 == 1'b1 && vd_2fp_hs_d1 == 1'b0) begin  // hs falling edge clear
    hs_low_active <= (hs_low_cnt <= hs_hign_cnt) ? 1'b0 : 1'b1;
  end
  else begin
    hs_low_active <= hs_low_active;
  end
end

//---------------------------------------------------
//------------- vs low/hign counter ------------
always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) begin
    vs_low_cnt <= 16'd0;
    vs_hign_cnt <= 16'd0;
  end 
  else if(vd_2fp_vs_d2 == 1'b1 && vd_2fp_vs_d1 == 1'b0) begin  // vs falling edge clear
    vs_low_cnt <= 16'd0;
    vs_hign_cnt <= 16'd0;
  end
  else if(vd_2fp_vs_d2 == 1'b0 && vd_2fp_hs_d2 == 1'b1 && vd_2fp_hs_d1 == 1'b0)  begin // low level counter
    vs_low_cnt <= vs_low_cnt + 1'b1;
    vs_hign_cnt <= vs_hign_cnt;
  end
  else if(vd_2fp_vs_d2 == 1'b1 && vd_2fp_hs_d2 == 1'b1 && vd_2fp_hs_d1 == 1'b0)  begin // hign level counter
    vs_low_cnt <= vs_low_cnt;
    vs_hign_cnt <= vs_hign_cnt + 1'b1;
  end
end

always@(posedge vd_2fp_clk or negedge rst_n)
begin
  if(rst_n == 1'b0) begin
    vs_low_active <= 1'b0;
  end
  else if(vd_2fp_vs_d2 == 1'b1 && vd_2fp_vs_d1 == 1'b0) begin // vs falling edge clear
    vs_low_active <= (vs_low_cnt <= vs_hign_cnt) ? 1'b0 : 1'b1;
  end
  else begin
    vs_low_active <= vs_low_active;
  end
end

endmodule

