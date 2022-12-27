`timescale 1ns/1ps
`include "cpu_processor.sv"
`include "control_unit.sv"
`include "program_counter.sv"
`include "instruction_memory.sv"
`include "register_file.sv"
`include "alu.sv"

module tb_top;
	
	logic clk;
	logic reset;

	initial begin
		clk = 0;
		reset = 1'b1;
		#2ns;
		reset = 1'b0;
	end

	initial begin
		forever #2 clk = ~clk;
	end

	cpu_processor processor_i0(.clk(clk),
														 .reset(reset)
													  );

	initial begin
		#500ns;
		$finish;
	end
endmodule
