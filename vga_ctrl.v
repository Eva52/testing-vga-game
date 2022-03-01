module vga_ctrl(
	input							clk_40mhz,
	input							rst_n,
	input					[7:0]	vga_data,
	
	output				[9:0]	vga_xide,
	output				[9:0]	vga_yide,
	output				vga_hs,
	output				vga_vs,
	output				[7:0]	vga_rgb
	);

	//128+88+800+40=1056
	//4+23+600+1=628
	reg				[10:0] 	cnt1;
	reg				[9:0]	 	cnt2;
	reg		valid;

	
	always @ (posedge clk_40mhz, negedge rst_n) begin
		if(rst_n == 1'b0)
			cnt1 <= 11'd0;
		else if(cnt1 < 11'd1055)
			cnt1 <= cnt1 + 11'd1;
		else 
			cnt1 <= 11'd0;
	end

	
	always @ (posedge clk_40mhz, negedge rst_n) begin
		if(rst_n == 1'b0)
			cnt2 <= 10'd0;
		else if(cnt1 == 11'd1055 && cnt2 < 10'd627)
			cnt2 <= cnt2 + 10'd1;
		else if(cnt2 == 10'd627)
			cnt2 <= 10'd0;
	end
	
	
	assign vga_hs=(cnt1 < 11'd128)? 1'b0:1'b1;
	
	assign vga_vs=(cnt2<10'd4)? 1'b0:1'b1;

		
	always @ (*)	begin
		if(rst_n == 1'b0)
			valid = 1'b0;
		else	if((cnt1 >= 11'd215 && cnt1 < 11'd1015) && (cnt2 >= 10'd27 && cnt2 < 10'd627))
			valid = 1'b1;					
		else
			valid = 1'b0;					
	end
	
	assign vga_xide = (valid == 1'b1) ? (cnt1 - 11'd216) : 10'd0; 
	
	assign vga_yide = (valid == 1'b1) ? (cnt2 - 11'd27) : 10'd0; 
	
	assign vga_rgb = (cnt1 >= 11'd216 && cnt1 < 11'd1016) && (cnt2 >= 10'd27 && cnt2 < 10'd627) ? vga_data : 8'h0; 

endmodule
