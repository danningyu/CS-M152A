`timescale 1ns / 1ps
`define assert(signal, value) \
        if (signal !== value) begin \
            $display($time, " ASSERTION FAILED: Expected %b, got %b", value, signal); \
            $finish; \
        end



////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:54:24 05/14/2020
// Design Name:   vending_machine
// Module Name:   C:/Danning/CS M152A/Project4/testbench_305087992.v
// Project Name:  Project4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vending_machine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench_305087992;

	// Inputs
	reg CARD_IN;
	reg VALID_TRAN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg DOOR_OPEN;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;
    
    parameter LOW = 1'b0;
    parameter HIGH = 1'b1;
    
    integer i;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.DOOR_OPEN(DOOR_OPEN), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);

	initial begin
		// Initialize Inputs
		CARD_IN = LOW;
		VALID_TRAN = LOW;
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
		RELOAD = LOW;
		CLK = LOW;
        RESET = HIGH;
        
        //format: signals, wait 10 ns, test for outputs
        
        // Test 1: reset state
		RESET = HIGH; //enter reset state
        #20; //confirm that it stays in reset state
        
        CARD_IN = HIGH; //confirm no other inputs take effect
		VALID_TRAN = HIGH;
		ITEM_CODE = HIGH;
		KEY_PRESS = HIGH;
		DOOR_OPEN = HIGH;
		RELOAD = HIGH;
        #10;
        `assert(VEND, LOW); //all outputs should be low
        `assert(COST, 3'b0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        //check: counters are 0
        // END test 1
        
        
        // Test 2: reload state
        RESET = LOW; //enter idle state
        CARD_IN = LOW; //zero out all other outputs
		VALID_TRAN = LOW;
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
		RELOAD = LOW;
        #10;
        
        RELOAD = HIGH; //enter reload state
        #20; // confirm that it stays in reload state
        // CHECK: counters are 10
        
        //confirm no other inputs except RESET take effect
        CARD_IN = HIGH; 
		VALID_TRAN = HIGH;
		ITEM_CODE = HIGH;
		KEY_PRESS = HIGH;
		DOOR_OPEN = HIGH;
        #10;
        `assert(VEND, LOW); //all outputs should be low
        `assert(COST, 3'b0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        RESET = HIGH; //only signal that takes effect
        CARD_IN = LOW; //zero out all other outputs
		VALID_TRAN = LOW;
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
		RELOAD = LOW;
        #10;
        //check counters are 0
        
        RESET = LOW; //enter idle state
        #10;
        
        RELOAD = HIGH;
        #10; //reload (for real this time)
        
        RELOAD = LOW; //go back to idle state
        #10; 
        // CHECK: counters are 10
        // END test 2
   
   
        // Test 3: normal operation sequence with item 10
        CARD_IN = HIGH; //go to wait_digit1_s
        #10;
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1; //go to wait_digit2_s
        #10;
        
        ITEM_CODE = 4'd0; //second digit
        #10;
        
        #10; //pass through input validation
        `assert(COST, 3'd3); //check cost is correct
        
        VALID_TRAN = HIGH;
        #10;
        `assert(VEND, HIGH); //check VEND is high; item10 should be 9
        
        DOOR_OPEN = HIGH;
        #10;
        
        DOOR_OPEN = LOW;
        #10; //ends transaction, back to idle state
        `assert(VEND, LOW); //all outputs should be low
        `assert(COST, 3'b0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);    

        CARD_IN = LOW; //zero out all other outputs
		VALID_TRAN = LOW;
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
        #10;
        //END TEST 3

 
        // Test 4: Check key pressing operations for first digit
        CARD_IN = HIGH; //keep this high the entire time       
        #50; //cause timeout, should go to invalid input then idle
        
        #10; // go to invalid input
        `assert(INVALID_SEL, HIGH);
        
        #10; //exit invalid selection state
        `assert(VEND, LOW); //all outputs should be low
        `assert(COST, 3'b0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW); 
        
        #10; // CARD_IN still 1, so go back to wait for digit
        
        ITEM_CODE = 4'd1; //KEY_PRESS not high so this shouldn't have an effect
        #10;
        `assert(VEND, LOW); //all outputs should be low
        `assert(COST, 3'b0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);

        ITEM_CODE = 4'd2;
        KEY_PRESS = HIGH; //this should go through but is invalid       
        #10; //go to invalid state
        `assert(INVALID_SEL, HIGH);
        
        KEY_PRESS = LOW;
        CARD_IN = LOW;
        #10; // go to idle state
        `assert(INVALID_SEL, LOW); //invalid selection should go back to low
        
        CARD_IN = HIGH;
        #10;
        
        #30;
        `assert(INVALID_SEL, LOW); //can wait up to 4 clock cycles for input digit
        // 10 ns before + 30 ns now
        
        ITEM_CODE = 4'd0;
        KEY_PRESS = HIGH; //provide valid inputs this time, should move on to second digit
        #10;
        `assert(INVALID_SEL, LOW);
        // END TEST 4
    
    
        // TEST 5: check key pressing operations for 2nd digit, continuing from previous test
        KEY_PRESS = LOW;
        CARD_IN = LOW; //also "take out" card
        #40; //cause timeout (40 ns here + 10 ns earlier), should go to invalid input
        
        #10; //on 6th clock cycle, go to invalid input
        `assert(INVALID_SEL, HIGH);
              
        #10; //back to idle
        `assert(INVALID_SEL, LOW);
        
        CARD_IN = HIGH;
        #10;
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd0; //go through first diigt
        #10;
        `assert(INVALID_SEL, LOW); //first digit should be valid
        
        KEY_PRESS = LOW;
        ITEM_CODE = 4'd9; //should have no effect
        #10;
        `assert(INVALID_SEL, LOW); //stay in same state
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd11; //outside range
        #10;
        `assert(INVALID_SEL, HIGH); //second digit invalid
        
        CARD_IN = LOW;
        KEY_PRESS = LOW;
        #10;
        `assert(INVALID_SEL, LOW); //back to idle state
        
        // start new transaction
        CARD_IN = HIGH;
        #10;
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd0; //go through first diigt
        #10;
        `assert(INVALID_SEL, LOW); //first digit should be valid
        
        KEY_PRESS = LOW;
        #30; //up to 4 clock cycles (10 ns before + 30 ns here) acceptable
        `assert(INVALID_SEL, LOW); //should still be waiting for second digit
        
        ITEM_CODE = 4'd0; //second digit: 0
        KEY_PRESS = HIGH;
        #10;
        `assert(INVALID_SEL, LOW); //second digit should be valid
        // END TEST 5
       
       
        // Test 6: Check validate input stage
        // continue from previous test
        #10;
        `assert(INVALID_SEL, LOW); //item selection should be valid
        
        RESET = HIGH; //set all counters to 0
        #10;
        
        RESET = LOW; //turn off reset
        #10;
        
        CARD_IN = HIGH; //new transaction
		VALID_TRAN = LOW;
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
        #10;
        
        CARD_IN = LOW;
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1; //first digit 1
        #10;
        `assert(INVALID_SEL, LOW); //first digit should be valid
        
        ITEM_CODE = 4'd9; //second digit 9
        #10;
        `assert(INVALID_SEL, LOW); //second digit should be valid
        
        #10; //validate input
        `assert(INVALID_SEL, HIGH); //invalid because out of items
        
        #10;
        `assert(INVALID_SEL, LOW); // 0 in idle state
        
        RELOAD = HIGH; //reload items to qty = 10
        #10;
        
        RELOAD = LOW; //turn off reload
        #10;
        // END test 6
        
        
        //Test 7: check waiting for authorization
        // new transaction with item 00 - confirm 00 works
		VALID_TRAN = LOW; //zero out inputs
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
        CARD_IN = HIGH;
        #10; //update to wait_digit1_s
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd0;
        #10; //go to second digit
        
        ITEM_CODE = 4'd1; //select item 1
        #10; //go to validate stage
        
        #10; //go to wait for authorization        
        `assert(INVALID_SEL, LOW); //valid selection
        `assert(COST, 3'd1); //check cost of item 1
        
        #40; //timeout waiting for authorization
        // 10 ns before + 50 ns now
               
        #10;
        `assert(FAILED_TRAN, HIGH); //invalid transaction
        `assert(INVALID_SEL, LOW); //and not invalid selection
        `assert(COST, 4'd1); //cost stays on until idle state
                
        #10;
        `assert(FAILED_TRAN, LOW); //failed_tran should go back to low
        `assert(INVALID_SEL, LOW);
        
        //starting new transaction, item 12
        CARD_IN = HIGH;
        #10; // wait for digit 1
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for digit 2
        
        ITEM_CODE = 4'd2;
        #10; //wait for verification
              
        #10; //wait for authorization
        `assert(INVALID_SEL, LOW); //valid selection
        `assert(COST, 3'd4); //check cost of item 12
        
        #30;
        `assert(FAILED_TRAN, LOW); // 4 clock cycles is acceptable (10 ns + 30 ns)
        
        VALID_TRAN = HIGH;
        #10;
        `assert(FAILED_TRAN, LOW);
        `assert(VEND, HIGH);
        // check counter for item 1 is 9
        //END test 7
        
        
        // Test 8: wait for open door
        // continue from previous test
        DOOR_OPEN = LOW;
        #40; //timeout, all inputs should be low (10 ns + 40ns)
        
        #10; //idle to take effect
        `assert(VEND, LOW); //all outputs should be low b/c idle state
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        // should be in idle state (no intermediate failure stage this time)
        
        // start new transaction, item 02
        CARD_IN = HIGH;
		VALID_TRAN = LOW;
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
        #10;
        
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd0; //1st digit
        #10;
        `assert(INVALID_SEL, LOW); //valid selection
        
        ITEM_CODE = 4'd2; //2nd digit
        #10;
        `assert(INVALID_SEL, LOW); //valid selection
      
        #10; //verification should pass
        `assert(INVALID_SEL, LOW); //valid selection
        `assert(COST, 3'd1);
               
        VALID_TRAN = HIGH;
        #10;
        `assert(FAILED_TRAN, LOW);
        `assert(COST, 3'd1); //cost stays on until idle state
        `assert(VEND, HIGH);
        
        #30;
        `assert(COST, 4'd1); //4 clock cycles acceptable (30 ns + 10 ns)
        `assert(VEND, HIGH);       
        
        DOOR_OPEN = HIGH;
        #10;
        `assert(COST, 3'd1); // stay high until idle
        `assert(VEND, HIGH); // stay high until idle     
        // END test 8
        
        
        // Test 9: wait for door to close
        #100; //do nothing until door closes
        `assert(COST, 4'd1);
        `assert(VEND, HIGH);
            
        DOOR_OPEN = LOW;
        #10;
        `assert(VEND, LOW); //all outputs should be low b/c idle state
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        // END test 9
        
        
        // Test 10: Check item prices
        CARD_IN = HIGH;
        KEY_PRESS = HIGH;
        #10;
        
        ITEM_CODE = 4'd1;
        #10;
        
        ITEM_CODE = 4'd9;
        #10;
        
        #10;
        `assert(COST, 4'd6);
        
        VALID_TRAN = HIGH;
        #50; //timeout and go to idle
        
        #10; //idle
        `assert(COST, 3'd0);
        
        //test 18
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd8;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd6);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        // test 17
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd7;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd5);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        //test 16
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd6;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd5);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd5;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd4);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd4;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd4);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd3;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd4);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd2;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd4);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd1;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd3);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd1;
        #10; //second digit        
        ITEM_CODE = 4'd0;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd3);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd9;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd3);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd8;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd3);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd7;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd2);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);

        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd6;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd2);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd5;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd2);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        

        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd4;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd2);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        

        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd3;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd1);       

        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        

        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd2;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd1);       
        VALID_TRAN = HIGH;
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        
        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd1;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd1);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);

        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd0;
        #10; //validate       
        #10; //wait for auth
        `assert(COST, 4'd1);       
        #50; //timeout and go to idle    
        #10;
        `assert(COST, 3'd0);
        // END test 10


        // TEST 11: increment item from 10 down to 0
        RELOAD = HIGH;
        #10;
        
        RELOAD = LOW;
        #10;
        
        KEY_PRESS = HIGH;

        for(i = 0; i<10; i = i+1) begin
            CARD_IN = HIGH;
            #10; //first digit       
            ITEM_CODE = 4'd0;
            #10; //second digit        
            ITEM_CODE = 4'd5;
            #10; //validate       
            #10; //wait for auth
            `assert(COST, 4'd2);       
            VALID_TRAN = HIGH;
            #50; //timeout and go to idle    
            #10;
            `assert(COST, 3'd0);
        end
        CARD_IN = HIGH;
        #10; //first digit       
        ITEM_CODE = 4'd0;
        #10; //second digit        
        ITEM_CODE = 4'd5;
        #10; //validate
        
        #10;
        `assert(INVALID_SEL, HIGH);
        `assert(COST, 3'd0);
        
        #10;
        `assert(INVALID_SEL, LOW);
        `assert(COST, 3'd0);
        //END TEST 11
        
        
        // TEST 12: irrelevant inputs at each state
        VALID_TRAN = LOW; //zero out inputs
		ITEM_CODE = LOW;
		KEY_PRESS = LOW;
		DOOR_OPEN = LOW;
        CARD_IN = LOW;
        #10; //stay in idle_s
        
        CARD_IN = HIGH;
        #10;
        
        ITEM_CODE = 4'd15; //without KEY_PRESS, take no action
        VALID_TRAN = HIGH;
        DOOR_OPEN = HIGH;
        #10;
        `assert(VEND, LOW); //all outputs should be low and unaffected
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        VALID_TRAN = LOW;
        DOOR_OPEN = LOW;
        ITEM_CODE = 4'd1;
        KEY_PRESS = HIGH;
        RELOAD = HIGH;
        #10;
        `assert(INVALID_SEL, LOW);
        
        KEY_PRESS = LOW;
        ITEM_CODE = 4'd15; //without KEY_PRESS, take no action for 2nd digit
        VALID_TRAN = HIGH; //these inputs shouldn't matter
        DOOR_OPEN = HIGH;

        #10;
        `assert(VEND, LOW); //all outputs should be low and unaffected
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        VALID_TRAN = LOW;
        DOOR_OPEN = LOW;
        ITEM_CODE = 4'd2; //2nd digit: 2
        KEY_PRESS = HIGH;
        #10; //verification stage
        `assert(INVALID_SEL, LOW);
        
        KEY_PRESS = HIGH; //none of these should matter in the verification state
        VALID_TRAN = HIGH;
        ITEM_CODE = 4'd5;
        DOOR_OPEN = HIGH; 
        #10; //wait for auth stage
        `assert(VEND, LOW); //all outputs should be low and unaffected
        `assert(COST, 3'd4); // except for cost b/c now in wait_open_s
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        #10;
        `assert(VEND, HIGH); //all outputs should be low and unaffected
        `assert(COST, 3'd4); // except for cost b/c now in wait_open_s
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        //door already open so automaticaly proceed to next stage
        #10;
        `assert(VEND, HIGH); 
        `assert(COST, 3'd4); 
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        DOOR_OPEN = LOW;
        RELOAD = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        //END test 12
       
       
        // TEST 13: Everything is on from the start, all valid inputs
        CARD_IN = HIGH;
        VALID_TRAN = HIGH;
        DOOR_OPEN = HIGH;
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //enter wait_digit1_s
        `assert(INVALID_SEL, LOW);
        #10; //enter wait_digit2_s
        `assert(INVALID_SEL, LOW);
        #10; //enter verification
        `assert(INVALID_SEL, LOW);
        #10; //enter wait for auth
        `assert(INVALID_SEL, LOW);
        `assert(COST, 4'd3);
        #10; //enter wait for open
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        `assert(COST, 4'd3);
        `assert(VEND, HIGH);
        #10; //enter wait for close
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        `assert(COST, 4'd3);
        `assert(VEND, HIGH);
        
        DOOR_OPEN = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        // everything is still on so it should repeat
        DOOR_OPEN = HIGH;
        #10; //enter wait_digit1_s
        `assert(INVALID_SEL, LOW);
        #10; //enter wait_digit2_s
        `assert(INVALID_SEL, LOW);
        #10; //enter verification
        `assert(INVALID_SEL, LOW);
        #10; //enter wait for auth
        `assert(INVALID_SEL, LOW);
        `assert(COST, 4'd3);
        #10; //enter wait for open
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        `assert(COST, 4'd3);
        `assert(VEND, HIGH);
        #10; //enter wait for close
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        `assert(COST, 4'd3);
        `assert(VEND, HIGH);
        
        CARD_IN = LOW;
        VALID_TRAN = LOW;
        DOOR_OPEN = LOW;
        KEY_PRESS = LOW;
        ITEM_CODE = 4'd0;
        #10;        
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        //END test 13
        
        
        //Test 14: check that reset works anytime
        CARD_IN = HIGH; //from wait_digit1_s
        #10;
        
        RESET = HIGH;
        #10;
        //confirm in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        CARD_IN = HIGH;
        #10;
        
        KEY_PRESS = HIGH; //enter reset from wait_digit2_s
        ITEM_CODE = 4'd1;
        #10; 
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        CARD_IN = HIGH; //enter reset from validate_item_s
        #10; //wait for 1st digit
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for 2nd digit
        
        #10; //from verify stage
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);

        CARD_IN = HIGH; //enter reset from inval_input_s
        #10; //wait for 1st digit
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for 2nd digit
        
        #10; //wait for verification
        
        #10; //item qty is 0 so wait for invalid state
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        //reload items
        RELOAD = HIGH;
        #10;
        RELOAD = LOW;
        #10;        
        CARD_IN = HIGH; //enter reset from wait_auth_s
        #10; //wait for 1st digit
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for 2nd digit
        
        #10; //wait for verification
        
        #10; //verification should pass, waiting for authorization
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        //reload items
        RELOAD = HIGH;
        #10;
        RELOAD = LOW;
        #10;        
        CARD_IN = HIGH; //enter reset from fail_tran_s
        #10; //wait for 1st digit
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for 2nd digit
        
        #10; //wait for verification
        
        #50; //fail authorization
        
        #10; //enter wait_open_s
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        //reload items
        RELOAD = HIGH;
        #10;
        RELOAD = LOW;
        #10;        
        CARD_IN = HIGH; //enter reset from wait_open_s
        #10; //wait for 1st digit
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for 2nd digit
        
        #10; //wait for verification
        
        #10; //verification should pass, waiting for authorization
        
        VALID_TRAN = HIGH;
        #10; //enter wait_open_s
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        
        //reload items
        RELOAD = HIGH;
        #10;
        RELOAD = LOW;
        #10;        
        CARD_IN = HIGH; //enter reset from wait_close_s
        #10; //wait for 1st digit
        KEY_PRESS = HIGH;
        ITEM_CODE = 4'd1;
        #10; //wait for 2nd digit
        
        #10; //wait for verification
        
        #10; //verification should pass, waiting for authorization
        
        VALID_TRAN = HIGH;
        #10; //enter wait_open_s
        
        DOOR_OPEN = HIGH;
        #10; //enter wait_close_s
        
        RESET = HIGH;
        #10;
        //check in reset state
        
        RESET = LOW;
        #10;
        `assert(VEND, LOW); //return to idle, all outputs should be low
        `assert(COST, 3'd0);
        `assert(INVALID_SEL, LOW);
        `assert(FAILED_TRAN, LOW);
        //END test 14
        
        $finish;       
	end
    
    always begin
        CLK = ~CLK;
        #5;
    end
      
endmodule
