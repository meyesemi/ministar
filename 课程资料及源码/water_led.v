`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Myminieye
// Engineer: xu
// 
// Create Date:  2021-04-06
// Design Name: water_led
// Module Name: water_led
// Project Name: 
// Target Devices: Gowin
// Tool Versions: 
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define UD #1

module water_led(
   input          clk, //27M 
    output  [1:0]led
);

//==============================================================================

    reg [24:0] led_light_cnt= 25'd0;
    reg [ 1:0] led_status = 2'b01;
    
    //  time counter
    always @(posedge clk)
    begin
        if(led_light_cnt == 25'd1349_9999)
            led_light_cnt <= `UD 25'd0;
        else
            led_light_cnt <= `UD led_light_cnt + 25'd1; 
    end
    
    // led status change
    always @(posedge clk)
    begin
        if(led_light_cnt == 25'd1349_9999)
            led_status <= `UD {led_status[0],led_status[1]};
    end

    assign led = led_status;

endmodule