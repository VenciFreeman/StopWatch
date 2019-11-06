`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:45 07/13/2015 
// Design Name: 
// Module Name:    disp_top 
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
module disp_top(
    rst_n,
	 vga_clk,
	 up,
	 down,
	 left,
	 right,
	 
	 h_sync,
	 v_sync,

	 r_data,
	 g_data,
	 b_data,
	 
	 vga_out_pixel_clock,
	 h_enable_write,
	 v_enable_write
    );
input	rst_n;
input	vga_clk;
input up;
input down;
input left;
input right;

output h_sync;
output v_sync;
output h_enable_write;
output v_enable_write;


output	[7:0]  r_data;
output	[7:0]  g_data;
output	[7:0]  b_data;  

output vga_out_pixel_clock;
	
wire [7:0]        r_data;
wire [7:0]        g_data;
wire [7:0]        b_data;
wire [10:0]       h_pixel_cnt;
wire [9:0]        v_line_cnt;

wire sw_en;
wire pause;
wire clear;

wire [2:0] time_sec_h;
wire [3:0] time_sec_l;
wire [3:0] time_msec_h;
wire [3:0] time_msec_l;
wire time_out;
wire clk_25mhz,clk_100hz;

wire vga_out_blank_z;
wire vga_comp_synch;

clk_div clk_div_inst(
				.rst_n(rst_n),
				.clk_100mhz(vga_clk),
				.clk_25mhz(clk_25mhz),
				.clk_100hz(clk_100hz)
				);

control control_inst(
				.clk_100hz(clk_100hz),
				.clk_100mhz(vga_clk),
				.rst_n(rst_n),
				.sw_en(left),
				.clear(up),
				.pause(down),
				
				.time_sec_h(time_sec_h),
				.time_sec_l(time_sec_l),
				.time_msec_h(time_msec_h),
				.time_msec_l(time_msec_l),
				.time_out(time_out)
			);


	 
vga_show i_vga_show(
	       .rst_n(rst_n) 
			,.clk(vga_clk)
			,.ms_high_disp(time_msec_h)
			,.ms_low_disp(time_msec_l)
			,.s_high_disp(time_sec_h)
			,.s_low_disp(time_sec_l)
			,.time_out(time_out)
			,.clk_25mhz(clk_25mhz)
			
         ,.h_sysc(h_sync)
         ,.v_sysc(v_sync)

			,.vga_out_blue(b_data)
			,.vga_out_red(r_data)
			,.vga_out_green(g_data)
			,.vga_out_blank_z(vga_out_blank_z)
			,.vga_comp_synch(vga_comp_synch)
			,.vga_out_pixel_clock(vga_out_pixel_clock)
			,.h_enable_write(h_enable_write)
			,.v_enable_write(v_enable_write)

          );
endmodule
