module keyboard(
          			clk, 
						rst_n,
                  left,
                  down,
                  right,
                  up,
						ps2_data,
                  ps2_clk

);
               
input 					 clk;                // board clock frequency 50mhz
input 					 rst_n;				  // system reset signal
input					    ps2_data;
input                 ps2_clk;
output					 left;
output					 down;
output					 right;
output					 up;


reg [21:0] data_temp;
//reg [5:0]  data_cnt;
reg  left;
reg  down;
reg  right;
reg  up;         
		     
wire ps2clk_neg;
//reg ps2_clk_tmp;

reg [1:0] left_temp;
reg [1:0] right_temp;
reg [1:0] down_temp;
reg [1:0] up_temp;
wire left_neg;
wire down_neg;
wire right_neg;
wire up_neg;


/*
always @ (posedge clk or negedge rst_n)
begin
    if (!rst_n)
       ps2_clk_tmp <= 1'b0;
    else 
       ps2_clk_tmp <= ps2_clk;
end

assign ps2clk_neg = (~ps2_clk) && ps2_clk_tmp;
*/

reg [1:0] clk_temp;


always @ (posedge clk)
begin
    clk_temp <= {clk_temp[0], ps2_clk};
end

assign ps2clk_neg = (clk_temp == 2'b10);


//**************************************************************


always @ (posedge clk)
begin
    left_temp <= {left_temp[0], left};
end
assign left_neg = (left_temp == 2'b10);

always @ (posedge clk)
begin
    down_temp <= {down_temp[0], down};
end
assign down_neg = (down_temp == 2'b10);


always @ (posedge clk)
begin
    right_temp <= {right_temp[0], right};
end
assign right_neg = (right_temp == 2'b10);


always @ (posedge clk)
begin
    up_temp <= {up_temp[0], up};
end
assign up_neg = (up_temp == 2'b10);

always @ (posedge clk or negedge rst_n)
begin
    if (~rst_n)
       data_temp <= 22'd0;
	 else if (left_neg || down_neg || right_neg || up_neg)
	    data_temp <= 22'd0;
    else if (ps2clk_neg)
       data_temp <= {ps2_data, data_temp[21:1]};
end

/*
//key A
always @ (posedge clk or negedge rst_n)
begin
    if (~rst_n)
       left <= 1'd0;
    else if (data_temp == 22'b10000111000_00000000000)
		 left <= 1'b1;
    else if (data_temp == 22'b10000111000_11111100000)
		 left <= 1'b0;
end
*/
//key left

always @ (posedge clk or negedge rst_n)
begin
    if (~rst_n)
       left <= 1'd0;
    else if (data_temp == 22'b10011010110_10111000000)
		 left <= 1'b1;
    else if (data_temp == 22'b10011010110_11111100000)
		 left <= 1'b0;
end
//key down
always @ (posedge clk or negedge rst_n)
begin
    if (~rst_n)
       down <= 1'd0;
    else if (data_temp == 22'b11011100100_10111000000)
		 down <= 1'b1;
    else if (data_temp == 22'b11011100100_11111100000)
		 down <= 1'b0;
end
//key right
always @ (posedge clk or negedge rst_n)
begin
    if (~rst_n)
       right <= 1'd0;
    else if (data_temp == 22'b11011101000_10111000000)
		 right <= 1'b1;
    else if (data_temp == 22'b11011101000_11111100000)
		 right <= 1'b0;
end
//key up
always @ (posedge clk or negedge rst_n)
begin
    if (~rst_n)
       up <= 1'd0;
    else if (data_temp == 22'b10011101010_10111000000)
		 up <= 1'b1;
    else if (data_temp == 22'b10011101010_11111100000)
		 up <= 1'b0;
end

endmodule