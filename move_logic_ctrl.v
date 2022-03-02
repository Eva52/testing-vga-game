module move_logic_ctrl(
	input							clk,
	input							rst_n,
	input							key_flag1,
	input							key_flag2,
	input							key_flag3,
	input							key_flag4,
	input				[9:0]		vga_xide,
	input				[9:0]		vga_yide,
	
	output	reg	[23:0]		vga_data
	);
	
	reg				[31:0]cnt;
	reg	[9:0]			x;					
	parameter			y = 579;
	reg[9:0]          x2;
	parameter         y2 = 19;			
	reg	[9:0]			vga_x;			
	reg	[9:0]			vga_y;			
	reg					x_direct;		
	reg					y_direct;
	wire	         	move_en;
	
	parameter				T_10ms = 500_000;
	parameter	side = 40;				
	parameter	block = 40;			
	parameter	stick = 100;        
	parameter	vga_xdis = 800;		
	parameter	vga_ydis = 600;	
	
	always @ (posedge clk, negedge rst_n) begin
		if(rst_n == 1'b0)
			cnt<=32'd0;
		else if(cnt < T_10ms - 1)
			cnt<=cnt + 32'd1;
		else
			cnt<=32'd0;
	end
	
	assign move_en = (cnt == T_10ms - 1)? 1'b1:1'b0; 		
	
	always @ (posedge clk, negedge rst_n) begin
		if(rst_n == 1'b0)begin
			vga_x<=10'd100;
			vga_y<=10'd100;
		end
		else if(move_en == 1'b1)begin
				if(x_direct == 1'b0)
					vga_x<=vga_x - 10'd1;
				else 
					vga_x<=vga_x + 10'd1;
				if(y_direct == 1'b0)
					vga_y<=vga_y - 10'd1;
				else 
					vga_y<=vga_y + 10'd1;
		end
	end 
		
	
	always @ (posedge clk, negedge rst_n) begin
		if(rst_n == 1'b0)begin
			x_direct<=1'b0;
			y_direct<=1'b1;
		end
		else
			begin
				if(vga_x == side - 1'd1)	
					x_direct<=1'b1;			
				else	if(vga_x == vga_xdis-side-block-1'd1)	
					x_direct<=1'b0;				
					
				if(vga_y == 10'd599)	
					y_direct<=1'd1;		
				else	if((vga_y==(y-10'd40)) && (vga_x>=x-10'd40) && (vga_x<(x+10'd140)))
					y_direct<=1'b0;
				else	if((vga_y==y2) && (vga_x>=x2-10'd40) && (vga_x<(x2+10'd140)))
					y_direct<=1'b1;		
			end
	end
	
	
	
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
	
	parameter	RED  = 24'b00000000_00000000_11111111;
	parameter	BLUE = 24'b11111111_00000000_00000000;				
	parameter	WHITE = 24'b11111111_11111111_11111111;				
	parameter	GREEN = 24'b00000000_11111111_00000000; 
	parameter	BLACK = 24'b00000000_00000000_00000000; 


	always @ (*) begin
		if(rst_n == 1'b0)
			vga_data<=BLACK;
		else if((vga_xide < side - 1'd1 || vga_xide >= vga_xdis - side - 1'd1))
			vga_data<=RED;
		else if((vga_xide > vga_x && vga_xide <= vga_x + block) && (vga_yide > vga_y && vga_yide <= vga_y + block))
			vga_data<=BLUE;
		else if((vga_xide > x && vga_xide <= x + stick) && vga_yide > y)
			vga_data<=GREEN;
		else if((vga_xide > x2 && vga_xide <= x2 + stick) && vga_yide < y2)
			vga_data<=GREEN;
		else
			vga_data<=WHITE;
	end

endmodule
