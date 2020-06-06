`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:37 05/27/2020 
// Design Name: 
// Module Name:    parking_meter 
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
module parking_meter(
    input clk,
    input add1,
    input add2,
    input add3,
    input add4,
    input rst1,
    input rst2,
    input rst,
    output [3:0] val1, //ones
    output [3:0] val2, //tens
    output [3:0] val3, //hundreds
    output [3:0] val4, //thousands
    output [6:0] led_seg, // [CA, CB, CC, ... CG]
    output a1, //ones
    output a2, //tens
    output a3, //hundreds
    output a4  //thousands
);
    wire shouldDisplay;
    wire [13:0] counter;
    wire [6:0] thousands;
    wire [6:0] hundreds;
    wire [6:0] tens;
    wire [6:0] ones;
    
    timer count_down(.clk(clk), .add1(add1), .add2(add2), .add3(add3), 
                    .add4(add4), .rst1(rst1), .rst2(rst2), .rst(rst), 
                    .counter(counter), .shouldDisplay(shouldDisplay));  
    bcd_vals bcd_display(.counter(counter), .val1(val1), 
                         .val2(val2), .val3(val3), .val4(val4));
    bcd_to_7seg thousand(.val(val4), .led_seg(thousands));
    bcd_to_7seg hundred(.val(val3), .led_seg(hundreds));
    bcd_to_7seg ten(.val(val2), .led_seg(tens));
    bcd_to_7seg one(.val(val1), .led_seg(ones));    
    seven_seg display(.clk(clk), .rst(rst), .shouldDisplay(shouldDisplay),
                      .thousands(thousands), .hundreds(hundreds), 
                      .tens(tens), .ones(ones), 
                      .led_seg(led_seg), .a1(a1), .a2(a2), 
                      .a3(a3), .a4(a4));
endmodule

module timer(
    input clk,
    input add1,
    input add2,
    input add3,
    input add4,
    input rst1,
    input rst2,
    input rst,
    output reg [13:0] counter,
    output reg shouldDisplay
);
    //input clock 100 Hz
    reg [6:0] divide_1hz = 7'd0; //divide by 100 for 1Hz flash
    reg [6:0] one_second = 7'd0; //divide by 100, 1 s for decrementing
   
    // signal hierarchy: rst > rst2 > rst1 > add4 > add3 > add2 > add1 > clk
    always @(posedge clk) begin
        if(rst) begin
            one_second <= 7'd0; //mod100, reset one_second
            divide_1hz <= 7'd0;
            counter <= 14'd0;
            shouldDisplay <= 1'b1;
        end
        else if(rst2 || rst1 || add4 || add3 || add2 || add1) begin
            if(rst2) begin
                counter <= 14'd150;
                shouldDisplay <= 1'b1; //display even #
            end
            else if(rst1) begin
                counter <= 14'd15;
                shouldDisplay <= 1'b0; //odd # so don't display
            end
            else if(add4) begin
                shouldDisplay <= 1'b1;
                if(counter <= 14'd9699)
                    counter <= counter + 14'd300;
                else
                    counter <= 14'd9999; //latch 
            end
            else if(add3) begin
                shouldDisplay <= 1'b1;
                if(counter <= 14'd9819)
                    counter <= counter + 14'd180;
                else
                    counter <= 14'd9999;
            end
            else if(add2) begin
                if(counter <= 14'd9879)
                    counter <= counter + 14'd120;
                else
                    counter <= 14'd9999;
                // even + even = even
                if(counter + 120 >= 14'd180 || counter[0] == 1'b0) 
                    shouldDisplay <= 1'b1;
                else 
                    shouldDisplay <= 1'b0;
            end
            else if(add1) begin
                if(counter <= 14'd9939)
                    counter <= counter + 14'd60;
                else
                    counter <= 14'd9999;
                if(counter + 60 >= 14'd180 || counter[0] == 1'b0) 
                    shouldDisplay <= 1'b1;
                else 
                    shouldDisplay <= 1'b0;
            end
            one_second <= 7'd0; //mod100, reset one second counter
            divide_1hz <= 7'd0;
        end
        else begin //just a regular clock signal
            //decrement counter logic, normal operation
            if(one_second == 7'd99) begin
                // subtract 1 second
                if(counter > 14'd0) begin //time left
                    counter <= counter - 14'd1;
                end
                one_second <= 7'd0; //mod100, reset one_second
            end
            else begin
                one_second <= one_second + 7'd1;
            end
            
            // display logic
            if(counter == 14'd0 || counter > 14'd180) begin
                //flash at 1 Hz
                // always update "counter" to next value and then display or not
                if(divide_1hz == 7'd99) begin
                    divide_1hz <= 7'd0;
                    shouldDisplay <= 1'b1;
                end
                else begin
                    if(divide_1hz == 7'd49) begin
                        shouldDisplay <= 1'b0;
                    end
                    divide_1hz <= divide_1hz + 7'd1;
                end
            end
            else begin
            //flash at 0.5 Hz when time <= 179
                if(divide_1hz == 7'd99) begin
                    divide_1hz <= 7'd0; 
                    //about to turn odd -> even
                    if(counter[0] == 1'b1)shouldDisplay <= 1'b1;
                    else shouldDisplay <= 1'b0;
                end  
                else begin
                    if(divide_1hz == 7'd49 && counter == 14'd180) begin
                        //special for case of 180
                        shouldDisplay <= 1'b0;
                    end
                    divide_1hz <= divide_1hz + 7'd1;
                end
            end
        end
    end
endmodule

module seven_seg(
    input clk,
    input rst,
    input shouldDisplay,
    input [6:0] thousands,
    input [6:0] hundreds,
    input [6:0] tens,
    input [6:0] ones,
    output reg [6:0] led_seg, // [CA, CB, CC, ... CG]
    output a1, //ones
    output a2, //tens
    output a3, //hundreds
    output a4 //thousands
);
    //cycle through the displays rapidly, but only when we should display it
    reg [3:0] anodes;
    assign a1 = anodes[0];
    assign a2 = anodes[1];
    assign a3 = anodes[2];
    assign a4 = anodes[3];
    
    reg [1:0] digToDisplay = 2'd0;

    always @(posedge clk) begin
          if(rst) begin          
            digToDisplay <= 2'd0; 
            led_seg <= 7'b0000001; //digit 0
            anodes <= 4'b0000; //display 0000 until rst button is unpressed
          end
          
          else begin //clk positive but should not display
            if(shouldDisplay) begin   
                case(digToDisplay)
                    2'd0: begin
                        anodes <= 4'b0111;
                        led_seg <= thousands;
                    end
                    2'd1: begin
                        anodes <= 4'b1011;
                        led_seg <= hundreds;
                    end
                    2'd2: begin
                       anodes <= 4'b1101;
                        led_seg <= tens;
                    end
                    default: begin
                        anodes <= 4'b1110;
                        led_seg <= ones;
                    end
                endcase
                digToDisplay <= digToDisplay + 2'd1;   
                end
            else begin
                led_seg <= 7'b1111111;
                anodes <= 4'b1111;
                digToDisplay <= 2'd0;
            end
       end 
    end
endmodule

module bcd_to_7seg(
    input [3:0] val,
    output reg [6:0] led_seg
);
    always @(*) begin
        case(val)
            4'd0: led_seg = 7'b0000001;
            4'd1: led_seg = 7'b1001111;
            4'd2: led_seg = 7'b0010010;
            4'd3: led_seg = 7'b0000110;
            4'd4: led_seg = 7'b1001100;
            4'd5: led_seg = 7'b0100100;
            4'd6: led_seg = 7'b0100000;
            4'd7: led_seg = 7'b0001111;
            4'd8: led_seg = 7'b0000000;
            4'd9: led_seg = 7'b0000100;
            default: led_seg = 7'b1111111;
        endcase
    end
endmodule

module bcd_vals(
    input [13:0] counter,
    output [3:0] val1,
    output [3:0] val2,
    output [3:0] val3,
    output [3:0] val4
);
    reg [31:0] val1_14; //ones
    reg [31:0] val2_14; //tens
    reg [31:0] val3_14; //hundreds
    reg [31:0] val4_14; //thousands

    assign val1 = val1_14[3:0];        
    assign val2 = val2_14[3:0];
    assign val3 = val3_14[3:0];
    assign val4 = val4_14[3:0];
   
    always @(*) begin
        val4_14 = counter / 10'd1000;
        val3_14 = (counter - 10'd1000*val4_14) / 7'd100;
        val2_14 = (counter - (10'd1000*val4_14 + 7'd100*val3_14)) / 4'd10;
        val1_14 = (counter - (10'd1000*val4_14 + 7'd100*val3_14 + 4'd10*val2_14));
    end
endmodule
