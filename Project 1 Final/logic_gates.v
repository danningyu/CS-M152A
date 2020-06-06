`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:06:21 04/13/2020 
// Design Name: 
// Module Name:    logic_gates 
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
module logic_gates(
	input [4:0] sw,
	output reg result
    );

	always @(sw)
		begin
			case (sw[4:2])
				3'b000: result <= ~sw[0];
				3'b001: result <= sw[0];
				3'b010: result <= ~(sw[0] ^ sw[1]);
				3'b011: result <= sw[0] ^ sw[1];
				3'b100: result <= sw[0]| sw[1];
				3'b101: result <= ~(sw[0] | sw[1]);
				3'b110: result <= sw[0] & sw[1];
				3'b111: result <= ~(sw[0] & sw[1]);
			endcase
		end
endmodule
