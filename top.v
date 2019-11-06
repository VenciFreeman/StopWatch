`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:46 12/12/2016 
// Design Name: 
// Module Name:    top 
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
module top(
		sys_clk,
		sys_rst,

		ps2_clk,
		ps2_data,
		CH7301_clk_p,
		CH7301_clk_n,
		CH7301_data,
		CH7301_h_sync,
		CH7301_v_sync,
		CH7301_de,
		CH7301_scl,
		CH7301_sda,
		CH7301_rstn,

		xsvi_debug
		
		);
		


input sys_clk;
input sys_rst;



input ps2_clk;
input ps2_data;
	
output            CH7301_clk_p;
output            CH7301_clk_n;
output	[11:0]   CH7301_data;
output            CH7301_h_sync;
output            CH7301_v_sync;
output            CH7301_de;
output            CH7301_scl;
output            CH7301_sda;
output            CH7301_rstn;
output	[7:0]    xsvi_debug;






wire h_sync;
wire v_sync;
//wire h_en;
//wire v_en;
wire sw_en;
wire sw_en_inv;
assign sw_en=~sw_en_inv;

wire	[7:0]  r_data;
wire	[7:0]  g_data;
wire	[7:0]  b_data;  

wire vga_out_pixel_clock;
wire [23:0] xsvi_video_data = {r_data,g_data,b_data};

wire h_enable_write;
wire v_enable_write;
wire xsvi_video_active = h_enable_write & v_enable_write;

wire up, down, right, left;





reg Bus2IP_Clk;
always @(posedge sys_clk)
			Bus2IP_Clk <= ~Bus2IP_Clk;
	
keyboard keyboard_1(
							.clk(sys_clk), 
							.rst_n(~sys_rst),
							.ps2_data(ps2_data),
							.ps2_clk(ps2_clk),
							.left(left),
							.down(down),
							.right(right),
							.up(up)						
);

	

disp_top disp_top_1(
							.rst_n(~sys_rst),
							.vga_clk(sys_clk),
							.up(up),
							.down(down),
							.left(left),
							.right(right),
							.h_sync(h_sync),
							.v_sync(v_sync),
							//.h_en(h_enable_write),
							//.v_en(v_enable_write),
							.r_data(r_data),
							.g_data(g_data),
							.b_data(b_data),
							.vga_out_pixel_clock(vga_out_pixel_clock),
							.h_enable_write(h_enable_write),
							.v_enable_write(v_enable_write)
							);

hdmi hdmi_1(
							.sys_clk(sys_clk),
							.Bus2IP_Reset(sys_rst),
							.xsvi_pix_clk(vga_out_pixel_clock),
							.xsvi_h_sync(h_sync),
							.xsvi_v_sync(v_sync),
							.xsvi_video_data(xsvi_video_data),
							.xsvi_video_active(xsvi_video_active),
							.Bus2IP_Clk(Bus2IP_Clk),
							
							.CH7301_clk_p(CH7301_clk_p),
							.CH7301_clk_n(CH7301_clk_n),
							.CH7301_data(CH7301_data),
							.CH7301_h_sync(CH7301_h_sync),
							.CH7301_v_sync(CH7301_v_sync),
							.CH7301_de(CH7301_de),
							.CH7301_scl(CH7301_scl),
							.CH7301_sda(CH7301_sda),
							.CH7301_rstn(CH7301_rstn),
							.xsvi_debug(xsvi_debug)
							
							);




endmodule
