`timescale 1ns / 1ps

module RiscV_micro_tb;

//inputs 
reg clk, rst;

	RiscV_micro UUT(
	clk, rst
	);
	
initial 
begin 
	clk = 1'b0;
	rst = 1'b0;
	#6;
	
	rst = 1'b1;
	#5;
end


always 
		#5 clk = !clk; // Simulate clock.
		

endmodule