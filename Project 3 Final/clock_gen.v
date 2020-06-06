`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:00:54 05/03/2020 
// Design Name: 
// Module Name:    clock_gen 
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
module clock_gen(
    input clk_in,
    input rst,
    output clk_div_2,
    output clk_div_4,
    output clk_div_8,
    output clk_div_16,
    output clk_div_28,
    output clk_div_5,
    output [7:0] glitchy_counter
);
clock_div_two task_one(
	.clk_in	(clk_in),
	.rst	(rst),
	.clk_div_2(clk_div_2),
	.clk_div_4(clk_div_4),
	.clk_div_8(clk_div_8),
	.clk_div_16(clk_div_16)
);
clock_div_twenty_eight task_two(
	.clk_in	(clk_in),
	.rst	(rst),
	.clk_div_28(clk_div_28)
);
clock_div_five task_three(
	.clk_in	(clk_in),
	.rst	(rst),
	.clk_div_5(clk_div_5)
);
clock_strobe task_four(
	.clk_in	(clk_in),
	.rst	(rst),
	.glitchy_counter (glitchy_counter)
);
endmodule

module clock_div_two(
	input clk_in, 
    input rst, 
    output clk_div_2, 
    output clk_div_4, 
    output  clk_div_8, 
    output  clk_div_16
);
    reg [3:0] out;
    assign clk_div_2 = out[0];
    assign clk_div_4 = out[1];
    assign clk_div_8 = out[2];
    assign clk_div_16 = out[3];
    
	always @(posedge clk_in)
		begin
			if(rst) begin
				out <= 4'b0;            
            end
			else begin
				out <= out + 4'b1;
            end         
		end
endmodule

module clock_div_twenty_eight(
	input clk_in, 
    input rst, 
    output reg clk_div_28
);
    reg [3:0] out2;

    // divide by 28
	always @(posedge clk_in)
		begin
			if(rst) begin
				out2 <= 4'b0;
                clk_div_28 <= 1'b0;
            end
            else begin
                if(out2 == 4'b1101) begin
                    clk_div_28 <= ~clk_div_28;
                    out2 <= 4'b0;
                end
                else begin 
                    out2 <= out2 + 4'b1;        
                end
            end
		end    

// //UNCOMMENT THIS FOR divide by 32
//  reg clk_div_32;
//	always @(posedge clk_in)
//		begin
//			if(rst) begin
//				out2 <= 4'b0;
//                clk_div_32 <= 1'b0;
//            end
//            else begin
//                if(out2 == 4'b1111) begin
//                    clk_div_32 <= ~clk_div_32;  
//                end
//                out2 <= out2 + 1'b1;                  
//            end
//		end 
      
endmodule

module clock_div_five (
	input clk_in, 
    input rst, 
    output clk_div_5
    
);

//    // 33% duty cycle => 50% duty cycle divide by 3
//    reg [1:0] out3_pos;
//    reg [1:0] out3_neg;
//    reg clk_33_pos;
//    reg clk_33_neg;
//    wire pos_neg_or;
//    assign pos_neg_or = clk_33_pos | clk_33_neg;
//    
//    always @(posedge clk_in)
//		begin
//			if(rst) begin
//				out3_pos <= 2'b0;
//                clk_33_pos <= 1'b0;
//            end
//            else begin
//                if(out3_pos == 2'b10) begin
//                    clk_33_pos <= 1'b1;
//                    out3_pos <= 2'b0;        
//                end
//                else if(out3_pos == 2'b00) begin
//                    clk_33_pos <= 1'b0;
//                    out3_pos <= out3_pos + 2'b1;        
//                end
//                else begin
//                    out3_pos <= out3_pos + 2'b1;
//                end
//        end
//	end 
//	
//    always @(negedge clk_in)
//		begin
//			if(rst) begin
//				out3_neg <= 2'b0;
//                clk_33_neg <= 1'b0;
//            end
//            else begin
//                if(out3_neg == 2'b10) begin
//                    clk_33_neg <= 1'b1;
//                    out3_neg <= 2'b0;        
//                end
//                else if(out3_neg == 2'b00) begin
//                    clk_33_neg <= 1'b0;
//                    out3_neg <= out3_neg + 2'b1;        
//                end
//                else begin
//                    out3_neg <= out3_neg + 2'b1;
//                end
//        end
//	end 


    // 40% duty cycle => 50% duty cycle divide by 5
    reg [2:0] out3_pos;
    reg [2:0] out3_neg;
    reg clk_40_pos;
    reg clk_40_neg;
    
    assign clk_div_5 = clk_40_pos | clk_40_neg;
    
    always @(posedge clk_in)
		begin
			if(rst) begin
				out3_pos <= 3'b0;
                clk_40_pos <= 1'b0;
            end
            else begin
                if(out3_pos == 3'b100) begin
                    clk_40_pos <= 1'b1;
                    out3_pos <= 3'b0;        
                end
                else if(out3_pos == 3'b001) begin
                    clk_40_pos <= 1'b0;
                    out3_pos <= out3_pos + 3'b1;        
                end
                else begin
                    out3_pos <= out3_pos + 3'b1;
                end
            end
        end 
	
    always @(negedge clk_in)
		begin
			if(rst) begin
				out3_neg <= 3'b0;
                clk_40_neg <= 1'b0;
            end
            else begin
                if(out3_neg == 3'b100) begin
                    clk_40_neg <= 1'b1;
                    out3_neg <= 3'b0;        
                end
                else if(out3_neg == 3'b001) begin
                    clk_40_neg <= 1'b0;
                    out3_neg <= out3_neg + 3'b1;        
                end
                else begin
                    out3_neg <= out3_neg+ 3'b1;
                end
            end
        end        
endmodule

module clock_strobe (
	input clk_in, 
    input rst, 
    output reg [7:0] glitchy_counter
);

//    // divide by 100 @ 1% duty cycle and divide by 200
//    reg divide_by_100;
//    reg divide_by_200;
//    reg [6:0] counter;
//    
//    always @(posedge clk_in) begin
//        if(rst) begin
//            divide_by_100 <= 1'b0;
//            counter <= 7'b0;
//            // divide_by_200 <= 1'b0;
//        end
//        else begin
//            if(counter == 7'b0) begin
//                divide_by_100 <= 1'b0;
//                counter <= counter + 7'b1;
//            end
//            else if(counter == 99) begin
//                divide_by_100 <= 1'b1;
//                counter <= 7'b0;
//                // divide_by_200 <= ~divide_by_200;
//            end
//            else begin
//                counter <= counter + 7'b1;
//            end
//        end
//    end
//    
//    always @(posedge clk_in) begin
//        if(rst) begin
//            divide_by_200 <= 1'b0;
//        end
//        else begin
//            if(divide_by_100 == 1'b1) begin
//                divide_by_200 <= ~divide_by_200;
//            end
//        end    
//    end

    reg [1:0] counter;   
    always @(posedge clk_in) begin
        if(rst) begin
            counter <= 2'b0;
            glitchy_counter <= 8'b0;
        end
        else begin
            if(counter == 2'b11) begin
                glitchy_counter <= glitchy_counter - 8'd5;
                counter <= counter + 1'b1;
            end
            else begin
                glitchy_counter <= glitchy_counter + 8'd2;
                counter <= counter + 1'b1;
            end          
        end
    end  
endmodule
