
`timescale 1ps/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/16 12:26:43
// Design Name: 
// Module Name: key_debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// clk 50MHz
//`define DEBCNT1 32'd25000000   //->500ms
//`define DEBCNT1 32'd50000000   //->1s
//`define DEBCNT1 32'd100000000  //->2s
//`define DEBCNT1 32'd150000000  //->3s
//`define DEBCNT1 32'd200000000  //->4s
//`define DEBCNT1 32'd300000000  //->6s
//`define DEBCNT1 32'd400000000  //->8s

//`define DEBCNT2 32'd100000000  //->2s


module key_debounceN #
(
	parameter DEBCNT1 = 32'd50000000 ,
	parameter DEBCNT2 = 32'd100000000
)
(
	input      clk       , 
	input      rst_n     , 
	input      key_in    , 
	output reg key_n_out1,
	output reg key_n_out2
);
    
    reg key_rst;

    always @(posedge clk or negedge rst_n)
    begin
    if(~rst_n)
        key_rst <= 1'b1;
    else
        key_rst <= key_in; 
    end

    reg key_rst_r;
    always @(posedge clk or negedge rst_n)
    begin
    if(~rst_n)
        key_rst_r <= 1'b1;
        else
        key_rst_r <= key_rst; 
    end

    wire key_an = key_rst_r ^ key_rst;
    reg [31:0] cnt; 
    
    always @(posedge clk or negedge rst_n)
    begin
    if(~rst_n)
        cnt <= 32'd0;
    else if(key_an)
        cnt <= 32'd0;
    else if(cnt==32'hffff_ffff)
        cnt <= cnt;
    else
        cnt <= cnt + 1'd1;
    end

    
    always @(posedge clk or negedge rst_n)
    begin
    if(~rst_n)
        key_n_out1 <= 1'b0;
    else if(cnt == 32'd50000000)  
    	key_n_out1 <= key_in;
    else if(cnt == DEBCNT1) // DEBCNT1*1/(50MHZ)  
        key_n_out1 <= 1'b1; 
    else
        key_n_out1 <= key_n_out1; 
    end
    
    always @(posedge clk or negedge rst_n)
    begin
    if(~rst_n)
        key_n_out2 <= 1'b0;
    else if(cnt == 32'd50000000)  
    	key_n_out2 <= key_in;
    else if(cnt == DEBCNT2) // DEBCNT2*1/(50MHZ)  
        key_n_out2 <= 1'b1; 
    else
        key_n_out2 <= key_n_out2; 
    end
    
endmodule
