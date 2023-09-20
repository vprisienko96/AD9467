# User Clock - 125 MHz
create_clock -period 8.00 -name clk_125 [get_ports clk_125_p ];

# System Clock 100 MHz
create_clock -period 10.00 -name adc_clk_in [get_ports adc_clk_in_p];