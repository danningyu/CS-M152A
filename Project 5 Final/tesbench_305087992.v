`timescale 1ms / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:20:09 05/27/2020
// Design Name:   parking_meter
// Module Name:   C:/Danning/CS M152A/Project5/tesbench_305087992.v
// Project Name:  Project5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: parking_meter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tesbench_305087992;

	// Inputs
	reg clk;
	reg add1;
	reg add2;
	reg add3;
	reg add4;
	reg rst1;
	reg rst2;
    reg rst;

	// Outputs
	wire [3:0] val1;
	wire [3:0] val2;
	wire [3:0] val3;
	wire [3:0] val4;
	wire [6:0] led_seg; //[CA CB CC... CG]
	wire a1;
	wire a2;
	wire a3;
	wire a4;

	// Instantiate the Unit Under Test (UUT)
	parking_meter uut (
		.clk(clk), 
		.add1(add1), 
		.add2(add2), 
		.add3(add3), 
		.add4(add4), 
		.rst1(rst1), 
		.rst2(rst2), 
        .rst(rst),
		.val1(val1), 
		.val2(val2), 
		.val3(val3), 
		.val4(val4), 
		.led_seg(led_seg), 
		.a1(a1), 
		.a2(a2), 
		.a3(a3), 
		.a4(a4)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		add1 = 1;
		add2 = 1;
		add3 = 1;
		add4 = 1;
		rst1 = 1;
        rst2 = 1;
        rst = 1; //test rst, precedence over all other inputs
        #10;
        rst = 0;
        rst1 = 0;
		rst2 = 0;
		add1 = 0;
		add2 = 0;
		add3 = 0;
        add4 = 0;
        #4500; //9 seconds
        //Test 1: check flashing at 1 Hz when idle and no time left
        
		// test each button
        rst2 = 1; //Test 2: test rst2
        #10;
        rst2 = 0;
        #10;
        rst1 = 1; //Test 2: test rst1
        #10;
        rst1 = 0;
        add1 = 1; //Test 2: test add1
        #10;
        add1 = 0;
        #10;
        add2 = 1; //Test 2: test add2
        #10;
        add2 = 0;
        #10;
        add3 = 1; //Test 2: test add3
        #10;
        add3 = 0;
        #10;
        add4 = 1; //Test 2: test add4
        #10;
        add4 = 0;
        #10;
        #10000;
        //Tests 3 and 4: confirm flashing at 1 Hz, > 180
        rst2 = 1;
        #10;
        rst2 = 0;
        //Tests 4 and 5: confirm flashing at 0.5 Hz on even #s
        #10000;
        add1 = 1;
        #10;
        add1 = 0;
        //Test 6: confirm transition from >= 180 to < 180 is correct
        #25000;
        add4 = 1;
        #3000; //Test 7: latch to 9999
        add4 = 0;
        #5000; //wait 5 seconds
        add1 = 1; //Test 7: should latch to 9999
        #10;
        add1 = 0; 
        #5000; //wait 5 seconds
        rst2 = 1; //Test 8: rst2 takes precedence
        rst1 = 1; 
        #10;
        rst2 = 0;
        rst1 = 0;
        add4 = 1; //Test 8: add4 takes precedence
        add3 = 1;
        add2 = 1;
        #10;
        add4 = 0;
        add3 = 0;
        add2 = 0;
        rst1 = 1; //Test 8: rst takes precedence over add
        add1 = 1; 
        #10;
        rst1 = 0;
        add1 = 0;
        add3 = 1; //Test 9: increase to 195 s
        #10;
        add3 = 0;
        #200000; //Test 9: wait 200 s to run down to 0
        rst1 = 1; //Test 10: reset to 15 s
        #10; 
        rst1 = 0;
        add1 = 1; //Test 10: add 60 to make 75 s
        #10; 
        add1 = 0; //Test 10: should display on 74 s left
        #80000; //allow to run down to 0 again
        #2;
        add4 = 1; //Test 11: very short input (only high for 2 ms)
        #2;
        add4 = 0;
        #100;
        $finish;
	end
    
    always begin
        #5;
        clk = ~clk;
    end
      
endmodule

