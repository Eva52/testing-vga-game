module key_filter(
	input					clk,
	input					rst_n,
	input					key_in,

	output				nege_flag
	);

	reg   	[3:0]		current_state;
	reg   	[3:0]		next_state;
	reg		[31:0]	cnt;
	reg 					key_out;
	reg 					key_in_reg1;
	
	always @ (posedge clk)begin
		key_in_reg1 <= key_in;
	end

	parameter			T_10ms = 500_000;
	
	parameter  	s0 = 4'b0001;
	parameter  	s1 = 4'b0010;
	parameter  	s2 = 4'b0100;
	parameter  	s3 = 4'b1000;


	always @ (posedge clk, negedge rst_n)begin
		if(rst_n == 1'b0)
			current_state <= s0;
		else
			current_state <= next_state;
	end 
	
	always @ (*)
		begin
			case(current_state)
				s0	:	begin
							if(key_in_reg1 == 0)
								next_state = s0;
							else 
								next_state = s1;
						end

				s1	:	begin
							if(key_in_reg1 == 1)
								next_state = s1;
							else
								next_state = s0;
						end
				default	:	next_state = s0;
			endcase
		end
		
		always @ (posedge clk, negedge rst_n)begin
			if(rst_n == 1'b0)begin
				cnt <= 32'd0;
				key_out <= 1'b1;
				end
			else
				case(current_state)
					s0	:	begin 
								if(key_in_reg1 == 0)begin
									key_out <= 1'b1;
								end
								else begin
									key_out <= 1'b0;
								end
							end
					s1	:	begin
									key_out <= 1'b1;
							end
					default	:	begin key_out <= 1'b1; cnt <= 32'd0; end
				endcase
		end	
		
		assign nege_flag = ~key_out;
	
endmodule
