// ClockBridge.v

// Generated using ACDS version 23.1 991

`timescale 1 ps / 1 ps
module ClockBridge (
		input  wire  clock_bridge_0_in_clk_clk,    //    clock_bridge_0_in_clk.clk
		output wire  clock_bridge_0_out_clk_clk,   //   clock_bridge_0_out_clk.clk
		output wire  clock_bridge_0_out_clk_1_clk, // clock_bridge_0_out_clk_1.clk
		output wire  clock_bridge_0_out_clk_2_clk, // clock_bridge_0_out_clk_2.clk
		output wire  clock_bridge_0_out_clk_3_clk, // clock_bridge_0_out_clk_3.clk
		output wire  clock_bridge_1_out_clk_clk,   //   clock_bridge_1_out_clk.clk
		output wire  clock_bridge_1_out_clk_1_clk, // clock_bridge_1_out_clk_1.clk
		output wire  clock_bridge_1_out_clk_2_clk, // clock_bridge_1_out_clk_2.clk
		output wire  clock_bridge_1_out_clk_3_clk, // clock_bridge_1_out_clk_3.clk
		input  wire  clock_bridge_2_in_clk_clk,    //    clock_bridge_2_in_clk.clk
		output wire  clock_bridge_2_out_clk_clk,   //   clock_bridge_2_out_clk.clk
		output wire  pll_0_locked_export,          //             pll_0_locked.export
		input  wire  pll_0_refclk_clk,             //             pll_0_refclk.clk
		input  wire  pll_0_reset_reset             //              pll_0_reset.reset
	);

	ClockBridge_pll_0 pll_0 (
		.refclk   (pll_0_refclk_clk),             //  refclk.clk
		.rst      (pll_0_reset_reset),            //   reset.reset
		.outclk_0 (clock_bridge_1_out_clk_1_clk), // outclk0.clk
		.locked   (pll_0_locked_export)           //  locked.export
	);

	assign clock_bridge_0_out_clk_1_clk = clock_bridge_0_in_clk_clk;

	assign clock_bridge_0_out_clk_2_clk = clock_bridge_0_in_clk_clk;

	assign clock_bridge_0_out_clk_3_clk = clock_bridge_0_in_clk_clk;

	assign clock_bridge_0_out_clk_clk = clock_bridge_0_in_clk_clk;

	assign clock_bridge_2_out_clk_clk = clock_bridge_2_in_clk_clk;

	assign clock_bridge_1_out_clk_2_clk = clock_bridge_1_out_clk_1_clk;

	assign clock_bridge_1_out_clk_3_clk = clock_bridge_1_out_clk_1_clk;

	assign clock_bridge_1_out_clk_clk = clock_bridge_1_out_clk_1_clk;

endmodule
