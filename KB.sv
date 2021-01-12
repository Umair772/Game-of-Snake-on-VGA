//The keyboard input module
//12/6/2019
//Umair,Abdiasis
module KB (clk,reset,move,direction);
	input logic clk,reset;
	input logic [2:1]move;
	output logic [1:0] direction;
	enum {up,down,left,right} ps,ns;
	parameter UP = 8'h75,DOWN = 8'h72,LEFT = 8'h6B,RIGHT = 8'h74;
	
   //always combination block used to move the snake in differnt directions based on the input data from the keyboard driver.
	always_comb begin
		case(move)
		
			down : begin
					if (move[1]) ns = left;
					 if (move[2]) ns = right;
					 else ns = down;
					 end
					 
			up   : begin
					if (move[1]) ns = left;
			       else if (move[2])  ns = right;
					 else      ns = up;
					 end
					 
		   left : begin
					 if (move[1])  ns = up;
			       else if (move[2])    ns = down;
					 else      ns = left;
					 end
		   right  : begin
						if (move[1])   ns = up;
			         else if (move[2])    ns = down;
						else ns = right;
						end
			default: ns = ps;
		endcase
	end
	
	//Default state is the down state else move to the next state
	always_ff @(posedge clk) begin
		if (reset)
			ps <= down;
		else 
			ps <= ns;
	end
	
	//Based on the state, we specify the direction which is used to drive the head of the snake.
	always_ff @(posedge clk) begin
		if (ps == up) begin
			direction <= 2'b00;
		end
		else if(ps == down) begin
			direction <= 2'b01;
		end
		else if(ps == left) begin
			direction <= 2'b10;
		end
		else if(ps == right) begin
			direction <= 2'b11;
		end
		else
			direction <= direction;
	end
	
endmodule

//Simulating in modelsim
module KB_testbench();
   logic clk,reset;
   logic [2:1]move;
   logic [1:0] direction;
	
	KB dut (.clk,.reset,.move,.direction);
	
	
	parameter CLOCK_PERIOD = 100;
	initial clk = 1;
	always begin
	    #(CLOCK_PERIOD/2);
		 clk = ~clk;
	end
	
	initial begin
	reset <= 0;
	reset <= 1;
	move[1] <= 1; move[2] <= 0; @(posedge clk);
	move[1] <= 0; move[2] <= 1; @(posedge clk);
	move[1] <= 1; move[2] <= 0; @(posedge clk);
	end

endmodule
	
	
	