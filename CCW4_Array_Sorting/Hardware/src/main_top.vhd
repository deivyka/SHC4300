-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Array sorter MAIN Top-module

-- Based on:
    -- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------
entity main_top is    
    port ( clk, rst   : in std_logic;
           sorted_out : out std_logic_vector(7 downto 0) );
end main_top;
-------------------------------------------------
architecture arch of main_top is
    signal clr_ROM, inc_ROM, sort_done : std_logic; 
    signal unsorted_in_bus  : std_logic_vector(7 downto 0);
-------------------------------------------------
begin
    ROM : entity work.read_ROM(arch)
        port map (  clk => clk,
                    from_clr_ROM => clr_ROM, 
                    from_inc_ROM => inc_ROM,
                    sort_done => sort_done,
                    to_ROM_bus => unsorted_in_bus );
-------------------------------------------------
    SORTER : entity work.sort_top(arch) 
        port map (  clk => clk, 
                    rst => rst,
                    from_rom => unsorted_in_bus,
                    sorted_data => sorted_out );
-------------------------------------------------
    memory_ctrl: entity work.memory_ctrl(arch)
        port map (  clk => clk,
                    rst => rst,
                    sort_done => sort_done,
                    to_clr_ROM => clr_ROM,
                    to_inc_ROM => inc_ROM );
-------------------------------------------------
end arch;