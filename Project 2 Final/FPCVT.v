`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:05:19 04/20/2020 
// Design Name: 
// Module Name:    FPCVT 
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
module FPCVT(
	input [12:0] D,
	output S,
	output [2:0] E,
	output [4:0] F
    );
    
	wire [12:0] magnitude;
     
	wire [2:0] unroundedPower;

    wire [4:0] unroundedF;
    wire sixthBit;
    
    wire [2:0] roundedPower;
    wire [4:0] roundedF;
    
    wire detected4096; 
    
    assign S = (D[12] == 1'b0) ? 1'b0 : 1'b1;
    
	getMagnitude magnitudeModule(.D(D), .magnitude(magnitude));	
    countZeroes countZeroesModule(.magnitude(magnitude), .unroundedPower(unroundedPower));  
	
    getMantissa mantissaModule(.magnitude(magnitude), .unroundedPower(unroundedPower), .unroundedF(unroundedF));   
    getSixthBit sixthBitModule(.magnitude(magnitude), .unroundedPower(unroundedPower), .sixthBit(sixthBit));
    roundEF roundingModule(.sixthBit(sixthBit), .unroundedF(unroundedF), .unroundedPower(unroundedPower),
                            .roundedPower(roundedPower), .roundedF(roundedF));   
    detect4096 detect4096Module(.magnitude(magnitude), .detect4096(detected4096));   
    handle4096 handle4096Module(.detected4096(detected4096), .roundedPower(roundedPower), 
                                .roundedF(roundedF), .E(E), .F(F));
endmodule

module getMagnitude(
	input [12:0] D, 
	output reg [12:0] magnitude);

	always @(*) begin
		if( D[12] == 1)
			magnitude = ~D + 13'b1;
		else
			magnitude = D;
	end
endmodule

module countZeroes(
	input [12:0] magnitude,
	output reg [2:0] unroundedPower);
	
	always @(*) begin
        if(magnitude[12]== 1'b1 || magnitude[11] == 1'b1) unroundedPower = 3'b111;
		else if(magnitude[10] == 1'b1) unroundedPower = 3'b110;
		else if(magnitude[9] == 1'b1)  unroundedPower = 3'b101;
		else if(magnitude[8] == 1'b1)  unroundedPower = 3'b100;
		else if(magnitude[7] == 1'b1)  unroundedPower = 3'b011;
		else if(magnitude[6] == 1'b1)  unroundedPower = 3'b010;
		else if(magnitude[5] == 1'b1)  unroundedPower = 3'b001;
		else                        unroundedPower = 3'b000;
    end

endmodule

module getMantissa(
	input [12:0] magnitude,
	input [2:0] unroundedPower,
	output reg [4:0] unroundedF );

	always @(*) begin
		case(unroundedPower)
			3'b000: unroundedF = magnitude[4:0];
			3'b001: unroundedF = magnitude[5:1];
			3'b010: unroundedF = magnitude[6:2];
			3'b011: unroundedF = magnitude[7:3];
            3'b100: unroundedF = magnitude[8:4];
            3'b101: unroundedF = magnitude[9:5];
            3'b110: unroundedF = magnitude[10:6];
            3'b111: unroundedF = magnitude[11:7];
		endcase
	end
endmodule

module getSixthBit(
	input [12:0] magnitude,
	input [2:0] unroundedPower,
	output reg sixthBit);
	
	always @(*) begin
		case(unroundedPower)
			3'b000: sixthBit = 1'b0; // no need to round
			3'b001: sixthBit = magnitude[0];
			3'b010: sixthBit = magnitude[1];
			3'b011: sixthBit = magnitude[2];
			3'b100: sixthBit = magnitude[3];
			3'b101: sixthBit = magnitude[4];
			3'b110: sixthBit = magnitude[5];
			3'b111: sixthBit = magnitude[6];
		endcase
	end
endmodule


module roundEF(
    input sixthBit,
    input [4:0] unroundedF,
    input [2:0] unroundedPower,
    output reg [2:0] roundedPower,
    output reg [4:0] roundedF);
    
    always @(*) begin
        if(&unroundedF == 1'b1 && sixthBit == 1'b1) begin
            if(unroundedPower == 3'b111) begin
                roundedPower = unroundedPower;
                roundedF = unroundedF;
            end
            else begin    
                roundedPower = unroundedPower + 3'b1;
                roundedF = 5'b10000; 
            end
        end
        else if (sixthBit == 1'b1) begin
            roundedPower = unroundedPower;
            roundedF = unroundedF + 1'b1;
        end
        else begin
            roundedPower = unroundedPower;
            roundedF = unroundedF;
        end       
    end
endmodule

module detect4096(
  input [12:0] magnitude,
  output reg detect4096);
  
  always @(*) begin
    if(magnitude == 13'b1000000000000)
      detect4096 = 1'b1;
    else
      detect4096 = 1'b0;
  end
endmodule

module handle4096(
    input detected4096,
    input [2:0] roundedPower,
    input [4:0] roundedF,
    output reg [2:0] E,
    output reg [4:0] F);
    
    always @(*) begin
        if(detected4096 == 1'b1) begin
            E = 3'b111;
            F = 5'b11111;
        end
        else begin
            E = roundedPower;
            F = roundedF;
        end            
    end
endmodule
