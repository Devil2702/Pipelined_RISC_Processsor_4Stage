module multiplier_32x32 (execute,multiplier,multiplicand,alu_ctrl,product);

	input [31:0]multiplier;
	input [31:0]multiplicand;
	input [2:0]alu_ctrl;
	input execute;
	output reg [31:0]product;

	assign product = (alu_ctrl == 3'b1 && (execute==1))? (multiplier*multiplicand): 32'h0;	

endmodule

/*
module multiplier_tb;

	bit [31:0]a;
	bit [31:0]b;
	bit [64:0]c;
	bit [2:0]alu_ctrl;

	multiplier_32x32 I0(.multiplier(a),
										 .multiplicand(b),
										 .alu_ctrl(alu_ctrl),
									 	 .product(c)	 
										);

	initial begin
		a = 32'b0;
		b = 32'b0;
		alu_ctrl = 3'b1;

		#20ns;
		a = 32'hfffd_f0ff;
		b = 32'hffff_1000;

		#20ns;
		$finish;
	end

	initial begin
		$monitor("a=%0h b=%0h c=%0h",a,b,c);
	end

endmodule
*/
