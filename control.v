//////////////////////////////////////////////////////////////////////////////////
// Company:        Shanghai Jiao Tong University
// Engineer:       Venci Freeman
// 
// Create Date:    20:36:25 12/19/2018
// Design Name: 
// Module Name:    control 
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
module control(clk_100mhz,  // vga_clk
               clk_100hz,
               rst_n, 
               sw_en, // left
               pause, // down
               clear, // up
               time_sec_h, 
               time_sec_l,
               time_msec_h, 
               time_msec_l, 
               time_out
               );
  
  input clk_100mhz, clk_100hz, rst_n;
  input sw_en, pause, clear;
  output[2:0] time_sec_h;
  output[3:0] time_sec_l;
  output[3:0] time_msec_h;
  output[3:0] time_msec_l;
  output time_out;
  
  //reg sw_en_wave, pause_wave, clear_wave;
  //reg clk_100hz_d;
  reg time_out;
  
  reg[2:0] time_sec_h;
  reg[3:0] time_sec_l;
  reg[3:0] time_msec_h;
  reg[3:0] time_msec_l;
  
  reg[2:0] calc_time_sec_h;
  reg[3:0] calc_time_sec_l;
  reg[3:0] calc_time_msec_h;
  reg[3:0] calc_time_msec_l;

/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the calc_time_msec_l.
//
/////////////////////////////////////////////////////////////////////////////////////////    
always @(posedge clk_100hz or negedge rst_n)  
  if(!rst_n)
    calc_time_msec_l <= 4'b0;
  else if(clear)
    calc_time_msec_l <= 4'b0;
  else if(calc_time_msec_l == 4'b1001)
    calc_time_msec_l <= 4'b0;
  else if(sw_en == 1)
    calc_time_msec_l <= calc_time_msec_l + 1;


/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the calc_time_msec_h.
//
/////////////////////////////////////////////////////////////////////////////////////////   
always @(posedge clk_100hz or negedge rst_n)
  if(!rst_n)
      calc_time_msec_h <= 4'b0;
  else if(clear)
    calc_time_msec_h <= 4'b0;
  else 
    begin
      if(calc_time_msec_l == 4'b1001 
       && calc_time_msec_h == 4'b1001
         )
        calc_time_msec_h <= 4'b0; 
      else if(calc_time_msec_l == 4'b1001)
        calc_time_msec_h <= calc_time_msec_h + 1; 
    end
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the calc_time_sec_l.
//
/////////////////////////////////////////////////////////////////////////////////////////    
always @(posedge clk_100hz or negedge rst_n)
  if(!rst_n)
    calc_time_sec_l <= 4'b0;
  else if(clear)
    calc_time_sec_l <= 4'b0;
  else
    begin
      if(calc_time_msec_l == 4'b1001 
      && calc_time_msec_h == 4'b1001 
      && calc_time_sec_l == 4'b1001
         )
        calc_time_sec_l <= 4'b0;  
      else if(calc_time_msec_l == 4'b1001 
       && calc_time_msec_h == 4'b1001
         )
        calc_time_sec_l <= calc_time_sec_l + 1; 
    end
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the calc_time_sec_h.
//
/////////////////////////////////////////////////////////////////////////////////////////    
always @(posedge clk_100hz or negedge rst_n) 
  if(!rst_n)
    calc_time_sec_h <= 3'b0;
  else if(clear)
    calc_time_sec_h <= 4'b0;
  else
    begin
      if(calc_time_msec_l == 4'b1001
       && calc_time_msec_h == 4'b1001
       && calc_time_sec_l == 4'b1001 
       && calc_time_sec_h == 3'b101
         )
        calc_time_sec_h <= 3'b0;
      else if(calc_time_msec_l == 4'b1001 
       && calc_time_msec_h == 4'b1001 
       && calc_time_sec_l == 4'b1001
         )
         calc_time_sec_h <= calc_time_sec_h + 1; 
    end
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the time_out.
//
/////////////////////////////////////////////////////////////////////////////////////////    
always @(posedge clk_100hz or negedge rst_n) 
  if(!rst_n)
    time_out <= 0;
  else if(clear)
    time_out <= 4'b0;
  else if(calc_time_msec_l == 4'b0111
        && calc_time_msec_h == 4'b0101
        && calc_time_sec_l == 4'b1001
        && calc_time_sec_h == 3'b000  // Preset time
          )
    time_out <= 1;
  else if(calc_time_msec_l == 4'b0
        && calc_time_msec_h == 4'b0
        && calc_time_sec_l == 4'b0 
        && calc_time_sec_h == 3'b0
          )
    time_out <= 0;

/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the time_msec_l.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100hz or negedge rst_n)
  if(!rst_n)
    time_msec_l <= 0;
  else if(clear)
    time_msec_l <= 0;
  else if(!pause)
    time_msec_l <= calc_time_msec_l;
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the time_msec_h.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100hz or negedge rst_n)
  if(!rst_n)
    time_msec_h <= 0;
  else if(clear)
    time_msec_h <= 0;
  else if(!pause)
    time_msec_h <= calc_time_msec_h;
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the time_sec_l.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100hz or negedge rst_n)
  if(!rst_n)
    time_sec_l <= 0;
  else if(clear)
    time_sec_l <= 0;
  else if(!pause)
    time_sec_l <= calc_time_sec_l;
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Control the time_sec_h.
//
/////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_100hz or negedge rst_n)
  if(!rst_n)
    time_sec_h <= 0;
  else if(clear)
    time_sec_h <= 0;
  else if(!pause)
    time_sec_h <= calc_time_sec_h;
    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Extract the signal of clk_100hz_d. (clock delay)
//
///////////////////////////////////////////////////////////////////////////////////////// 
//always @(posedge clk_100hz or negedge rst_n)
//if(!rst_n)
     //clk_100hz_d <= 0;
//else
    //clk_100hz_d <= clk_100hz;

/////////////////////////////////////////////////////////////////////////////////////////
//
// Extract the signal of pause.
//
///////////////////////////////////////////////////////////////////////////////////////// 
//always @(posedge clk_100hz or negedge rst_n)
  //if(!rst_n)
    //pause_wave <= 0;
  //else if(clear_wave)
    //pause_wave <= 0;
  //else if(pause & clk_100hz & (!clk_100hz_d))
    //pause_wave <= ~pause_wave;

/////////////////////////////////////////////////////////////////////////////////////////
//
// Extract the signal of clear.
//
///////////////////////////////////////////////////////////////////////////////////////// 
//always @(posedge clk_100hz or negedge rst_n)
  //if(!rst_n)
    //clear_wave <= 0;
  //else if(clear & clk_100hz & (!clk_100hz_d))
    //clear_wave <= ~clear_wave;

    
/////////////////////////////////////////////////////////////////////////////////////////
//
// Extract the signal of sw_en.
//
/////////////////////////////////////////////////////////////////////////////////////////    
//always @(posedge clk_100hz or negedge rst_n)
  //if(!rst_n)
    //sw_en_wave <= 0;
  //else if(clear_wave)
    //sw_en_wave <= 0;
  //else if(sw_en & clk_100hz & (!clk_100hz_d))
    //sw_en_wave <= ~sw_en_wave;

endmodule