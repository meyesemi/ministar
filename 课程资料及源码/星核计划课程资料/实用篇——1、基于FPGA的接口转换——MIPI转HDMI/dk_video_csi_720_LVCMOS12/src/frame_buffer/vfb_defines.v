
//------------------------------------
`define	VIDEO_WIDTH_16
//`define	VIDEO_WIDTH_24
//`define	VIDEO_WIDTH_32


`ifdef VIDEO_WIDTH_16
	`define	DEF_VIDEO_WIDTH 16
`endif

`ifdef VIDEO_WIDTH_24
	`define	DEF_VIDEO_WIDTH 24
`endif 

`ifdef VIDEO_WIDTH_32
	`define	DEF_VIDEO_WIDTH 32
`endif 


//------------------------------------  
`define	DATA_WIDTH_128            //SRAM data width 128


`ifdef DATA_WIDTH_128
	`define	DEF_DATA_WIDTH 128
`endif


