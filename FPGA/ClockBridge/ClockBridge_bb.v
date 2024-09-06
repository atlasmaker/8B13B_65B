
module ClockBridge (
	clock_bridge_0_in_clk_clk,
	clock_bridge_0_out_clk_clk,
	clock_bridge_0_out_clk_1_clk,
	clock_bridge_0_out_clk_2_clk,
	clock_bridge_0_out_clk_3_clk,
	clock_bridge_1_out_clk_clk,
	clock_bridge_1_out_clk_1_clk,
	clock_bridge_1_out_clk_2_clk,
	clock_bridge_1_out_clk_3_clk,
	pll_0_locked_export,
	pll_0_refclk_clk,
	pll_0_reset_reset,
	clock_bridge_2_in_clk_clk,
	clock_bridge_2_out_clk_clk);	

	input		clock_bridge_0_in_clk_clk;
	output		clock_bridge_0_out_clk_clk;
	output		clock_bridge_0_out_clk_1_clk;
	output		clock_bridge_0_out_clk_2_clk;
	output		clock_bridge_0_out_clk_3_clk;
	output		clock_bridge_1_out_clk_clk;
	output		clock_bridge_1_out_clk_1_clk;
	output		clock_bridge_1_out_clk_2_clk;
	output		clock_bridge_1_out_clk_3_clk;
	output		pll_0_locked_export;
	input		pll_0_refclk_clk;
	input		pll_0_reset_reset;
	input		clock_bridge_2_in_clk_clk;
	output		clock_bridge_2_out_clk_clk;
endmodule
