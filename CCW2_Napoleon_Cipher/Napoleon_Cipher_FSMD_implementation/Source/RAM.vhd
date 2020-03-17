----------------------------------------------------------------------------------
-- Single-port RAM with synchronous read 
-- (Listing 11.2 in FPGA Prototyping by VHDL Examples, Pong P. Chu)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------------------------------------
entity RAM is
  generic ( ADDR_WIDTH: integer := 12;
            DATA_WIDTH: integer := 8 );
   
    port (  clk           : in std_logic;
            from_wr       : in std_logic; -- write enable
            from_abus     : in std_logic_vector(ADDR_WIDTH-1 downto 0);
            from_ram_bus  : in std_logic_vector(DATA_WIDTH-1 downto 0);     -- data in
            to_tx_bus     : out std_logic_vector(DATA_WIDTH-1 downto 0) );  -- data out
end RAM;
----------------------------------------------------------------------------------
architecture arch of RAM is
  type ram_type is array (2**ADDR_WIDTH-1 downto 0) of std_logic_vector (DATA_WIDTH-1 downto 0);
  signal ram_space: ram_type;
----------------------------------------------------------------------------------
begin
  process (clk) begin
    if rising_edge(clk) then
      if (from_wr = '1') then
        ram_space(to_integer(unsigned(from_abus))) <= from_ram_bus; -- write
      end if;
    end if;
  end process;
  to_tx_bus <= ram_space(to_integer(unsigned(from_abus))); -- read
end arch;