-- 0.5 sec timer delay
-- Mod-m counter (Listing 4.11 in FPGA Prototyping by VHDL Examples, Pong P. Chu)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TimerDelay is
    generic (   --N: integer :=16;
                --M: integer := 50e3 ); -- for simulation (50K clock cycles)
                N: integer := 26;    -- bits needed to count to M
                M: integer := 50e6 );  -- 100 MHz * 0.5 sec = 50 M clock cycles
    
    port (  clk, reset: in std_logic;
            from_td_on: in std_logic;
            to_td_done: out std_logic );
end TimerDelay;

architecture arch of TimerDelay is
    signal r_next, r_reg: unsigned(N-1 downto 0);

begin
    -- register
    process(clk,reset) begin
        if (reset='1') then
            r_reg <= (others=>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next-state logic
    r_next <=   (others => '0') when from_td_on = '0' else
                (others => '0') when r_reg = (M) else
                r_reg+1;
    
    -- output logic
    to_td_done <= '1' when r_reg = (M) else '0';
end arch;
