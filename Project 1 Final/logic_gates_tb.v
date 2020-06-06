`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:15:44 04/13/2020
// Design Name:   logic_gates
// Module Name:   C:/Danning/CS M152A/Project1/logic_gates_tb.v
// Project Name:  Project1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: logic_gates
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module logic_gates_tb;

	// Inputs
	reg [4:0] sw;

	// Outputs
	wire result;

	// Instantiate the Unit Under Test (UUT)
	logic_gates uut (
		.sw(sw), 
		.result(result)
	);

	initial begin
		// Initialize sw to 0
		sw[4:0] = 5'b0;
		#100;	
	end
	
	always
		begin
			#10;
			sw[4:0] = sw[4:0]+5'b1;
		end
      
endmodule

