module instruction_memory(clk,reset,fetch,instr,rd_addr,rd_en);

input clk,reset;
input [31:0]rd_addr;
input rd_en;
input fetch;
output reg [31:0]instr;

reg [7:0]memory[127:0];

initial begin
	$readmemh("instruction.txt",memory);
end

always@(posedge clk)begin
	if(reset)begin
		instr <= 0 ;
	end
	else begin
		if(rd_en)begin
				instr <= (fetch == 1)?({memory[rd_addr+32'h3],memory[rd_addr+32'h2],memory[rd_addr+32'h1],memory[rd_addr]}): 32'b0;
		end
		else begin
			instr <= 32'h0;
		end
	end
end
	
endmodule

/*
00008c41
000118a4
0001a507
0002356a
*/
