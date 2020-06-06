`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:38:34 04/13/2020
// Design Name:   freq_div
// Module Name:   C:/Danning/CS M152A/Project1/freq_div_test.v
// Project Name:  Project1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: freq_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module freq_div_test;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire out;

	// Instantiate the Unit Under Test (UUT)
	freq_div uut (
		.clk(clk), 
		.rst(rst), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 1'b0;
		rst = 1'b1;
		#50100;
		rst = 1'b0;
		// Add stimulus here

	end
	
	always 
		begin
			#50000;	
			clk = ~clk;
      end
endmodule

