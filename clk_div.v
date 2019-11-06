// Company:        Shanghai Jiao Tong University
// Engineer:       Venci Freeman
// 
// Create Date:    20:36:25 12/19/2018
// Design Name: 
// Module Name:    clk_div 
// Project Name:   stopwatch
// Target Devices: FPGA
// Tool versions:  0.1
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_div(rst_n, clk_100mhz, clk_25mhz, clk_100hz);
  input rst_n, clk_100mhz;
  output clk_25mhz, clk_100hz;
  
  parameter DIV_CNT_100Hz =  19'b1111010000100011111; // Decimal: 499,999
  
  reg clk_25mhz, clk_100hz;
  reg cnt_25mhz;  
  reg[18:0] cnt_100hz;

/////////////////////////////////////////////////////////////////////////////////////////
//
// The always part controls signal cnt_25mhz.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100mhz or negedge rst_n)
  if(!rst_n)
    cnt_25mhz <= 1'b0;
  else if(cnt_25mhz == 1'b1)
    cnt_25mhz <= 1'b0;
  else
    cnt_25mhz <= cnt_25mhz + 1'b1;

/////////////////////////////////////////////////////////////////////////////////////////
//
// The always part controls signal clk_25mhz.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100mhz or negedge rst_n)
  if(!rst_n)
    clk_25mhz <= 0;
  else if(cnt_25mhz == 1'b1)
    clk_25mhz <= !clk_25mhz;
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// The always part controls signal cnt_100hz.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100mhz or negedge rst_n) 
  if(!rst_n)
    cnt_100hz <= 19'b0;
  else if(cnt_100hz == DIV_CNT_100Hz)
    cnt_100hz <= 19'b0;
  else
    cnt_100hz <= cnt_100hz + 1'b1;

/////////////////////////////////////////////////////////////////////////////////////////
//
// The always part controls signal clk_100hz.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100mhz or negedge rst_n)
  if(!rst_n)
    clk_100hz <= 0;
  else if(cnt_100hz == DIV_CNT_100Hz)
    clk_100hz <= !clk_100hz;

endmodule