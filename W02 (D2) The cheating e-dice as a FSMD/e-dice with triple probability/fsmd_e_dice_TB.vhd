library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsmd_e_dice_TB is
--  Port ( );
end fsmd_e_dice_TB;

architecture arch of fsmd_e_dice_TB is
-- Define clock for test bench
constant clk_period : time := 10 ns;

component fsmd_e_dice is
   port(
      clk, reset, stop, mode: in std_logic;
      result: in std_logic_vector(2 downto 0)  -- Selected result
      );
end component;

-- Define signal
signal clk, reset, stop, mode: std_logic;
signal result: std_logic_vector(2 downto 0);

-- ********** BEGIN **********
begin
-- Initiate unit under testing
uut: fsmd_e_dice port map (
    clk=>clk, stop=>stop, reset=>reset, mode=>mode,
    result=>result
    );

-- Clock process
clk_process: process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;


-- Stimulus process
stim: process
begin
-- Initial setup tu reset on startup
    reset <= '1'; -- reset flipflops only on start
    stop <= '0';
    mode <= '0';
    result <= "000";
    wait for clk_period*2; -- wait for 2 clock periods

-- let clock go on 
    reset <= '0'; -- reset flipflops only on start
    wait for clk_period*8; -- wait for 2 clock periods

-- let clock go on 
    stop <= '1'; -- reset flipflops only on start
    wait for clk_period*2; -- wait for 2 clock periods

-- let clock go on 
    stop <= '0'; -- reset flipflops only on start
    result <= "100";
    mode <= '1';
    wait for clk_period*6; -- wait for 2 clock periods

-- let clock go on 
    stop <= '1'; -- reset flipflops only on start
    wait for clk_period*6; -- wait for 2 clock periods
    
-- Terminate simulation
    assert false
        report "Simulation Completed"
    severity failure;
end process;
end arch;
