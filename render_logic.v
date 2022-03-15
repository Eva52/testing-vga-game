module render_logic(
	input					rst_n,
	input             clk,
	input	[9:0]			x,				
	input [9:0]       x2,
	input	[9:0]			vga_x,			
	input	[9:0]			vga_y,
   input	[9:0]			vga_x2,			
	input	[9:0]			vga_y2,	
	input	[9:0]		   vga_xide,
	input	[9:0]		   vga_yide,
	
	output reg[23:0]	vga_data
	);
	parameter			y = 462;
	parameter         y2 = 137;	
	parameter	side = 40;				
	parameter	block = 40;			
	parameter	stick = 75;        
	parameter	vga_xdis = 800;		
	parameter	vga_ydis = 600;
	parameter	RED  = 24'b00000000_00000000_11111111;
	parameter	BLUE = 24'b11111111_00000000_00000000;				
	parameter	WHITE = 24'b11111111_11111111_11111111;				
	parameter	GREEN = 24'b00000000_11111111_00000000; 
	parameter	BLACK = 24'b00000000_00000000_00000000; 
   reg  [13:0]  addr;
	wire  rden;
	wire	[23:0]  q;
   tank_rom tank_rom_inst(
			.address(addr),
			.clock(clk),
			.rden(rden),
			.q(q)
	);
	wire [15:0] row_num = vga_yide - y - 1;
	wire [15:0] col_num = vga_xide - x;
	wire [15:0] row_num2 = y2-vga_yide;
	wire [15:0] col_num2 = vga_xide - x2;
	assign rden=1'b1;
	always @ (posedge clk, negedge rst_n) begin
		if(rst_n == 1'b0) begin
			vga_data<=BLACK;
			addr <= 11'd0;
		end
		else if((vga_xide < side - 1'd1 || vga_xide >= vga_xdis - side - 1'd1))
			vga_data<=RED;
		else if((vga_xide > vga_x && vga_xide <= vga_x + block) && (vga_yide > vga_y && vga_yide <= vga_y + block))
			vga_data<=BLUE;
		else if((vga_xide > vga_x2 && vga_xide <= vga_x2 + block) && (vga_yide > vga_y2 && vga_yide <= vga_y2 + block))
			vga_data<=BLUE;
		else if((vga_xide > x && vga_xide <= x + stick) && vga_yide > y && vga_yide <= y+137) begin
				addr <= row_num * 74 + col_num+13;
				vga_data <= q;
				/*
					if(addr < 14'd10274)begin
						addr <= addr + 11'd1;	
						vga_data <= q;
					end
					else begin
						addr <= 11'd0;
						vga_data <= q;
					end
					*/
		end
		else if((vga_xide > x2 && vga_xide <= x2 + stick) && vga_yide < y2 && vga_yide >= 1'b0) begin
		   addr <= row_num2 * 74 + col_num2+13;
			vga_data<=q;
		end
		else
			vga_data<=WHITE;
	end
endmodule
