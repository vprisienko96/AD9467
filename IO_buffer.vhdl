library IEEE;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library UNISIM;
use UNISIM.vcomponents.all;


entity IO_buffer is 
port(
 clk_125_n         : in std_logic;
 clk_125_p         : in std_logic;
 adc_clk_in_p      : in std_logic;
 adc_clk_in_n      : in std_logic;
 adc_data_or_p     : in std_logic;
 adc_data_or_n     : in std_logic;
 adc_data_in_p     : in std_logic_vector(7 downto 0);
 adc_data_in_n     : in std_logic_vector(7 downto 0);
 clk_125           : out std_logic;
 adc_clk_in        : out std_logic;
 adc_data_or       : out std_logic;
 adc_data_in       : out std_logic_vector(7 downto 0));
 end IO_buffer;
 
 
 
 architecture Behavioral of IO_buffer is

begin

IBUFGDS_clk_125 : IBUFDS
    port map (
      I  => clk_125_p,
      IB => clk_125_n,
      O  => clk_125
    );
	
	
IBUFGDS_adc_clk_in : IBUFDS
    port map (
      I  => adc_clk_in_p,
      IB => adc_clk_in_n,
      O  => adc_clk_in
    );

IBUFGDS_adc_data_or : IBUFDS
    port map (
      I  => adc_data_or_p,
      IB => adc_data_or_n,
      O  => adc_data_or
    );	
	
	
--generate_data_in: for ii in 0 to 7 generate
--IBUFGDS_adc_data_in : IBUFDS
--    port map (
--      I  => adc_data_in_p(ii),
--      IB => adc_data_in_n(ii),
--      O  => adc_data_in(ii)
--    );
-- end generate generate_data_in;


	IBUFGDS_adc_data_in_0 : IBUFDS
    port map (
      I  => adc_data_in_p(0),
      IB => adc_data_in_n(0),
      O  => adc_data_in(0)
    );
    
    IBUFGDS_adc_data_in_1 : IBUFDS
    port map (
      I  => adc_data_in_p(1),
      IB => adc_data_in_n(1),
      O  => adc_data_in(1)
    );
    
    IBUFGDS_adc_data_in_2 : IBUFDS
    port map (
      I  => adc_data_in_p(2),
      IB => adc_data_in_n(2),
      O  => adc_data_in(2)
    );
    
    IBUFGDS_adc_data_in_3 : IBUFDS
    port map (
      I  => adc_data_in_p(3),
      IB => adc_data_in_n(3),
      O  => adc_data_in(3)
    );
    
    IBUFGDS_adc_data_in_4 : IBUFDS
    port map (
      I  => adc_data_in_p(4),
      IB => adc_data_in_n(4),
      O  => adc_data_in(4)
    );
    
    IBUFGDS_adc_data_in_5 : IBUFDS
    port map (
      I  => adc_data_in_p(5),
      IB => adc_data_in_n(5),
      O  => adc_data_in(5)
    );
    
    IBUFGDS_adc_data_in_6 : IBUFDS
    port map (
      I  => adc_data_in_p(6),
      IB => adc_data_in_n(6),
      O  => adc_data_in(6)
    );
    
    IBUFGDS_adc_data_in_7 : IBUFDS
    port map (
      I  => adc_data_in_p(7),
      IB => adc_data_in_n(7),
      O  => adc_data_in(7)
    );
	
end architecture Behavioral; 	