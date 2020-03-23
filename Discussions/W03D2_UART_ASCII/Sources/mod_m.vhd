----------------------------------------------------------------------------------
-- Listing 4.11 Mod-m counter
-- This baud-rate generator will generate sampling ticks

-- Frequency = 16x the required baud rate (16x oversampling)
-- 19200 bps * 16 = 307200 ticks/s
-- 100 MHz / 307200 = 325.52 = 326
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mod_m is
    generic (
        N: integer := 9; -- num of bits
        M: integer := 326 ); -- mod-326 counter 

    port ( 
        clk, rst:   in std_logic;
        to_s_tick:  out std_logic );
end mod_m;
------------------------------------------
architecture arch of mod_m is
    signal r_reg:   unsigned(N-1 downto 0);
    signal r_next:  unsigned(N-1 downto 0);
    signal q:       std_logic_vector(N-1 downto 0);
     
----------------------------------------------------------------------------------
begin
    -- register
    process(clk, rst) begin
        if (rst = '1') then
            r_reg <= (others =>'0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if;
    end process;
    
    -- next-state logic
    r_next <= (others => '0') when r_reg=(M-1) else r_reg+1;
    
    -- output logic
    q <= std_logic_vector(r_reg);
    to_s_tick <= '1' when r_reg=(M-1) else '0';
end arch;
