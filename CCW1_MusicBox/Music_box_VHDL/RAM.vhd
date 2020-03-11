-- Single-port RAM with synchronous read (Listing 11.2 in FPGA Prototyping by VHDL Examples, Pong P. Chu)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------------------
entity RAM is
	generic ( ADDR_WIDTH: integer := 12;
              	  DATA_WIDTH: integer := 8 );
   
   	port( 	clk, we: in std_logic; -- 'we' = write enable
          	addr: in std_logic_vector(ADDR_WIDTH-1 downto 0);
          	wrbus: in std_logic_vector(DATA_WIDTH-1 downto 0); -- data in
          	rdbus: out std_logic_vector(DATA_WIDTH-1 downto 0) ); -- data out
end RAM;
----------------------------------------------------
architecture arch of RAM is
   type ram_type is array (2**ADDR_WIDTH-1 downto 0)
    	of std_logic_vector (DATA_WIDTH-1 downto 0);
   signal ram: ram_type;
   signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
 process (clk) begin
    	if rising_edge(clk) then
          if (we='1') then
            ram(to_integer(unsigned(addr))) <= wrbus; -- write
          end if;
          addr_reg <= addr;
      	end if;
  end process;
  rdbus <= ram(to_integer(unsigned(addr_reg))); -- read
end arch;
