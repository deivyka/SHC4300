----------------------------------
-- Array Sorter - TestBench
----------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------
entity main_top_tb is
end main_top_tb;
----------------------------------
architecture arch of main_top_tb is
    component main_top is    
        port ( clk, rst : in std_logic;
               sorted_out : out std_logic_vector(7 downto 0) );
    end component;
----------------------------------
    constant clk_period : time := 10 ns;
    signal clk, rst : std_logic := '0';
    signal sorted_out : std_logic_vector(7 downto 0);
----------------------------------
begin

    uut : main_top port map 
            ( clk => clk, rst => rst,
              sorted_out => sorted_out );
----------------------------------
    clk_proc : process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
----------------------------------
    stim : process begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;
        wait;
    end process;
end;