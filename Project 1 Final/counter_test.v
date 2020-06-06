`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:09:41 04/13/2020
// Design Name:   counter_gates
// Module Name:   C:/Danning/CS M152A/Project1/counter_test.v
// Project Name:  Project1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter_gates
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module counter_test;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire out0;
	wire out1;
	wire out2;
	wire out3;
	
	wire [3:0] out_v;

	// Instantiate the Unit Under Test (UUT)
	counter_gates uut (
		.clk(clk), 
		.rst(rst), 
		.out0(out0),
		.out1(out1),
		.out2(out2),
		.out3(out3)
	);
	
	counter_arith uut2 (
		.clk(clk), 
		.rst(rst), 
		.out(out_v)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;	
		#100;
		rst = 0;
	end
	
	always
		begin		
			clk = ~clk;
			#10;
		end
endmodule

