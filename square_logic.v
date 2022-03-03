module square_logic(
   input							clk,
	input							rst_n,
	input	[9:0]			      x,				
	input [9:0]             x2,
	
	output	reg[9:0]			vga_x,			
	output	reg[9:0]			vga_y
	);
	reg	[31:0]      cnt;			
	reg					x_direct;		
	reg					y_direct;
	wire	         	move_en;
	
	parameter	T_10ms = 500_000;
	parameter	side = 40;				
	parameter	block = 40;			
	parameter	stick = 100;        
	parameter	vga_xdis = 800;		
	parameter	vga_ydis = 600;	
	parameter	y = 579;
	parameter   y2 = 19;	
	
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
	
endmodule
