`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:23:57 04/13/2020 
// Design Name: 
// Module Name:    counter_gates 
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
module counter_gates(
	input clk,
	input rst,
	output reg out0,
	output reg out1,
	output reg out2,
	output reg out3
    );
		
	always @(posedge clk)
		begin
			if(rst)
				begin
				out0 <= 1'b0;
				out1 <= 1'b0;
				out2 <= 1'b0;
				out3 <= 1'b0;
				
				end
			else
				begin
					out0 <= ~out0;
					out1 <= out0^out1;
					out2 <= (out0&out1)^out2;
					out3 <= ((out0&out1)&out2)^out3;
				end
		end

endmodule
