module top(
	input        clk,
	input        rx,
	input        rst,
	output [6:0] seg,
	output [2:0] ca
);

	wire       o_wr;
	reg        o_wr1 = 1;
	wire       o_wr_f;
	wire  [7:0] o_data;
	reg  [7:0] regData = 0;



	rxuart #(.baudRate(115200), .if_parity(1'b0))
		reciver (.i_clk(clk), .i_uart_rx(rx), .rst(rst), .o_wr(o_wr), .o_data(o_data));

	//detector de flanco o_wr
	always @(posedge clk) begin
		if (!rst) 
			o_wr1 <= 1;
		else
			o_wr1 <= o_wr;
	end
	
	assign o_wr_f = (o_wr & ~o_wr1);

	

	
	always @(posedge clk) begin
		if (!rst)
			regData <= 0;
		else begin
			if (o_wr_f)
				regData <= o_data; 
			else 
				regData <= regData;
		end
	end

	sevenSeg S7 (.clk(clk), .binary(regData), .seg(seg), .ca(ca));
	
endmodule
	


