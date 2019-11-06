`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:57 06/15/2012 
// Design Name: 
// Module Name:    hdmi 
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
module hdmi(
	sys_clk,
   Bus2IP_Reset,
   CH7301_clk_p,
   CH7301_clk_n,
   CH7301_data,
   CH7301_h_sync,
   CH7301_v_sync,
   CH7301_de,
   CH7301_scl,
   CH7301_sda,
   CH7301_rstn,
	xsvi_debug,
	
	xsvi_pix_clk,
   xsvi_h_sync,
   xsvi_v_sync,
   xsvi_video_data,
   xsvi_video_active,
	Bus2IP_Clk
    );

	input             sys_clk;
   input             Bus2IP_Reset;
   output            CH7301_clk_p;
   output            CH7301_clk_n;
   output[11:0]      CH7301_data;
   output            CH7301_h_sync;
   output            CH7301_v_sync;
   output            CH7301_de;
   output            CH7301_scl;
   output            CH7301_sda;
   output            CH7301_rstn;
	output[7:0]       xsvi_debug;
	
	input					xsvi_pix_clk;
	input					xsvi_video_data;
   input					xsvi_h_sync;
   input					xsvi_v_sync;
   input					xsvi_video_active;
	input					Bus2IP_Clk;

	wire              xsvi_h_sync;
	wire              xsvi_v_sync;
	wire[23:0]			xsvi_video_data;
	wire              xsvi_video_active;
	wire              xsvi_pix_clk;
	wire              Bus2IP_Clk;
	wire              done;
	


user_logic user_inst
(
  .xsvi_pix_clk				(xsvi_pix_clk),
  .xsvi_h_sync					(xsvi_h_sync),
  .xsvi_v_sync             (xsvi_v_sync),
  .xsvi_video_data         (xsvi_video_data),
  .xsvi_video_active			(xsvi_video_active),
  
  .CH7301_clk_p				(CH7301_clk_p),
  .CH7301_clk_n				(CH7301_clk_n),
  .CH7301_data					(CH7301_data),
  .CH7301_h_sync				(CH7301_h_sync),
  .CH7301_v_sync				(CH7301_v_sync),
  .CH7301_de					(CH7301_de),
  .CH7301_scl					(CH7301_scl),
  .CH7301_sda					(CH7301_sda),
  .CH7301_rstn					(CH7301_rstn), 
  .xsvi_debug					(xsvi_debug),
  .done							(done),
  .Bus2IP_Clk					(Bus2IP_Clk),             
  .Bus2IP_Reset				(Bus2IP_Reset)
);  

	
endmodule
