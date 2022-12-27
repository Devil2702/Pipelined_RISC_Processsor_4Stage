`include "barrel_shifter.sv"
`include "32x32_multiplier.sv"

module alu(A,B,execute,alu_ctrl,result);
	
	input [31:0]A;
	input [31:0]B;
	input [2:0] alu_ctrl; // 3bit control features supported - MUL, SHIFT, XOR, NOR
	input execute;
	output reg [31:0]result;
	wire [31:0]mul_out;
	wire [31:0]shift_out;
	wire [31:0]xor_out;
	wire [31:0]nor_out;

	// multiplier
	multiplier_32x32 multiplier_i(.multiplier(A),
																.multiplicand(B),
																.alu_ctrl(alu_ctrl),
																.execute(execute),
																.product(mul_out)
															 );

	// barrel_shifter
	barrel_shifter barrel_shifter_i(.input_A(A[4:0]),
																	.input_B(B[31:0]),
																	.cntr(alu_ctrl[0]),
																	.opr(alu_ctrl[1]),
																	.execute(execute),
																	.out(shift_out)
																 );
	//NOR
	nor_gate nor_i(.a(A),.b(B),.execute(execute),.alu_ctrl(alu_ctrl),.c(nor_out));	
	//XOR
	xor_gate xor_i(.a(A),.b(B),.execute(execute),.alu_ctrl(alu_ctrl),.c(xor_out));	

	mux_4x1 mux4_i0(.mux4_in_a(mul_out), .mux4_in_b(shift_out), .mux4_in_c(xor_out), .mux4_in_d(nor_out), .sel(alu_ctrl[2:0]),
									.mux4_out(result));
endmodule

module nor_gate(a,b,execute,alu_ctrl,c);
	input [31:0]a;
	input [31:0]b;
	input execute;
	input [2:0]alu_ctrl;
	output [31:0]c;

	assign c = (alu_ctrl == 3'b100 && (execute==1))? (~(a | b)): 32'h0;
endmodule

module xor_gate(a,b,execute,alu_ctrl,c);
	input [31:0]a;
	input [31:0]b;
	input execute;
	input [2:0]alu_ctrl;
	output [31:0]c;

	assign c = (alu_ctrl == 3'b011 &&(execute==1))? (a^b): 32'h0;
endmodule

module mux_4x1(mux4_in_a,mux4_in_b,mux4_in_c,mux4_in_d,sel,mux4_out);
	input [31:0] mux4_in_a;
	input [31:0] mux4_in_b;
	input [31:0] mux4_in_c;
	input [31:0] mux4_in_d;
	input [2:0] sel;
	output reg [31:0] mux4_out;

	always@(mux4_in_a,mux4_in_b,mux4_in_c,mux4_in_d)begin
		case(sel)
			3'b001:mux4_out = mux4_in_a;
			3'b010:mux4_out = mux4_in_b;
			3'b011:mux4_out = mux4_in_c;
			3'b100:mux4_out = mux4_in_d;
			default:mux4_out = 32'h0;
		endcase
	end
endmodule

/*
module top;

	logic [31:0]a;
	logic [31:0]b;
	logic [2:0]alu_ctrl;
	logic [64:0]result;

	alu alu_i(.A(a),
						.B(b),
						.alu_ctrl(alu_ctrl),
						.result(result)
					 );

	initial begin
		a = 32'h0;
		b = 32'h0;
		alu_ctrl = 3'b0;
		
		//MUL
		#20ns;
		alu_ctrl = 3'b001;
		a = 32'hffff_1234;
		b = 32'hdead_beef;

		//SHIFT
		#20ns;
		alu_ctrl = 3'b010;
		a = 32'hffff_1234;
		b = 32'hdead_beef;

		//XOR
		#20ns;
		alu_ctrl = 3'b011;
		a = 32'hffff_1234;
		b = 32'hdead_beef;

		//NOR
		#20ns;
		alu_ctrl = 3'b100;
		a = 32'hffff_1234;
		b = 32'hdead_beef;

		#20ns;
		$finish;
	end

	initial begin
		$monitor("A --- %0h",a);
		$monitor("B --- %0h",b);
		$monitor("alu_ctrl --- %0b",alu_ctrl);
		$monitor("result --- %0h",result);
	end

endmodule
*/
