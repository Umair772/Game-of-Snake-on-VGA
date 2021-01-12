// It instantiates all modules
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW,
					 CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	
	// Given logics that come with the VGA. 
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
   
	logic [7:0]apple; // 8- bit apple
	logic VGA_clk,update;
	logic goodCol,gameOver; // when game is over or there is a collission between snake and an apple
	logic [7:0]head,body,border; // the border for which the snake can stay within, its body and head
	logic [1:0]direc; // it has four directions
	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	logic [7:0] outCode;
	logic PS2_CLK;
	logic PS2_DAT;
	logic valid;
	logic makeBreak;
	
	// Instantiation of submodules
	generateAppleCoordinates generateApple (.CLOCK_50,.x,.y,.start(SW[0]),.reset(SW[9]),.good_collision(~KEY[0]||goodCol),.apple(apple));
	updateClk(.VGA_CLK, .update(update));
	clk_reduce(.VGA_CLK, .updatedCLK(updatedCLK));
	KB keys (.clk(updatedCLK),.reset(SW[9]),.move(KEY[2:1]),.direction(direc));
	snake game (.clk(updatedCLK),.update,.reset(SW[9]),.apple(apple),.x,.y,.start(SW[0]),.direction(direc),.good_collision(goodCol),.gameOver,.snakeHead(head),.snakeBody(body),.border(border));
	
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
			 
	 keyboard_press_driver(
		 .CLOCK_50(CLOCK_50), 
		.valid(valid), .makeBreak(makeBreak),
		.outCode(outCode),
		  .PS2_DAT(PS2_DAT), // PS2 data line
			.PS2_CLK(PS2_CLK), // PS2 clock line
		.reset(SW[9])
	);
	// Apple should be red, head and the body should be green
	always_ff @(posedge VGA_CLK) begin
		if (apple)begin
			r <= 8'b11111111;
		end
		if (head || body)begin
			g <= 8'b11111111;
			b <= 8'd0;
		end
		else begin
			r <= 8'd0;
			g <= 8'd0;
			b <= 8'd0;
		end
	end
		
		
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign reset = 0;
	
endmodule
/*
 module clock_divider (VGA_CLK, dividedClocks);
	input logic VGA_CLK;
	output logic [31:0] dividedClocks;
	initial begin
	dividedClocks <= 0;
   end
	
	always_ff @(posedge VGA_CLK) begin
		dividedClocks <= dividedClocks + 1;
	end
 endmodule
*/

//Simulating in modelsim
module DE1_SoC_testbench(); 


	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	// Given logics that come with the VGA. I didn't touch it
	logic CLOCK_50;
	logic[7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic  VGA_VS;
	
	
	DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	
	parameter CLOCK_PERIOD = 100;
	initial CLOCK_50 = 1;
	always begin
	    #(CLOCK_PERIOD/2);
		 CLOCK_50 = ~CLOCK_50;
	end
	
	initial begin
	reset <= 1;       @(posedge CLOCK_50);
	reset <= 0;					@(posedge CLOCK_50);
	KEY[2] <= 1;  						@(posedge CLOCK_50);
	 						@(posedge CLOCK_50);
							@(posedge CLOCK_50);
	KEY[2] <= 0;						@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
  KEY[1] <= 0;							@(posedge CLOCK_50);
  							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
  KEY[1] <= 1;							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
							@(posedge CLOCK_50);
  $stop();
  end
 endmodule