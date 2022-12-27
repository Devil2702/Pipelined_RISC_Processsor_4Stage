/*Barrel Shifter - based on the cntr,opr bits input_B is shifted by input_A
	times. 
*/
module barrel_shifter(input_A,input_B,execute,cntr,opr,out);

	input [4:0] input_A; // 5bits 2**5 = 32 combinations all 32bit of input can be shifted
	input [31:0]input_B;
	input execute;
	input cntr;
	input opr;
	output reg [31:0]out;

	always@(*)begin
		//alu[2],alu[3]
		case({opr,cntr})
			//left, logical
			2'b10: out = (execute==1)? (input_B << input_A):32'h0;

			//default
			default: out = 32'b0;
		endcase
	end
	
endmodule
