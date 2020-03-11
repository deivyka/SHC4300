-- Send ticks to Toggle Flip-Flop
-- Mod-m counter (Listing 4.11 in FPGA Prototyping by VHDL Examples, Pong P. Chu)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity mod_m_counter is
    generic ( N : integer := 18 );
    
    port (  clk, reset : in  STD_LOGIC;
            from_m_in : in STD_LOGIC_VECTOR(N-1 downto 0); -- note in
            to_t_in: out std_logic; -- tick to toggle flip-flop
            q : out std_logic_vector(N-1 downto 0) );
end mod_m_counter;

architecture arch of mod_m_counter is
    signal r_reg, r_next : unsigned(N-1 downto 0);
begin
    process(clk, reset) begin
        if(reset = '1') then
            r_reg <= (others => '0');
        elsif rising_edge(clk) then
            r_reg <= r_next;
        end if; 
    end process; 
    
    --  next - state logic
    r_next <= (others => '0') when r_reg = (unsigned(from_m_in)-1) 
        else r_reg + 1; 
    
    -- output logic
    q <= std_logic_vector(r_reg);
    to_t_in <= '1' when r_reg = (unsigned(from_m_in) - 1) 
        else '0';
end arch;
