library IEEE;
use ieee.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;



entity AD9567_top is 
	Port(
		reset             : in std_logic; 
		clk_125_n         : in std_logic;
		clk_125_p         : in std_logic;
		uart_txd          : out std_logic; 
		uart_rxd          : in std_logic;
		up_status         : out std_logic_vector(7 downto 0);
		adc_clk_in_p      : in std_logic;
		adc_clk_in_n      : in std_logic;
		adc_data_or_p     : in std_logic;
		adc_data_or_n     : in std_logic;
		adc_data_in_p     : in std_logic_vector(7 downto 0);
		adc_data_in_n     : in std_logic_vector(7 downto 0);
		ad9517_csn        : out std_logic;
		spi_csn           : out std_logic;
		spi_clk           : out std_logic;
		spi_sdio          : inout std_logic);
end AD9567_top;
 

architecture Behavioral of AD9567_top is

component IO_buffer is 
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
end component; 
 
 
 
component fifo_512x8
  port (
		wr_clk            : in std_logic;
        rd_clk            : in std_logic;
		srst              : in std_logic;
		din               : in std_logic_vector(7 downto 0);
		wr_en             : in std_logic;
		rd_en             : in std_logic;
		dout              : out std_logic_vector(7 downto 0);
		full              : out std_logic;
		empty             : out std_logic;
		wr_rst_busy       : out std_logic;
		rd_rst_busy       : out std_logic
  );
end component;

component fifo_512x6
  port (
       wr_clk            : in std_logic;
       rd_clk            : in std_logic;
       srst               : in std_logic;
       din                : in std_logic_vector(5 downto 0);
       wr_en              : in std_logic;
       rd_en              : in std_logic;
       dout               : out std_logic_vector(5 downto 0);
       full               : out std_logic;
       empty              : out std_logic;
       wr_rst_busy        : out std_logic;
       rd_rst_busy        : out std_logic
  );
end component;

component ram_8x64
  port (
        a                 : in std_logic_vector(5 downto 0);
        d                 : in std_logic_vector(7 downto 0);
        clk               : in std_logic;
        we                : in std_logic;
        spo               : out std_logic_vector(7 downto 0)
  );
