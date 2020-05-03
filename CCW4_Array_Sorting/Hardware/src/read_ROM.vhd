library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------
entity read_ROM is
   port ( clk          : in std_logic;
          from_clr_ROM : in std_logic;
          from_inc_ROM : in std_logic;
          sort_done    : out std_logic;
          to_ROM_bus   : out std_logic_vector(7 downto 0) );
end read_ROM;
------------------------------------------
architecture arch of read_ROM is
    constant ADDR_WIDTH : integer := 6;
    signal rom_addr     : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal rom_data     : std_logic_vector(7 downto 0);
    signal rom_addr_cnt : unsigned(ADDR_WIDTH-1 downto 0):= (others => '0');
begin
------------------------------------------
    rom: entity work.unsort_rom(arch) 
        port map ( data=>rom_data, addr=>rom_addr );
------------------------------------------
    process(clk) begin
        if rising_edge(clk) then
            if (from_clr_ROM = '1') then
                rom_addr_cnt <= (others => '0');
            elsif from_inc_ROM = '1' then
                if (rom_addr_cnt >= (2**ADDR_WIDTH - 1)) then
                    sort_done <= '1';
                    rom_addr_cnt <= (others => '0');
                else
                    rom_addr_cnt <= rom_addr_cnt + 1;
                end if;
            end if;
        end if;
    end process;
------------------------------------------
    to_ROM_bus <= rom_data;
    rom_addr <= std_logic_vector(rom_addr_cnt);
end arch;