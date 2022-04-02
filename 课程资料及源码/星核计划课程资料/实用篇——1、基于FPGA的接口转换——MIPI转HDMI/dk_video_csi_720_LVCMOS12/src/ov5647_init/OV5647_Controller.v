module OV5647_Controller (
    input clk,                              // 50Mhz clock signal
    input rstn,
    output config_finished,                 // Flag to indicate that the configuration is finished
    output sioc,                            // SCCB interface - clock signal
    inout siod,                             // SCCB interface - data signal
    output reg resetb,                          // RESETB signal for OV5647
    output reg pwdn                             // PWDN signal for OV5647
);

//=============================================================
    // Internal signals
    wire [23:0] command;
    wire finished;
    wire taken;
    wire waitnull;
    
    reg send;
    
    reg [31:0] cnt;
    
    reg resend;// = initial reset, high active

//=================================================================   
    // Signal for testing
    assign config_finished = finished;

//=====================================================================    
    // Signals for RESET and PWDN OV5647
//    assign resetb = 1;
//    assign pwdn = 0;

	always @ (posedge clk or negedge rstn)
    begin
    	if(!rstn)
    		cnt <= 32'd0;
    	else if(cnt == 32'hffff_ffff)
    		cnt <= cnt;
    	else
    		cnt <= cnt + 1'b1;
    end
    
    //pwdn >5ms
    always @ (posedge clk or negedge rstn)
    begin
    	if(!rstn)
    		pwdn   <= 1'b1;
    	else if(cnt >= 32'd5_000_000)//10ms
    		pwdn   <= 1'b0;
    	else
    		pwdn   <= pwdn;
    end
    
    //resetb > (5+1)ms
    always @ (posedge clk or negedge rstn)
    begin
    	if(!rstn)
    		resetb <= 1'b0;
    	else if(cnt >= 32'd6_000_000)//12ms
    		resetb <= 1'b1;
    	else
    		resetb <= resetb;
    end
    
    //resend > (5+1+20)ms
    always @ (posedge clk or negedge rstn)
    begin
    	if(!rstn)
    		resend <= 1'b1;
    	else if(cnt >= 32'd16_000_000)//32ms
    		resend <= 1'b0;
    	else
    		resend <= resend;
    end
   
//=======================================================================    
    // Signal to indicate that the configuration is finshied    
    always @ (finished) begin
        send = ~finished;
    end
    
    // Create an instance of a LUT table 
    OV5647_Registers Regs(
        .clk(clk),                          // 50Mhz clock signal
        .taken(taken),                      // Flag to advance to take next register
        .waitnull(waitnull),
        .command(command),                  // register value and data for OV5647
        .finished(finished),                // Flag to indicate the configuration is finshed
        .resend(resend)                     // Re-configure flag for OV5647
    );
    
    // Create an instance of a SCCB interface
    I2C_Interface #(
        .SID (8'h6C) 
    ) I2C (
        .resend(resend),
        .clk(clk),                          // 50Mhz clock signal
        .taken(taken),                      // Flag to advance to next register
        .siod(siod),                        // Clock signal for SCCB interface
        .sioc(sioc),                        // Data signal for SCCB interface 
        .send(send),                        // Continue to configure OV5647
        .waitnull(waitnull),
        .regah(command[23:16]),             // Register address  high 8 bit
        .regal(command[15:8]),              // Register address  low 8 bit
        .value(command[7:0])                // Data to write into register
    );
    
endmodule