module vga_moveblock (input CLOCK_50, input [3:0] KEY,
             input [9:0] SW, output [9:0] LEDR,
             output [6:0] HEX0, output [6:0] HEX1, output [6:0] HEX2,
             output [6:0] HEX3, output [6:0] HEX4, output [6:0] HEX5,
             output [7:0] VGA_R, output [7:0] VGA_G, output [7:0] VGA_B,
             output VGA_HS, output VGA_VS, output VGA_CLK,
             output [7:0] VGA_X, output [6:0] VGA_Y,
             output [2:0] VGA_COLOUR, output VGA_PLOT);
	
	wire						locked;
	wire			[7:0]		vga_data;
	wire			[9:0]		vga_xide;
	wire			[9:0]		vga_yide;
	wire						key_flag1;
	wire						key_flag2;
	wire						key_flag3;
	wire						key_flag4;
	wire			[10:0]	addr;
	wire			[7:0]		q;
        wire [7:0] vga_rgb;

        assign VGA_R={8{vga_rgb[0]}};
        assign VGA_G={8{vga_rgb[3]}};
		  assign VGA_B={8{vga_rgb[6]}};
        
	vga_pll my_pll_inst(
			.rst(~SW[0]),
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
	
	key_filter key_filter1_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_in(KEY[2]),
			
			.nege_flag(key_flag3)
	);

	key_filter key_filter1_inst(
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
	
	move_logic_ctrl move_logic_ctrl_inst(
			.clk(CLOCK_50),
			.rst_n(locked),
			.key_flag1(key_flag1),
			.key_flag2(key_flag2),
			.key_flag3(key_flag3),
			.key_flag4(key_flag4),
			.vga_xide(vga_xide),
			.vga_yide(vga_yide),
			
			.vga_data(vga_data)
	);
	
endmodule
