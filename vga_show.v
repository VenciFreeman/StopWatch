`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:36:25 02/21/2022 
// Design Name: 
// Module Name:    vga_show 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_show(
          			clk, 
						rst_n,
						ms_high_disp,
						ms_low_disp,
						s_high_disp,
						s_low_disp,
//          left,
//						right,
//						up,
//						down, 
//						run,
						time_out,
						clk_25mhz,
						h_sysc, 
						v_sysc, 
						vga_out_blue,
						vga_out_red,
						vga_out_green,
						vga_out_blank_z,
						vga_comp_synch,
						vga_out_pixel_clock,
						h_enable_write,
						v_enable_write
);
               
input 					 clk;                // board clock frequency 50mhz
input 					 rst_n;				  // system reset signal
input 	 [3:0]			 s_high_disp;
input    [3:0]			 s_low_disp;
input    [3:0]			ms_high_disp;
input    [3:0]			ms_low_disp;
input					   clk_25mhz;
//input					    up;
//input					    down;
//input					    left;
//input					    right;
//input						 run;
input 				    time_out;
output 					 h_sysc;				  // horizontal sysc signal output
output 					 v_sysc;				  // vertical sysc signal output
output 	[7:0] 		vga_out_blue;			  // output color according to current specific pixel
output 	[7:0] 		vga_out_red;
output 	[7:0] 		vga_out_green;
output          vga_out_blank_z;
output     			  vga_comp_synch;
output          vga_out_pixel_clock;
output 				h_enable_write;
output				v_enable_write;


wire 	[7:0] 		vga_out_blue;			  // output color according to current specific pixel
wire 	[7:0] 		vga_out_red;
wire 	[7:0] 		vga_out_green;
       
		     

reg [2:0] rgb_color;


	 wire						henable_write;      // horizontal enable draw signal
	 wire						venable_write;		  // vertical enable draw signal
	 wire		[9:0]			x;                  // current horizontal pos
	 wire		[9:0]			y;						  // current vertical pos



vga_ctrl vga(
				 .rst_n(rst_n),  
				 .clk_pixel(clk_25mhz),  
				 .h_sync(h_sysc),  
				 .v_sync(v_sysc),
				 .h_pixel_cnt(x),  
				 .v_line_cnt(y),				
				 .vga_sync_n(vga_comp_synch),
				 .vga_blank_n(vga_out_blank_z),
				 .h_enable_write(h_enable_write),
				 .v_enable_write(v_enable_write)
);


	 assign vga_out_blue = (rgb_color[0] == 1) ? 8'hff : 8'h00;
	 assign vga_out_green = (rgb_color[1] == 1) ? 8'hff : 8'h00;
	 assign vga_out_red = (rgb_color[2] == 1) ? 8'hff : 8'h00;
	 assign  vga_out_pixel_clock = clk_25mhz;
	 
	reg[9:0] dogX,dogY;
	wire f;
	reg[3:0]duck_final;
	reg score00,score01,score10,score11;
	 
	always @(x or y or s_high_disp or s_low_disp or ms_high_disp or ms_low_disp)
	begin
	 score00 = (x-150)>=215 && (x-150)<255 && y>=160 && y<240; //the score0_hign 
	 score01 = (x-150)>=285 && (x-150)<325 && y>=160 && y<240; //the score0_low
	 score10 = (x-150)>=355 && (x-150)<395 && y>=160 && y<240;  	 //the score1_hign
	 score11 = (x-150)>=425 && (x-150)<465 && y>=160 && y<240;	 //the score1_low
	
	case({score00,score01,score10,score11})
	4'b1000: begin
	       duck_final = s_high_disp;
			 dogX = (x-150)-215;
			  end
	4'b0100: begin
	         duck_final = s_low_disp;
	         dogX = (x-150)-285;
				end
	4'b0010: begin 
	        duck_final = ms_high_disp;
			  dogX = (x-150)-355;
			  end
	4'b0001: begin
	         duck_final = ms_low_disp;
			   dogX = (x-150)-425;
				end
	default  duck_final = -1;
	endcase
	
   dogY = y-160;
   end
	Bizarre bizarre(.x(dogX),.y(dogY),.d(duck_final),.f(f));
	
always @( posedge clk_25mhz or negedge rst_n )
	 begin
		if(!rst_n)
			begin
				rgb_color <= 3'b000;
				//vga_comp_synch <= 1'b0;
				//vga_out_blank_z <= 1'b1;
			end
		else if (((x-150)>=337 && (x-150)<343 && y>=177 && y <183) || ((x-150)>=337 && (x-150)<343 && y>=217 && y <223))
				rgb_color <= 3'b010;
		else if (f)
				rgb_color <= 3'b010;
		else if (((x-150)>120 && (x-150)<160 && y>300 && y<306) || ((x-150)>137 && (x-150)<143 && y>300 && y<340) ||
				 ((x-150)>180 && (x-150)<220 && y>300 && y<306) || ((x-150)>180 && (x-150)<220 && y>334 && y<340) || ((x-150)>197 && (x-150)<203 && y>300 && y<340) ||
				 ((x-150)>240 && (x-150)<280 && y>300 && y<306) || ((x-150)>240 && (x-150)<246 && y>300 && y<340) || ((x-150)>257 && (x-150)<263 && y>300 && y<340) || ((x-150)>274 && (x-150)<280 && y>300 && y<340) ||
				 ((x-150)>300 && (x-150)<306 && y>300 && y<340) || ((x-150)>300 && (x-150)<340 && y>300 && y<306) || ((x-150)>300 && (x-150)<340 && y>317 && y<323) || ((x-150)>300 && (x-150)<340 && y>334 && y<340) ||
				 ((x-150)>360 && (x-150)<366 && y>300 && y<340) || ((x-150)>394 && (x-150)<400 && y>300 && y<340) || ((x-150)>360 && (x-150)<400 && y>300 && y<306) || ((x-150)>360 && (x-150)<400 && y>334 && y<340) ||
				 ((x-150)>420 && (x-150)<426 && y>300 && y<340) || ((x-150)>454 && (x-150)<460 && y>300 && y<340) || ((x-150)>420 && (x-150)<460 && y>334 && y<340) ||
				 ((x-150)>480 && (x-150)<520 && y>300 && y<306) || ((x-150)>497 && (x-150)<503 && y>300 && y<340))
		begin
		    if (time_out)
				  rgb_color <= 3'b110;
			else
				  rgb_color <= 3'b000;
		 end
		 else
			 rgb_color <= 3'b000;
	 end
	 
endmodule
	 
