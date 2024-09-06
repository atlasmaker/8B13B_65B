	component ClockBridge is
		port (
			clock_bridge_0_in_clk_clk    : in  std_logic := 'X'; -- clk
			clock_bridge_0_out_clk_clk   : out std_logic;        -- clk
			clock_bridge_0_out_clk_1_clk : out std_logic;        -- clk
			clock_bridge_0_out_clk_2_clk : out std_logic;        -- clk
			clock_bridge_0_out_clk_3_clk : out std_logic;        -- clk
			clock_bridge_1_out_clk_clk   : out std_logic;        -- clk
			clock_bridge_1_out_clk_1_clk : out std_logic;        -- clk
			clock_bridge_1_out_clk_2_clk : out std_logic;        -- clk
			clock_bridge_1_out_clk_3_clk : out std_logic;        -- clk
			pll_0_locked_export          : out std_logic;        -- export
			pll_0_refclk_clk             : in  std_logic := 'X'; -- clk
			pll_0_reset_reset            : in  std_logic := 'X'; -- reset
			clock_bridge_2_in_clk_clk    : in  std_logic := 'X'; -- clk
			clock_bridge_2_out_clk_clk   : out std_logic         -- clk
		);
	end component ClockBridge;

	u0 : component ClockBridge
		port map (
			clock_bridge_0_in_clk_clk    => CONNECTED_TO_clock_bridge_0_in_clk_clk,    --    clock_bridge_0_in_clk.clk
			clock_bridge_0_out_clk_clk   => CONNECTED_TO_clock_bridge_0_out_clk_clk,   --   clock_bridge_0_out_clk.clk
			clock_bridge_0_out_clk_1_clk => CONNECTED_TO_clock_bridge_0_out_clk_1_clk, -- clock_bridge_0_out_clk_1.clk
			clock_bridge_0_out_clk_2_clk => CONNECTED_TO_clock_bridge_0_out_clk_2_clk, -- clock_bridge_0_out_clk_2.clk
			clock_bridge_0_out_clk_3_clk => CONNECTED_TO_clock_bridge_0_out_clk_3_clk, -- clock_bridge_0_out_clk_3.clk
			clock_bridge_1_out_clk_clk   => CONNECTED_TO_clock_bridge_1_out_clk_clk,   --   clock_bridge_1_out_clk.clk
			clock_bridge_1_out_clk_1_clk => CONNECTED_TO_clock_bridge_1_out_clk_1_clk, -- clock_bridge_1_out_clk_1.clk
			clock_bridge_1_out_clk_2_clk => CONNECTED_TO_clock_bridge_1_out_clk_2_clk, -- clock_bridge_1_out_clk_2.clk
			clock_bridge_1_out_clk_3_clk => CONNECTED_TO_clock_bridge_1_out_clk_3_clk, -- clock_bridge_1_out_clk_3.clk
			pll_0_locked_export          => CONNECTED_TO_pll_0_locked_export,          --             pll_0_locked.export
			pll_0_refclk_clk             => CONNECTED_TO_pll_0_refclk_clk,             --             pll_0_refclk.clk
			pll_0_reset_reset            => CONNECTED_TO_pll_0_reset_reset,            --              pll_0_reset.reset
			clock_bridge_2_in_clk_clk    => CONNECTED_TO_clock_bridge_2_in_clk_clk,    --    clock_bridge_2_in_clk.clk
			clock_bridge_2_out_clk_clk   => CONNECTED_TO_clock_bridge_2_out_clk_clk    --   clock_bridge_2_out_clk.clk
		);

