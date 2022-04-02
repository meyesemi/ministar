module control_capture_lane2 #
(
	parameter bus_width = 8,
	parameter lane_width = 2,
	parameter format = "RAW8"
)
(
	input             rstn      ,
	input             clk       ,
	input      [15:0] din       ,   
	output            fv        , 
	output            lv        ,
	output     [15:0] dout      , 
	output reg        burst_done,
	output reg [1:0]  vc        , //virtual channel identifier (2-bit)
	output reg [5:0]  dt        , //data type (6-bit)
	output reg [15:0] wc        , //word count
	output reg [7:0]  ecc       ,  //Error correction code
	output reg        error             ,
	input             line_length_detect,
	input      [15:0] line_length
);

reg  [15:0] q_din1/*synthesis syn_keep=1*/;
reg  [15:0] q_din2/*synthesis syn_keep=1*/;

reg  [15:0] cnt;

reg  [4:0]  q_fv;
reg  [4:0]  q_lv;
wire [5:0]  data_type;

reg  [15:0] line_cnt;
wire [15:0] line_end;

assign dout = q_din2;
assign data_type = 6'h2A;//RAW8:6'h2A   RAW10:6'h2B 

assign line_end = wc[15:1]+1;

//-------------------------------------------------------------
//Start of transmission detection
always @(posedge clk or negedge rstn) 
begin  
     if(~rstn) begin
          q_din1          <= 0; 
          q_din2          <= 0;
     end
     else begin
     	    q_din1        <= din; 
     	    q_din2        <= q_din1;
     end
end   

always @(posedge clk or negedge rstn) 
begin  
	if(~rstn)
		cnt <= 16'd0;
	else if((din == 16'hB8B8) && (q_din1 == 16'd0))
		cnt <= 16'd0;
	else if(cnt == 16'hFFFF)
		cnt <= cnt;
	else
		cnt <= cnt + 1'b1;
end

//load Packet Header (PH) into registers
always @(posedge clk or negedge rstn) 
begin
	if(~rstn) 
		begin
			vc             <= 0;
			dt             <= 0;
			wc[15:8]       <= 0;
			wc[ 7:0]       <= 0;
			ecc            <= 0;  
		end
	else if(cnt == 1) 
		begin   	    
			vc       <= q_din1[7:6] ;
			dt       <= q_din1[5:0] ;
			wc[ 7:0] <= q_din1[15:8];
			wc[15:8] <= din[7:0] ;
			ecc      <= din[15:8];    
		end
end 
//frame valid detection based on data type in data id
//Data Type Description
//0x00 to 0x07 Synchronization Short Packet Data Types
//0x08 to 0x0F Generic Short Packet Data Types
always @(posedge clk or negedge rstn) 
begin
     if(~rstn)   
        q_fv      <= 0;
     else begin
        q_fv[0]   <= (cnt==1 && q_din1[5:0] ==0) ? 1 :          //0x00 = frame start code
					 (line_cnt ==16'd719 && cnt==line_end) ? 0 : q_fv[0];
                     // (cnt<5 & din[5:0] ==1) ? 0 : q_fv[0]; //0x01 = frame end code
        q_fv[4:1] <= q_fv[3:0];
     end
end
assign fv = q_fv[0];

always @(posedge clk or negedge rstn) 
begin
	if(~rstn)
		line_cnt <= 16'd0;
	else if(cnt==1 && q_din1[5:0] ==0)
		line_cnt <= 16'd0;
	else if(dt==data_type && cnt==line_end)
		line_cnt <= line_cnt + 1'b1;
	else
		line_cnt <= line_cnt;
end

//line valid detection based on data type in data id
//0x10 to 0x17 Generic Long Packet Data Types
//0x18 to 0x1F YUV Data
//0x20 to 0x27 RGB Data
//0x28 to 0x2F RAW Data
//0x30 to 0x37 User Defined Byte-based Data
always @(posedge clk or negedge rstn) 
begin
     if(~rstn) begin 
        q_lv        <= 0;
     end   
     else begin
        q_lv[0]   <= (cnt==1 && q_din1[5:0] ==data_type) ? 1 :  //2A       //line start code for YUV RGB or RAW
                     (dt==data_type && cnt==line_end) ? 0 : q_lv[0];    //number of words for line is complete
        q_lv[4:1] <= q_lv[3:0];
     end
end
assign lv = q_lv[2];  

always @(posedge clk or negedge rstn) 
begin
	if(~rstn) 
		burst_done <= 1'b0;
	else if(dt==data_type && cnt==(line_end+4))
		burst_done <= 1'b1;
	else if(dt==0 && cnt==4)
		burst_done <= 1'b1;
	else
		burst_done <= 1'b0;
end

endmodule