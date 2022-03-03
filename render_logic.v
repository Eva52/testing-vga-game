module render_logic(
	input					rst_n,
	input	[9:0]			x,				
	input [9:0]       x2,
	input	[9:0]			vga_x,			
	input	[9:0]			vga_y,	
	input	[9:0]		   vga_xide,
	input	[9:0]		   vga_yide,
	
	output reg[23:0]	vga_data
	);
	parameter			y = 579;
	parameter         y2 = 19;	
	parameter	side = 40;				
	parameter	block = 40;			
	parameter	stick = 100;        
	parameter	vga_xdis = 800;		
	parameter	vga_ydis = 600;
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
