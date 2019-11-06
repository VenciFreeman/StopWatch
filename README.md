# stop_watch
## 功能描述 
-	秒表计时功能。当rst_n无效时，sw_en使能后，从00:00开始计时，当计时到达预设的定时时间，产生time_out高电平信号，计时继续；sw_en置低时计时停止，当前时间保持不变； 
- Pause信号有效时，当前显示时间不变，但计时仍继续。当pause信号无效后，恢复计时，显示当前计时时间。
- Clear信号有效时，计时清零。
- 计时到达59’99时，从零重新计时并且将time_out信号置为无效； 
- 输出当前计时的秒数，精度为0.01秒（显示毫秒数的百位和个位）； 
- 全局rst_n信号（低电平有效）发生时，秒表清零，计时停止，并且将之前的time_out信号置低。
>使用Virtex-5 XC5VLX50T开发板，通过PS2外接键盘控制，通过HDMI接口外接屏幕来直观的显示和验证上述设计功能的正确性。 
## 验证要求 
- FPGA输入时钟为100MHZ晶振，分频为100HZ（时间精度是0.01 second）; 
- 用拨码开关作为rst_n信号；
- 使用一个按键←作为计时使能信号，模拟sw_en的功能；按一次开始计时，第二次，停止，以此类推；
- 使用一个按键↓作为暂停信号，模拟pause功能；计时过程中，按一次屏幕暂停计时，但stopwatch内核仍在计时，第二次，屏幕恢复计时，以此类推；
- 使用一个键盘键↑作为StopWatch的清零信号，按一次对计时清零；
- 当前计时时间显示外接屏幕上，共四个数字，前两个数显示秒数，后两个数显示毫秒数，并且显示秒数与毫秒数之间的小数点。屏幕的显示为一个扫描时钟，频率为25MHz，需要从100MHz的系统时钟分频得到。 
- 同时输出一个time_out信号，有效时屏幕出现“TIMEOUT”字样。
