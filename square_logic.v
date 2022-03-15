module square_logic(
   input							clk,
	input							rst_n,
	input	[9:0]			      x,				
	input [9:0]             x2,
	
	output	reg[9:0]			vga_x,			
	output	reg[9:0]			vga_y,
	output	reg[9:0]			vga_x2,			
	output	reg[9:0]			vga_y2
	);
	reg	[31:0]      cnt;			
	reg					x_direct;		
	reg					y_direct;
	wire	         	move_en;
	
	parameter	T_10ms = 500_000;
	parameter	side = 40;				
	parameter	block = 40;			
	parameter	stick = 75;        
	parameter	vga_xdis = 800;		
	parameter	vga_ydis = 600;	
	parameter	y = 462;
	parameter   y2 = 136;	
	
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
			vga_x<=10'd379;
			vga_y<=10'd420;
		end
		else if(move_en == 1'b1)begin
				if((vga_x>=x2-10'd40 && vga_x<(x2+10'd115) && vga_y == y2) || vga_y == 1'b0) begin
					vga_x<=x+17;
					vga_y<=10'd420;
				end
				else 
					vga_y<=vga_y - 10'd1;
		end
	end 
	
	always @ (posedge clk, negedge rst_n) begin
		if(rst_n == 1'b0)begin
			vga_x2<=10'd379;
			vga_y2<=10'd140;
		end
		else if(move_en == 1'b1)begin
				if((vga_x2>=x-10'd40 && vga_x2<(x+10'd115) && vga_y2 == y-side) || vga_y2 == vga_ydis-side) begin
					vga_x2<=x2+17;
					vga_y2<=10'd140;
				end
				else 
					vga_y2<=vga_y2 + 10'd1;
		end
	end 
	
endmodule
