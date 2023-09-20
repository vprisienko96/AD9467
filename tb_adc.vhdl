library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity tb_adc is
end tb_adc;

architecture TB_ARCHITECTURE of tb_adc is


component AD9567_top is 
	Port(
		reset             : in std_logic := '0'; 
		clk_125_n         : in std_logic := '0';
		clk_125_p         : in std_logic := '0';
		uart_txd          : out std_logic; 
		uart_rxd          : in std_logic := '0';
		up_status         : out std_logic_vector(7 downto 0);
		adc_clk_in_p      : in std_logic := '0';
		adc_clk_in_n      : in std_logic := '0';
		adc_data_or_p     : in std_logic := '0';
		adc_data_or_n     : in std_logic := '0';
		adc_data_in_p     : in std_logic_vector(7 downto 0);
		adc_data_in_n     : in std_logic_vector(7 downto 0);
		ad9517_csn        : out std_logic;
		spi_csn           : out std_logic;
		spi_clk           : out std_logic;
		spi_sdio          : inout std_logic);
end component;


 signal  clk_125           : std_logic;
 signal  adc_clk_in        : std_logic;
 signal  adc_data_or       : std_logic := '0';
 signal  adc_data_in       : std_logic_vector(7 downto 0) := x"00"; 
 signal  spi_sdio          : std_logic;
 signal  spi_csn           : std_logic;
 signal  reset             :  std_logic; 
 signal	 clk_125_n         :  std_logic;
 signal	 clk_125_p         :  std_logic;
 signal	 uart_txd          :  std_logic; 
 signal	 uart_rxd          :  std_logic;
 signal	 up_status         :  std_logic_vector(7 downto 0);
 signal	 adc_clk_in_p      :  std_logic;
 signal	 adc_clk_in_n      :  std_logic;
 signal	 adc_data_or_p     :  std_logic;
 signal	 adc_data_or_n     :  std_logic;
 signal	 adc_data_in_p     :  std_logic_vector(7 downto 0);
 signal	 adc_data_in_n     :  std_logic_vector(7 downto 0);
 signal	 ad9517_csn        :  std_logic;
 signal	 spi_clk           :  std_logic;
 constant T                : time := 8 ns;
 constant R                : time := 10 ns;

 
 
 begin
 
 -- Clock 125 MHz 
 
 process
    begin
    clk_125 <= '0';
    wait for T/2;
    clk_125 <= '1';
    wait for T/2;
 end process; 
   
 reset <= '1', '0' after T/2;
 
 -- Clock 100 MHz
 
 process
    begin
    adc_clk_in <= '0';
    wait for R/2;
    adc_clk_in <= '1';
    wait for R/2;
 end process; 
 

 
 U0 : AD9567_top 
	port map(
		reset           => reset,
	    clk_125_n       => clk_125_n,
        clk_125_p       => clk_125_p,
        uart_txd        => open,
        uart_rxd        => '0',
        up_status       => up_status,
        adc_clk_in_p    => adc_clk_in_p,
        adc_clk_in_n    => adc_clk_in_n,
        adc_data_or_p   => adc_data_or_p,
        adc_data_or_n   => adc_data_or_n,
        adc_data_in_p   => adc_data_in_p,
        adc_data_in_n   => adc_data_in_n,
        ad9517_csn      => ad9517_csn,
        spi_csn         => spi_csn,
        spi_clk         => spi_clk,
        spi_sdio        => spi_sdio);
		
		
	OBUFDS_clk_125 : OBUFDS
      port map(
        I   => clk_125,
        O   => clk_125_p,
        OB  => clk_125_n
      );
	  
	OBUFDS_adc_clk_in : OBUFDS
      port map(
        I   => adc_clk_in,
        O   => adc_clk_in_p,
        OB  => adc_clk_in_n
      ); 

	OBUFDS_adc_data_or : OBUFDS
      port map(
        I   => adc_data_or,
        O   => adc_data_or_p,
        OB  => adc_data_or_n
      );  
	  
	OBUFDS_adc_data_in_0 : OBUFDS
      port map(
        I   => adc_data_in(0),
        O   => adc_data_in_p(0),
        OB  => adc_data_in_n(0)
      ); 

	OBUFDS_adc_data_in_1 : OBUFDS
      port map(
        I   => adc_data_in(1),
        O   => adc_data_in_p(1),
        OB  => adc_data_in_n(1)
      );

	OBUFDS_adc_data_in_2 : OBUFDS
      port map(
        I   => adc_data_in(2),
        O   => adc_data_in_p(2),
        OB  => adc_data_in_n(2)
      );

	OBUFDS_adc_data_in_3 : OBUFDS
      port map(
        I   => adc_data_in(3),
        O   => adc_data_in_p(3),
        OB  => adc_data_in_n(3)
      );

	OBUFDS_adc_data_in_4 : OBUFDS
      port map(
        I   => adc_data_in(4),
        O   => adc_data_in_p(4),
        OB  => adc_data_in_n(4)
      );

	OBUFDS_adc_data_in_5 : OBUFDS
      port map(
        I   => adc_data_in(5),
        O   => adc_data_in_p(5),
        OB  => adc_data_in_n(5)
      );

	OBUFDS_adc_data_in_6 : OBUFDS
      port map(
        I   => adc_data_in(6),
        O   => adc_data_in_p(6),
        OB  => adc_data_in_n(6)
      );

	OBUFDS_adc_data_in_7 : OBUFDS
      port map(
        I   => adc_data_in(7),
        O   => adc_data_in_p(7),
        OB  => adc_data_in_n(7)
      );
    
    -- Generate input data 
	
     process(adc_clk_in)
     begin
     if (rising_edge(adc_clk_in)) then
        if reset = '1' then
            adc_data_in <= "00000000";  
        elsif reset = '0' then
            adc_data_in <= adc_data_in + 1;
        end if;
        end if;
     end process; 
     
	-- Generate out of range flag
	
     process(adc_clk_in, adc_data_in)
     begin
       if (rising_edge(adc_clk_in)) then
          if reset = '1' then
            adc_data_or <= '0';
          elsif  adc_data_in = "00101000" then  
            adc_data_or <= '1';
          else 
            adc_data_or <= '0';
         end if;
        end if;
     end process;        
           


	  
  end TB_ARCHITECTURE;

	  
	  
	  