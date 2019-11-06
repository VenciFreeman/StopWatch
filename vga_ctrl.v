//////////////////////////////////////////////////////////////////////////////////
// Company: SOME SJTU
// Engineer: 	
// 
// Create Date:    16:41:21 05/07/2011 
// Design Name: 
// Module Name:    vga_ctrl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: This file was first created by taoyuliang for spartan
// 3 platform and revised in 2011 by jiang. 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 -
// Additional Comments: 
//
///////////////////////////////////////////////////////////////////////////////////
module vga_ctrl(
				 rst_n  
				,clk_pixel  
				,h_sync  
				,v_sync 
				,h_pixel_cnt  
				,v_line_cnt				
            ,vga_sync_n
            ,vga_blank_n
				,h_enable_write
				,v_enable_write
			 );
			 
    input 					rst_n;            // system reset signal, asserted by low 
    input 					clk_pixel;        // 25mhz pixel clock
    output 					h_sync;           // horizontal sync signal
    output 					v_sync;           // vertical sync signal

    output 	[9:0] 		h_pixel_cnt;    // current pixel count of horizontal pixel
    output 	[9:0] 		v_line_cnt;	// current line count of vertical pixel
    output			vga_sync_n;
    output			vga_blank_n;
	 output	h_enable_write;
    output	v_enable_write;


    reg			        vga_sync_n;
    reg			        vga_blank_n;
	 
    reg 			h_sync;
    reg 			v_sync;
    reg		[9:0]		h_pixel_cnt;
    reg 	[9:0] 		v_line_cnt;
    reg	h_enable_write;
    reg	v_enable_write;
	 
	 parameter H_PIXELS = 800;
	 parameter V_LINES  = 525;
	 parameter H_ACTIVE_REGION = 640;
	 parameter V_ACTIVE_REGION = 480;
	 parameter H_FRONT_PORCH = 16;
	 parameter H_BACK_PORCH  = 48;
	 parameter H_SYNC_PERIOD = 96;
	 parameter V_FRONT_PORCH = 10;
	 parameter V_BACK_PORCH  = 23;
	 parameter V_SYNC_PERIOD = 2;
	 
/////////////////////////////////////////////////////////////////////////////////////////
//
//
/////////////////////////////////////////////////////////////////////////////////////////

always @(posedge clk_pixel or negedge rst_n)
if(!rst_n)
begin	
	vga_sync_n <=1'b0;
	vga_blank_n<=1'b1;
end
else
begin	
	vga_sync_n <=vga_sync_n;
	vga_blank_n<=vga_blank_n;
end


	 
	 /////////////////////////////////////////////////////////////////////////////////
	 //                                                                             //
	 // Generate the current horizontal pixel count and vertical line count.        //
	 //                                                                             //        
	 /////////////////////////////////////////////////////////////////////////////////
	 always @ ( posedge clk_pixel or negedge rst_n )
	 if(!rst_n)
	 	h_pixel_cnt <= 0;
	
	 else if(h_pixel_cnt==H_PIXELS - 1)

		h_pixel_cnt<=10'b0;
	 else 
		h_pixel_cnt<=h_pixel_cnt+1'b1;

	
	 always @ ( posedge clk_pixel or negedge rst_n )
	 if(!rst_n)
	 	v_line_cnt <= 0;
	
	 else if((v_line_cnt==V_LINES - 1) && (h_pixel_cnt==H_PIXELS - 1))

		v_line_cnt<=10'b0;
	
	 else if(h_pixel_cnt==H_PIXELS - 1)
		 
		v_line_cnt<=v_line_cnt+1'b1;
	 else
		v_line_cnt<=v_line_cnt;

	
	 /////////////////////////////////////////////////////////////////////////////////
	 //                                                                             //
	 // generate the horizontal sync pulse signal and vertical sync pulse signal.   //
	 // the sync signal is active by 0                                              //
	 //                                                                             //
	 /////////////////////////////////////////////////////////////////////////////////
	 always @ ( posedge clk_pixel or negedge rst_n )
	 if(!rst_n)
	 	h_sync <= 1'b1;
	
	 else if(h_pixel_cnt==H_FRONT_PORCH - 1)
		
		h_sync<=1'b0;

	 else if(h_pixel_cnt==H_FRONT_PORCH +  H_SYNC_PERIOD - 1)

		h_sync<=1'b1;
	else
		h_sync<=h_sync;

	 
	 always @ ( posedge clk_pixel or negedge rst_n )
	 if(!rst_n)
	 	v_sync <= 1'b1;
	
	 else if(v_line_cnt==V_FRONT_PORCH - 1)
		
		v_sync<=1'b0;

	 else if(v_line_cnt==V_FRONT_PORCH +  V_SYNC_PERIOD - 1)

		v_sync<=1'b1;
	else
		v_sync<=v_sync;

	 /////////////////////////////////////////////////////////////////////////////////
	 //                                                                             //
	 // generate the enable signal to write into rgb                               //
	 //                                                                             //
	 /////////////////////////////////////////////////////////////////////////////////
	 always @ ( posedge clk_pixel or negedge rst_n )
	 if(!rst_n)
	 	h_enable_write <= 0;
	
	 else if(h_pixel_cnt==H_FRONT_PORCH + H_SYNC_PERIOD + H_BACK_PORCH - 1)
		 
		h_enable_write <=1'b1;
	
	 else if(h_pixel_cnt == H_PIXELS - 1)

		h_enable_write <=1'b0;


	 always @ ( posedge clk_pixel or negedge rst_n )
	 if(!rst_n)
	 	v_enable_write <= 0;
	
	 else if(v_line_cnt==V_FRONT_PORCH + V_SYNC_PERIOD + V_BACK_PORCH - 1)
		 
		v_enable_write <=1'b1;
	
	 else if(v_line_cnt == V_LINES - 1)

		v_enable_write <=1'b0;

endmodule
