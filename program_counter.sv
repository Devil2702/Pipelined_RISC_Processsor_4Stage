module program_counter(pc_clk,reset,fetch,addr,next_addr);

	input pc_clk,reset;
	input [31:0]addr;
	input fetch;
	output reg [31:0]next_addr;

	
	always@(posedge pc_clk)
		if(reset)begin
			next_addr <= 32'h0;
		end
		else begin
			next_addr <= (fetch==1)?(addr + 32'h4):32'h0;
		end

endmodule
