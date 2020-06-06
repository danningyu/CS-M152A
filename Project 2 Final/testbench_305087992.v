`timescale 1ns / 1ps
`define assert(signal, value, testcase) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m for %d: %b != %b", $signed(testcase), signal, value); \
        end

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:37:15 04/26/2020
// Design Name:   FPCVT
// Module Name:   C:/Danning/CS M152A/Project2/FPCVT_tb.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPCVT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPCVT_tb;

	// Inputs
	reg [12:0] D;

	// Outputs
	wire S;
	wire [2:0] E;
	wire [4:0] F;

	// Instantiate the Unit Under Test (UUT)
	FPCVT uut (
		.D(D), 
		.S(S), 
		.E(E), 
		.F(F)
	);
    
    integer file;
    integer scan_file;
    reg [12:0] data;
    
	initial begin
        file = $fopen("progConversion.txt", "r");
        if(!file)
            $display("Failed to open file");
        else 
            $display("Successfully opened file");
   
		D = 13'b0;
        #100;
	end
    
    always
    begin    
//        manual testing of edge cases    
//        #100;
//        D = 0;
//        #100;
//        D = 1;
//        #100;
//        D = 8;
//        #100;
//        D = 16;
//        #100;
//        D = 31;
//        #100;
//        D = 32;
//        #100;
//        D = 33;
//        #100;
//        D = 34;
//        #100;
//        D = 63;
//        #100;
//        D = 3967;
//        #100;
//        D = 3968;
//        #100;
//        D = 4032;
//        #100;
//        D = 4095;
//        #100;
//        
//        D = -1;
//        #100;
//        D = -8;
//        #100;
//        D = -16;
//        #100;
//        D = -31;
//        #100;
//        D = -32;
//        #100;
//        D = -33;
//        #100;
//        D = -34;
//        #100;
//        D = -63;
//        #100;
//        D = -3967;
//        #100;
//        D = -3968;
//        #100;
//        D = -4032;
//        #100;
//        D = -4095;
//        #100;
//        D = -4096;

//        automated testing against expected results
//        for all 8192 possible inputs
        #100; 
        scan_file = $fscanf(file, "%b\n", data);
        `assert(D, data, D);
        scan_file = $fscanf(file, "%b\n", data);
        `assert(S, data, D);
        scan_file = $fscanf(file, "%b\n", data);
        `assert(E, data, D);
        scan_file = $fscanf(file, "%b\n", data);
        `assert(F, data, D);
        
        
        D = D + 1'b1;    

        if(D == 0) begin
            $fclose(file);
            $finish;
         end
           
    end
endmodule

