`timescale 10ns/1ns

module top_test_bench();

	localparam clk_frequency = 25e6; //25 MHz
	parameter baudRate = 9600;
	localparam [15:0] clocksPerBaud = clk_frequency/baudRate;

	reg clk;           //in
	reg rst;           //in
	reg uart_tx = 1;   //in 
	wire o_wr;         //out
	wire [7:0] o_data; //out
	
	//local signals
	reg baudClock;

	//simulation signals
	reg [7:0] randomValue;

	//initial vulues
	initial 
	begin
		clk = 0;
		rst = 1;
		uart_tx = 1;
		baudClock= 0;	
		#120000 rst = 0;
		#8 rst = 1; 
		
	end


	//clock
	always #2 clk = ~clk;


	always
	begin
		repeat (clocksPerBaud)
			@(posedge clk);

		baudClock = 1;
		#4 baudClock = 0;
	end
		
		  
	//task that generates Tx signal from a 8bits data.
	task tx_generate;
		input [7:0] data;
		integer i;

	begin
		@ (posedge baudClock);
			uart_tx = 0; 
		@ (negedge baudClock);
		for (i = 0; i < 8; i = i + 1) begin
			wait (baudClock == 1);
			uart_tx = data[i];
			wait (baudClock == 0);
		end
		wait (baudClock == 1);
		uart_tx = 1;
		wait (baudClock == 0);
	end
	endtask
	

	/*rxuart #(.baudRate(baudRate), .if_parity(1'b0))
		rx1 (.i_uart_rx(uart_tx), .rst(1'b1), .i_clk(clk), .o_wr(o_wr), .o_data(o_data));*/

	top top1 (.clk(clk), .rx(uart_tx), .rst(rst));
			
	always
	begin 
	#100 uart_tx = 1;
	
		while (1 == 1) begin
			randomValue = $random;
			tx_generate(randomValue); 
		end
	end

endmodule
	
