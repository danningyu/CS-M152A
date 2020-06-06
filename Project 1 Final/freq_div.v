`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:29:54 04/13/2020 
// Design Name: 
// Module Name:    freq_div 
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
module freq_div(
		input clk,
		input rst,
		output reg out
    );
	
	reg [13:0] value; //14 bits b/c 9999 = 14'b10011100001111
	
	always @(posedge clk) 
		begin
			if(rst)
				value <= 14'd0;
			else if(value == 14'd9999)
				value <= 14'd0;
			else
				value <= value + 14'd1;
		end
	
	always @(posedge clk)
		begin
			if(rst)
				out <= 1'b0;
			else if(value == 14'd9999)
				out <= 1'b1;
			else if(value == 14'd4999)
				out <= 1'b0;
		end

endmodule
