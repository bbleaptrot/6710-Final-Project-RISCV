/*
 * Simple memory for sixteen bit data values with 10 bits for address space.
 * Group 9
 * September 29, 2020
 *
 */

module instruction_memory
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=12)
(
	input [(ADDR_WIDTH-1):0] program_counter,
	input clk,
	output reg [(DATA_WIDTH-1):0] q_a
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];
	integer i;
	initial
	begin
	$readmemb("code.txt", ram);
		//for(i=0;i<2**ADDR_WIDTH;i=i+1)
			//ram[i] = 0; // Make everything a safe value, zero is what we initially will use. use a $readmemh for loading a hex file.
	end

	// Port A 
	always @ (posedge clk)
	begin
		q_a <= ram[program_counter];
	end 
	

endmodule
