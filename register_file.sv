module register_file(clk,reset,decode,write_back,rd_port_A,rd_port_B,rd_data_A,rd_data_B,wr_port_C,
										 wr_data_C,read_en_a,read_en_b,write_en_c);

reg [31:0]reg_file[31:0]; // memory logic containing 32 numbers of 32bits

input clk;
input reset;
input decode;
input write_back;

input [4:0]rd_port_A;
output reg [31:0]rd_data_A;

input [4:0]rd_port_B;
output reg [31:0]rd_data_B;

input [4:0]wr_port_C;
input [31:0]wr_data_C;

input read_en_a;
input read_en_b;
input write_en_c;

initial begin
	reg_file[1] = 32'h40;
	reg_file[2] = 32'h60;
	reg_file[4] = 32'h60;
	reg_file[5] = 32'h40;
	reg_file[7] = 32'hffff_856d;
	reg_file[8] = 32'heeee_3721;
	reg_file[10] = 32'h1fff_756f;
	reg_file[11] = 32'hffff_765e;
end

always@(negedge clk)begin
	if(reset)begin
		reg_file[wr_port_C] <= 32'b0;
	end
	else begin
		if(write_en_c)
			reg_file[wr_port_C] <= (write_back==1)?(~wr_data_C):32'h0; // write the data in 2's complement format
		else 
			reg_file[wr_port_C] <= 32'b0;
	end
end

always@(posedge clk)begin
	if(reset)begin
		rd_data_A <= 32'b0;
	end
	else begin
		if(read_en_a)begin
			rd_data_A <= (decode==1)?(reg_file[rd_port_A]):32'h0;
		end else begin
			rd_data_A <= 32'b0;
		end
	end

	if(reset)begin
		rd_data_B <= 32'b0;
	end
	else begin
		if(read_en_b)begin
			rd_data_B <= (decode==1)?(reg_file[rd_port_B]):32'h0;
		end else begin
			rd_data_B <= 32'b0;
		end
	end
end

endmodule
