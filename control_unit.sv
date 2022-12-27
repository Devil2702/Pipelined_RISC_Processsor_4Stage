module control_unit(clk,reset,instr_fetch,decode,execute,write_back);
	input clk;
	input reset;

	output reg instr_fetch;
	output reg decode;
	output reg execute;
	output reg write_back;

	parameter IDLE = 0;
	parameter INSTRUCTION_FETCH = 1;
	parameter DECODE = 2;
	parameter EXECUTE = 3;
	parameter WRITE_BACK = 4;

	reg [2:0] current_state;
	reg [2:0] next_state;

	initial begin
		instr_fetch = 1'b0;
		decode = 1'b0;
		execute = 1'b0;
		write_back = 1'b0;
		current_state = 0;
	end

	always@(posedge clk)begin
		if(reset)begin
			current_state = IDLE;
		end
		else begin
			current_state = next_state;
		end
	end

	always@(posedge clk)begin
		case(current_state)
			IDLE:begin
						next_state = 1;
						instr_fetch = 1;
					 end
			INSTRUCTION_FETCH:begin
													next_state = 2;
													decode = 1;
												end
			DECODE: begin
								next_state = 3;
								execute = 1;
							end
			EXECUTE: begin
								next_state = 4;
								write_back = 1;
							end
			default: begin
								next_state = 0;
							end
		endcase
	end

endmodule

/*
module tb_fsm;

	logic clk;
	logic reset;
	logic fetch,decode,execute,write_back;

	initial begin
		clk = 0;
		reset = 1;
		repeat(5)@(posedge clk);
		reset = 0;
	end

	initial begin
		forever #2 clk = ~clk;
	end

	control_unit cu_i0(.clk(clk),
										 .reset(reset),
										 .instr_fetch(fetch),
										 .decode(decode),
										 .execute(execute),
										 .write_back(write_back)
									  );
	
  initial begin
		#200ns;
		$finish;
	end

endmodule
*/
