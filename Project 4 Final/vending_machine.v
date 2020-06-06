`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:00:12 05/10/2020 
// Design Name: 
// Module Name:    vending_machine 
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
module vending_machine(
    input CARD_IN,
    input VALID_TRAN,
    input [3:0] ITEM_CODE,
    input KEY_PRESS,
    input DOOR_OPEN,
    input RELOAD,
    input CLK,
    input RESET,
    output reg VEND,
    output reg INVALID_SEL,
    output reg FAILED_TRAN,
    output reg [2:0] COST  
    );
    
    reg [3:0] item0 = 4'd0;
    reg [3:0] item1 = 4'd0;
    reg [3:0] item2 = 4'd0;
    reg [3:0] item3 = 4'd0;
    reg [3:0] item4 = 4'd0;
    reg [3:0] item5 = 4'd0;
    reg [3:0] item6 = 4'd0;
    reg [3:0] item7 = 4'd0;
    reg [3:0] item8 = 4'd0;
    reg [3:0] item9 = 4'd0;
    reg [3:0] item10 = 4'd0;
    reg [3:0] item11 = 4'd0;
    reg [3:0] item12 = 4'd0;
    reg [3:0] item13 = 4'd0;
    reg [3:0] item14 = 4'd0;
    reg [3:0] item15 = 4'd0;
    reg [3:0] item16 = 4'd0;
    reg [3:0] item17 = 4'd0;
    reg [3:0] item18 = 4'd0;
    reg [3:0] item19 = 4'd0;
    
    parameter reset_s = 4'd0; //reset state
    parameter reload_s = 4'd1; //reload state
    parameter idle_s = 4'd2; //initial state
    parameter wait_digit1_s = 4'd3; //waiting for first digit
    parameter wait_digit2_s = 4'd4; //waiting for second digit
    parameter validate_item_s = 4'd5; //check input item #
    parameter wait_auth_s = 4'd6; //waiting for authorization
    parameter wait_open_s = 4'd7; //waiting for door to open
    parameter wait_close_s = 4'd8; //wait for door to close
    parameter inval_input_s = 4'd9; //invalid input failure
    parameter fail_tran_s = 4'd10; //failed transaction
    
    parameter timeout = 3'd5; //timeout value
    
    reg [3:0] state = idle_s; //initial state: idle
    reg [4:0] selected_item = 5'd0;
    reg [2:0] clk_counter = 3'd1;
    reg first_digit = 1'd0;

    always @(posedge CLK) begin
        if(RESET) begin
            state = reset_s;
        end      
        
        //next state logic
        if(state == reset_s) begin
            if(!RESET) state = idle_s;
        end
        else if(state == reload_s) begin
            if(!RELOAD) state = idle_s;
        end
        else if(state == idle_s) begin
            if(RELOAD) begin
                // reload takes precedence over a transaction
                state = reload_s;
            end
            else if(CARD_IN) begin
                state = wait_digit1_s;
                clk_counter = 3'd1;
            end
        end
             
        else if(state == wait_digit1_s) begin
            if(clk_counter == timeout) begin
                state = inval_input_s;
            end
            else if(KEY_PRESS) begin
                if(ITEM_CODE > 4'd1) begin
                    state = inval_input_s;
                end
                else begin
                    // valid digit
                    state = wait_digit2_s;
                    first_digit = ITEM_CODE[0]; //save the first digit
                    clk_counter = 3'd1; //reset counter for next digit
                end
            end
            else begin
                clk_counter = clk_counter + 3'd1;
            end
        end
        
        else if(state == wait_digit2_s) begin
            if(clk_counter == timeout) begin
                state = inval_input_s;
            end
            else if(KEY_PRESS) begin
                // key was pressed
                if(ITEM_CODE > 4'd9) begin
                    // second digit: only 0-9 are valid
                    state = inval_input_s;
                end
                else begin
                    // item number is in range [0, 19]
                    selected_item = first_digit * 4'd10 + ITEM_CODE;
                    state = validate_item_s; //now check for nonzero
                    clk_counter = 3'd1; //reset counter for next digit
                end
            end
            else begin
                clk_counter = clk_counter + 3'd1;
            end
        end
        
        else if(state == validate_item_s) begin
            if(selected_item == 5'd0 && item0 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd1 && item1 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd2 && item2 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd3 && item3 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd4 && item4 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd5 && item5 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd6 && item6 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd7 && item7 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd8 && item8 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd9 && item9 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd10 && item10 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd11 && item11 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd12 && item12 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd13 && item13 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd14 && item14 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd15 && item15 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd16 && item16 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd17 && item17 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd18 && item18 == 4'd0) state = inval_input_s;
            else if(selected_item == 5'd19 && item19 == 4'd0) state = inval_input_s;
            else begin
                state = wait_auth_s;
                clk_counter = 3'd1; //redundant, but reset counter for authorization
            end
        end
        
        else if(state == wait_auth_s) begin
            if(clk_counter == timeout) begin
                state = fail_tran_s;
            end
            else if(VALID_TRAN) begin
                state = wait_open_s;
                clk_counter = 3'd1; //reset the clock
            end
            else begin
                clk_counter = clk_counter + 3'd1;
            end
        end
        
        else if(state == wait_open_s) begin
            if(clk_counter == timeout) begin
                state = idle_s; //go back to idle
            end
            else if(DOOR_OPEN) begin
                state = wait_close_s;
                clk_counter = 3'd1; //reset clk counter (strictly not needed)
            end
            else begin
                clk_counter = clk_counter + 3'd1;
            end
        end
        
        else if(state == wait_close_s) begin
            if(!DOOR_OPEN) state = idle_s;
        end
        
        else if(state == inval_input_s) begin
            state = idle_s;
        end
        
        else if(state == fail_tran_s) begin
            state = idle_s;
        end

    end
    
    always @(posedge CLK) begin
        if(state == reset_s) begin
            item0 = 4'd0;
            item1 = 4'd0;
            item2 = 4'd0;
            item3 = 4'd0;
            item4 = 4'd0;
            item5 = 4'd0;
            item6 = 4'd0;
            item7 = 4'd0;
            item8 = 4'd0;
            item9 = 4'd0;
            item10 = 4'd0;
            item11 = 4'd0;
            item12 = 4'd0;
            item13 = 4'd0;
            item14 = 4'd0;
            item15 = 4'd0;
            item16 = 4'd0;
            item17 = 4'd0;
            item18 = 4'd0;
            item19 = 4'd0;
            VEND = 1'b0;
            INVALID_SEL = 1'b0;
            FAILED_TRAN = 1'b0;
            COST = 3'b0;
        end
        
        else if(state == reload_s) begin
            item0 = 4'd10;
            item1 = 4'd10;
            item2 = 4'd10;
            item3 = 4'd10;
            item4 = 4'd10;
            item5 = 4'd10;
            item6 = 4'd10;
            item7 = 4'd10;
            item8 = 4'd10;
            item9 = 4'd10;
            item10 = 4'd10;
            item11 = 4'd10;
            item12 = 4'd10;
            item13 = 4'd10;
            item14 = 4'd10;
            item15 = 4'd10;
            item16 = 4'd10;
            item17 = 4'd10;
            item18 = 4'd10;
            item19 = 4'd10;
        end
        
        else if(state == idle_s) begin
            VEND = 1'b0;
            INVALID_SEL = 1'b0;
            FAILED_TRAN = 1'b0;
            COST = 3'b0;
        end
      
        else if(state == wait_auth_s) begin
            case(selected_item)
                5'd0,
                5'd1,
                5'd2,
                5'd3: COST = 3'd1;
                5'd4,
                5'd5,
                5'd6,
                5'd7: COST = 3'd2;
                5'd8,
                5'd9,
                5'd10,
                5'd11: COST = 3'd3;
                5'd12,
                5'd13,
                5'd14,
                5'd15: COST = 3'd4;
                5'd16,
                5'd17: COST = 3'd5;
                default: COST = 3'd6; //guaranteed to be 18 or 19
                //use default to avoid latch being created
            endcase
        end

        else if(state == wait_open_s) begin
            // change outputs
            if(VEND == 1'b0) begin
                // we only want to decrement once
                // not every clock cycle that we're waiting
                case(selected_item)
                5'd0: item0 = item0 - 4'd1;
                5'd1: item1 = item1 - 4'd1;
                5'd2: item2 = item2 - 4'd1;
                5'd3: item3 = item3 - 4'd1;
                5'd4: item4 = item4 - 4'd1;
                5'd5: item5 = item5 - 4'd1;
                5'd6: item6 = item6 - 4'd1;
                5'd7: item7 = item7 - 4'd1;
                5'd8: item8 = item8 - 4'd1;
                5'd9: item9 = item9 - 4'd1;
                5'd10: item10 = item10 - 4'd1;
                5'd11: item11 = item11 - 4'd1;
                5'd12: item12 = item12 - 4'd1;
                5'd13: item13 = item13 - 4'd1;
                5'd14: item14 = item14 - 4'd1;
                5'd15: item15 = item15 - 4'd1;
                5'd16: item16 = item16 - 4'd1;
                5'd17: item17 = item17 - 4'd1;
                5'd18: item18 = item18 - 4'd1;
                default: item19 = item19 - 4'd1; 
                //guaranteed to be 19
                //use default to avoid latch being created
                endcase
            end
            VEND = 1'b1;
        end
        
        else if(state == inval_input_s) begin
            INVALID_SEL = 1'b1;
        end
        
        else if(state == fail_tran_s) begin
            FAILED_TRAN = 1'b1;
        end
    end
endmodule
