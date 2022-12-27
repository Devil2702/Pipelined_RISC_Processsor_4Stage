module cpu_processor(clk,reset);

	input clk;
	input reset;

	reg [2:0]alu_ctrl;
	reg [31:0]pc_addr;
	wire [31:0]instruction;
	wire [31:0]source_data_1;
	wire [31:0]source_data_2;
	wire [31:0]data_write;
	wire fetch,decode,execute,write_back;

	reg [31:0]next_addr;

	assign next_addr = pc_addr;

	always@(posedge clk)begin
		if(reset)
			alu_ctrl <= 0;
		else
			alu_ctrl <= instruction[17:15];
	end

	control_unit cu_i0(.clk(clk),
										 .reset(reset),
										 .instr_fetch(fetch),
										 .decode(decode),
										 .execute(execute),
										 .write_back(write_back)
										);
	
	program_counter pc_i0(.pc_clk(clk),
												.reset(reset),
												.addr(next_addr),
												.fetch(fetch),
												.next_addr(pc_addr)
											 );

	instruction_memory imem_i0(.clk(clk),
														 .reset(reset),
														 .rd_en(1'h1),
														 .rd_addr(pc_addr),
														 .fetch(fetch),
														 .instr(instruction)
													  );

  register_file reg_file_i0(.clk(clk),
														.reset(reset),
														.decode(decode),
														.write_back(write_back),
														.rd_port_A(instruction[4:0]),
														.rd_port_B(instruction[9:5]),
														.rd_data_A(source_data_2),
														.rd_data_B(source_data_1),
														.wr_port_C(instruction[14:10]),
														.wr_data_C(data_write),
														.read_en_a(1'b1),
														.read_en_b(1'b1),
														.write_en_c(1'b1)
													 );

	alu alu_i0(.A(source_data_2),
						 .B(source_data_1),
						 .execute(execute),
						 .alu_ctrl(alu_ctrl),
						 .result(data_write)
					  );
endmodule
