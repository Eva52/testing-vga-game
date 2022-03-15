module player_logic(
	input							clk,
	input							rst_n,
	input							key_flag1,
	input							key_flag2,
	input							key_flag3,
	input							key_flag4,
	
	output	reg[9:0]			x,				
	output   reg[9:0]       x2
	);
	
	
	parameter	side = 40;				
	parameter	block = 40;			
	parameter	stick = 75;        
	parameter	vga_xdis = 800;		
	parameter	vga_ydis = 600;	
	parameter	y = 462;
	parameter   y2 = 136;	
	
	always @ (posedge clk, negedge rst_n)begin
		if(rst_n == 1'b0)
			x<=10'd349;
		else if(key_flag1 && !key_flag2)begin
				if(x < vga_xdis-stick-side-1'd1)
					x<=x+10'd20;
				else
					x<=side-1'd1;
				end
		else if(key_flag2 && !key_flag1)begin
				if(x>side)
					x<=x-10'd20;
				else
					x<=vga_xdis-side-stick-1'd1;
				end		
	end

	always @ (posedge clk, negedge rst_n)begin
		if(rst_n == 1'b0)
			x2<=10'd349;
		else if(key_flag3 && !key_flag4)begin
				if(x2<vga_xdis-stick-side-1'd1)
					x2<=x2+10'd20;
				else
					x2<=side-1'd1;
				end
		else if(key_flag4 && !key_flag3)begin
				if(x2 > side)
					x2<=x2-10'd20;
				else
					x2<=vga_xdis-side-stick-1'd1;
				end		
	end
	

endmodule
