module vga_ctrl(
	input							clk_40mhz,
	input							rst_n,
	input					[7:0]	vga_data,
	
	output				[9:0]	vga_xide,
	output				[9:0]	vga_yide,
	output	reg				vga_hs,
	output	reg				vga_vs,
	output				[7:0]	vga_rgb
	);

	reg				[10:0] 	cnt1;
	reg				[9:0]	 	cnt2;

	
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
		else if(cnt2 < 10'd627)
			cnt2 <= cnt2;
		else
			cnt2 <= 10'd0;
	end
	
	
	always @ (*) begin
		if(rst_n == 1'b0)
			vga_hs = 1'b1;
		if(cnt1 >= 11'd0 && cnt1 < 11'd128)
			vga_hs = 1'b0;
		else
			vga_hs = 1'b1;
	end
	
	
	always @ (*) begin
		if(rst_n == 1'b0)
			vga_vs = 1'b1;
		else if(cnt2 >= 10'd0 && cnt2 < 10'd4)
			vga_vs = 1'b0;
		else 
			vga_vs = 1'b1;
	end

	reg		valid;
		
	always @ (*)	begin
		if(rst_n == 1'b0)
			valid = 1'b0;
		else	if((cnt1 >= 11'd216 && cnt1 < 11'd1016) && (cnt2 >= 10'd27 && cnt2 < 10'd627))
			valid = 1'b1;					
		else
			valid = 1'b0;					
	end
	
	assign vga_xide = (valid == 1'b1) ? (cnt1 - 11'd216) : 10'd0; 
	
	assign vga_yide = (valid == 1'b1) ? (cnt2 - 11'd27) : 10'd0; 
	
	assign vga_rgb = (valid == 1'b1) ? vga_data : 8'h0; 

endmodule
