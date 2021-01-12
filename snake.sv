//Umair Liaqat,Abdiasis
//12/6/2019
module snake(clk,update,reset,apple,x,y,start,direction,good_collision,gameOver,snakeHead,snakeBody,border);
	//Declaring input, output and logics
	input logic clk,reset,start,update;
	input logic [7:0]apple;
	input logic [9:0]x;
	input logic [8:0]y;
	input logic [1:0]direction;
	output logic good_collision,gameOver;
	output logic [7:0]snakeHead,snakeBody,border;
   reg [9:0] snakeX[0:127];
   reg [8:0] snakeY[0:127];
   reg [9:0] snakeHeadX;
   reg [9:0] snakeHeadY;
	reg [6:0] size;
	reg [7:0]lethal,nonLethal;
	reg [7:0]found;
	integer body2,body,position;
	
	
	//flip flop resposible for generating pixels on the screen when the snakes eats an apple
	always_ff @(posedge clk) begin
		found = 0;
		for(body2 = 1; body2 < size; body2++) begin
			if(~found) begin
				snakeBody = ((x > snakeX[body2] && x < snakeX[body2]+10) && (y > snakeY[body2] && y < snakeY[body2]+10));
	         found = snakeBody;
			end
		end
	end
	 
	//Generating a border
	always_ff @(posedge clk)
	begin
		border <= (((x >= 0) && (x < 11) || (x >= 630) && (x < 641)) || ((y >= 0) && (y < 11) || (y >= 470) && (y < 481)));
	end
	
	//The flip flop works like a LFSR, by shifting each pixel to the old pixel location.
	always_ff @(posedge update) begin
		if(start) begin
			for(body = 127; body > 0; body--) begin
				if(body <= size - 1) begin
					snakeX[body] = snakeX[body - 1];
					snakeY[body] = snakeY[body - 1];
				end
			end
		end
		//Not start case
		else if(~start) begin
			for(position = 1; position < 128; position++) begin
				snakeX[position] = 700;
				snakeY[position] = 500;
			end
		end
	end
	
	//Tracking the snakeHead on the monitor
	always_ff @(posedge clk) begin
		snakeHead = (x > snakeX[0] && x < (snakeX[0]+10)) && (y > snakeY[0] && y < (snakeY[0]+10));
   end
	
	//assigning the lethal and nonLethal, lethal contact being the snake head and the border or the body.
	assign lethal = border || snakeBody;
	assign nonLethal = apple;
	
	//flip flop responsible for the storing the size and good_collsion variables.
	always_ff @(posedge clk) begin
		if(nonLethal && snakeHead) begin
			good_collision <= 1'b1;
			size++;
		end
		else if (~start) 
			size = 1;
		else 
			good_collision <= 1'b0;
	end
	
	//flip flop responsible for storing the gameOver variable
	always_ff @(posedge clk) begin
		if(lethal && snakeHead)
			gameOver <= 1'b1;
		else
			gameOver <= 1'b0;
	end
	
	//combinational block responsible for changing the direction of the snake head based on the direction from the direction module.
	always_comb begin
		case(direction)
			2'b01:begin snakeY[0] = (snakeY[0] - 10); end
			2'b10:begin snakeX[0] = (snakeX[0] - 10); end
			2'b00:begin snakeX[0] = (snakeY[0] + 10); end
			2'b11:begin snakeY[0] = (snakeX[0] + 10); end
		endcase
	end

endmodule

//simulating in modelsim
module snake_testbench();
   logic CLOCK_50,reset,start;
   logic [7:0]apple;
   logic [9:0]x;
   logic [8:0]y;
   logic [1:0]direction;
   logic good_collision,gameOver;
   logic [7:0]snakeHead,snakeBody,border;
   reg [9:0] snakeX[0:127];
   reg [8:0] snakeY[0:127];
   reg [9:0] snakeHeadX;
   reg [9:0] snakeHeadY;
	reg [6:0] size;
	reg [7:0]lethal,nonLethal;
	reg [7:0]found;
	integer body2,body,position;
	
	
	snake dut (CLOCK_50,reset,apple,x,y,start,direction,good_collision,gameOver,snakeHead,snakeBody,border);
	
  parameter CLOCK_PERIOD = 100;
	initial clk = 1;
	always begin
	    #(CLOCK_PERIOD/2);
		 clk = ~clk;
	end
	
	initial begin
	reset <= 1;                @(posedge clk);
	reset <= 0;                @(posedge clk);
	apple <= 8'b11111111;      @(posedge clk);
	direction <= 2'b10; 			@(posedge clk);
										@(posedge clk);
	direction <= 2'b11;        @(posedge clk);
	                           @(posedge clk);
	x <= 10'd30;               @(posedge clk);
	                           @(posedge clk);
										@(posedge clk);
   
	
	
endmodule 
		
				
		