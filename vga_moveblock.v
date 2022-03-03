module vga_moveblock (input CLOCK_50, input [3:0] KEY,
             input [9:0] SW, output [9:0] LEDR,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [7:0] VGA_R, output [7:0] VGA_G, output [7:0] VGA_B,
             output VGA_HS, output VGA_VS, output VGA_CLK);
	
	wire						locked;
	wire			[23:0]		vga_data;
	wire			[9:0]		vga_xide;
	wire			[9:0]		vga_yide;
	wire						key_flag1;
	wire						key_flag2;
	wire						key_flag3;
	wire						key_flag4;
   wire [23:0] vga_rgb;
	wire	[9:0]			x;					
	wire  [9:0]       x2;
	wire	[9:0]			vga_x;			
	wire	[9:0]			vga_y;

        assign VGA_R=vga_rgb[7:0];
        assign VGA_G=vga_rgb[15:8];
		  assign VGA_B=vga_rgb[23:16];
        
	vga_pll my_pll_inst(
			.rst(SW[0]),
			.refclk(CLOCK_50),
			.outclk_0(VGA_CLK),
			.locked(locked)
	);
	
	key_filter key_filter1_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_in(KEY[0]),
			
			.nege_flag(key_flag1)
	);
	
	key_filter key_filter2_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_in(KEY[1]),
			
			.nege_flag(key_flag2)
	);
	
	key_filter key_filter3_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_in(KEY[2]),
			
			.nege_flag(key_flag3)
	);

	key_filter key_filter4_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_in(KEY[3]),
			
			.nege_flag(key_flag4)
	);

	vga_ctrl vga_ctrl_inst(
			.clk_40mhz(VGA_CLK),
			.rst_n(locked),
			.vga_data(vga_data),
			
			.vga_xide(vga_xide),
			.vga_yide(vga_yide),
			.vga_hs(VGA_HS),
			.vga_vs(VGA_VS),
			.vga_rgb(vga_rgb)
	);
	
	player_logic player_logic_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_flag1(key_flag1),
			.key_flag2(key_flag2),
			.key_flag3(key_flag3),
			.key_flag4(key_flag4),
			
			.x(x),
			.x2(x2)
	);
	square_logic square_logic_inst(
         .clk(CLOCK_50),
			.rst_n(locked),
			.x(x),
			.x2(x2),
	
	      .vga_x(vga_x),
			.vga_y(vga_y)
	);
	render_logic render_logic_inst(
	      .rst_n(locked),
	      .x(x),
			.x2(x2),
			.vga_x(vga_x),
			.vga_y(vga_y),	
	      .vga_xide(vga_xide),
			.vga_yide(vga_yide),
			.vga_data(vga_data)
	);

endmodule