end component;
 
 signal  clk_125            : std_logic;
 signal  adc_clk_in         : std_logic;
 signal  adc_data_or        : std_logic;
 signal  adc_data_in        : std_logic_vector(7 downto 0);
 signal  reset_sync         : std_logic := '0' ;
 signal  reset_sync_i       : std_logic := '0';
 signal  wr_en_fifo         : std_logic := '0';
 signal  wr_en_ram_fifo     : std_logic := '0';
 signal  rd_en_fifo         : std_logic := '0';
 signal  full               : std_logic;
 signal  full_i             : std_logic;
 signal  empty              : std_logic;
 signal  empty_i            : std_logic;
 signal  adc_data_out       : std_logic_vector(7 downto 0);
 signal  data_ram_out       : std_logic_vector(7 downto 0);
 signal  we_ram             : std_logic;
 signal  address_ram        : std_logic_vector(5 downto 0):= "000000";
 signal  address_ram_use    : std_logic_vector(5 downto 0);
 signal  ad9517_csn_i       : std_logic:= '0';
 
 
 begin
 
 spi_clk    <= clk_125;
 ad9517_csn <= ad9517_csn_i;
 
 U1 : IO_buffer 
	port map(
		clk_125_n       =>  clk_125_n,
        clk_125_p       =>  clk_125_p,
        adc_clk_in_p    =>  adc_clk_in_p,
        adc_clk_in_n    =>  adc_clk_in_n,
        adc_data_or_p   =>  adc_data_or_p,
        adc_data_or_n   =>  adc_data_or_n,
        adc_data_in_p   =>  adc_data_in_p,
        adc_data_in_n   =>  adc_data_in_n,
        clk_125         =>  clk_125,
        adc_clk_in      =>  adc_clk_in,
        adc_data_or     =>  adc_data_or,
        adc_data_in     =>  adc_data_in);
		
	--Synchronization of the reset	
	
	process(clk_125)
	   begin 
		if (rising_edge(adc_clk_in)) then
			reset_sync_i  <= reset;
			reset_sync    <= reset_sync_i;
		end if;
	end process;		
		
	-- Store incoming data into fifo to cross two clock domains
	
 U2 : fifo_512x8
	port map(
		wr_clk            => adc_clk_in,
        rd_clk            => clk_125,
        srst              => reset_sync,
        din(7 downto 0)   => adc_data_in,
        wr_en             => wr_en_fifo,
        rd_en             => rd_en_fifo,
        dout(7 downto 0)  => adc_data_out,
        full              => full,
        empty             => empty,
        wr_rst_busy       => open,
        rd_rst_busy       => open);
		
    -- Store the address for ram into the fifo to line it up with data
    
  U3: fifo_512x6
    port map(
        wr_clk            => adc_clk_in,
        rd_clk            => clk_125,
        srst              => reset_sync,
        din               => address_ram,
        wr_en             => wr_en_ram_fifo,
        rd_en             => rd_en_fifo,
        dout              => address_ram_use,
        full              => full_i,
        empty             => empty_i,
        wr_rst_busy       => open,
        rd_rst_busy       => open
  );      
		
		
	process(adc_clk_in)
	begin
		if (rising_edge(adc_clk_in)) then
		if reset_sync = '1' then
			wr_en_fifo <= '0';
		elsif full = '1' or adc_data_or = '1' then 
			wr_en_fifo <= '0';
		elsif empty = '1' or (adc_data_in > x"00") then
			wr_en_fifo <= '1';
		else 
			wr_en_fifo <= '0';
		end if;
		end if;
	end process;	
	
	process(adc_clk_in)
	begin
		if (rising_edge(adc_clk_in)) then
		if reset_sync = '1' then
			wr_en_ram_fifo <= '0';
		elsif full_i = '1' or adc_data_or = '1' then 
			wr_en_ram_fifo <= '0';
		elsif empty_i = '1' or (adc_data_in > x"00") then
			wr_en_ram_fifo <= '1';
		else 
			wr_en_ram_fifo <= '0';
		end if;
		end if;
	end process;
	
	
	process(clk_125, ad9517_csn_i)  
	begin
		if (rising_edge(clk_125)) then
		if reset_sync = '1'  then
			rd_en_fifo <= '0';
		elsif empty_i = '1' then
		    rd_en_fifo <= '0';	
		elsif full = '1' then
			rd_en_fifo <= '1';
		elsif empty = '0' then
			rd_en_fifo <= '1';
		else 
			rd_en_fifo <= '0';
		end if;
		end if;
	end process;
	

	
	process(adc_clk_in)    -- Address generation for ram
	begin
		if (rising_edge(adc_clk_in)) then
		if reset_sync = '1' then
			address_ram <= "000000";
		elsif wr_en_fifo = '1' then
			address_ram <= address_ram + '1';
		end if;
		end if;
	end process;	
	
	process(clk_125, address_ram_use) -- cs on when ram is full
	begin
	   if (rising_edge(clk_125)) then
		if reset_sync = '1' then
	       ad9517_csn_i <= '0';
	    elsif address_ram_use = "111110" then
		   ad9517_csn_i  <= '1';
		end if;
		end if;
	end process;
	
	-- Save the data into ram 
	
 U4 : ram_8x64
	port map(
		clk    => clk_125,
		a      => address_ram_use,
		d      => adc_data_out,
		we     => we_ram,
		spo    => data_ram_out);
		
		
	process(clk_125, rd_en_fifo)
	begin
		if (rising_edge(clk_125)) then
		if reset_sync = '1' then
			we_ram <= '0';
		elsif ad9517_csn_i = '1' then
			we_ram <= '0';
		elsif rd_en_fifo = '1' then
			we_ram <= '1';
		else
			we_ram <= '0';
		end if;
		end if;
	end process;	
	 
	 
	
	-- LED Status
	
	up_status(0)  <= we_ram;
	up_status(1)  <= full;
	up_status(2)  <= adc_data_or;
	up_status(3)  <= not reset_sync;
	up_status(4)  <= ad9517_csn_i;
	up_status(5)  <= '0';
	up_status(6)  <= '0';
	up_status(7)  <= '0';
	
end architecture behavioral; 	
		