`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:57:52 04/15/2020 
// Design Name: 
// Module Name:    counter_arith 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module counter_arith(
	input clk,
	input rst,
	output reg [3:0] out
	);
	
	always @(posedge clk)
		begin
			if(rst)
				out <= 4'b0;
			else
				out <= out + 1'b1;
		end
endmodule


