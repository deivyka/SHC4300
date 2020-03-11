library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------
entity key_block is
   port ( clk: in std_logic;
          from_clr_key: in std_logic;
          from_inc_key: in std_logic;
          to_key_bus: out std_logic_vector(7 downto 0) );
end key_block;


-- victordeivyleilabiplav
-- 01110110 01101001 01100011 01110100 01101111 01110010 01100100 01100101 01101001 01110110 01111001 01101100 01100101 01101001 01101100 01100001 01100010 01101001 01110000 01101100 01100001 01110110

------------------------------------------
architecture arch of key_block is
  signal rom_addr: std_logic_vector(4 downto 0);
  signal rom_data: std_logic_vector(7 downto 0);
  signal rom_addr_cnt: unsigned ( 4 downto 0):= (others => '0');
begin
------------------------------------------
  rom: entity work.key_rom(arch) 
        port map ( data=>rom_data, addr=>rom_addr );
------------------------------------------
  process(clk) begin
    if rising_edge(clk) then
      if from_clr_key = '1' then
        rom_addr_cnt <= (others => '0');
      elsif from_inc_key = '1' then
        if rom_addr_cnt >= 21 then
          rom_addr_cnt <= (others => '0');
        else
          rom_addr_cnt <= rom_addr_cnt + 1;
        end if;
      end if;
    end if;
  end process;
------------------------------------------
  to_key_bus <= rom_data;
  rom_addr <=  std_logic_vector(rom_addr_cnt);
end arch;