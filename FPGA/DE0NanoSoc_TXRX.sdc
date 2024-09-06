#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period "50.0 MHz" [get_ports FPGA_CLK1_50]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK2_50]
create_clock -period "50.0 MHz" [get_ports FPGA_CLK3_50]

create_clock -name {Deserializer:ID3|clock} -period 160
create_clock -name {Divider4:ID_CLK25|sig} -period 80.000 [get_registers {Divider4:ID_CLK25|sig}]

#100MHz /16 /4 -> 10ns*16*4
create_clock -name {clk3} -period 640.000 [get_registers clk3]
create_clock -name {Deserializer:ID3|store_strobe} -period 160 [get_registers {Deserializer:ID3|store_strobe}]

create_clock -name {Deserializer:ID3|Divider8Shift:ID_CLKOUT_D2|sig} -period 160.000  [get_registers {Deserializer:ID3|Divider8Shift:ID_CLKOUT_D2|sig}]
create_clock -name {Deserializer:ID3|Divider2:ID_CO3|sig} -period 320.000 [get_registers {Deserializer:ID3|Divider2:ID_CO3|sig}]
create_clock -name {Divider8:ID_DIV4_RECV|sig} -period 160.000 [get_registers {Divider8:ID_DIV4_RECV|sig}]
create_clock -name {Divider8:ID_DIV4_SEND|sig} -period 160.000 [get_registers {Divider8:ID_DIV4_SEND|sig}]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck 3 [get_ports altera_reserved_tdo]

#**************************************************************
# Create Generated Clock
#**************************************************************

#create_clock -period 20.000 -name FPGA_CLK2_50 [get_ports {FPGA_CLK2_50}]
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



