/*
 * Simple memory for sixteen bit data values with 10 bits for address space.
 * Group 9
 * September 29, 2020
 *
 */
// Quartus Prime Verilog Template
// True Dual Port RAM with single clock
module data_memory
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=12)
(
	input [(DATA_WIDTH-1):0] data_a,
	input [(ADDR_WIDTH-1):0] addr_a,
	input we_a, re_a, clk,
	output reg [(DATA_WIDTH-1):0] q_a
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];
	integer i;
	initial
	begin
	//$readmemh("game.txt", ram);
		for(i=0;i<2**ADDR_WIDTH;i=i+1)
			ram[i] = 0; // Make everything a safe value, zero is what we initially will use. use a $readmemh for loading a hex file.
	end

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else if (re_a)
		begin
			q_a <= ram[addr_a];
		end 
		else
		begin
			q_a <= 32'b0;
		end
	end 



endmodule
