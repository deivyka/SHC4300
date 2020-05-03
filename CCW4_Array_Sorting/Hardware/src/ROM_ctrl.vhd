library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_ctrl is          
    port (  clk, rst   : in std_logic;
            sort_done  : in std_logic;
            to_clr_ROM : out std_logic;
            to_inc_ROM : out std_logic );
end memory_ctrl;

architecture arch of memory_ctrl is
begin
    process(clk) begin
        if (rst = '1') then
            to_clr_ROM <= '0';
            to_inc_ROM <= '0';
        elsif rising_edge(clk) then 
            if (sort_done = '1') then
                to_inc_ROM <= '0';
            else 
                to_inc_ROM <= '1'; -- increment ROM
            end if;
        end if;
    end process;
end arch;
