library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsmd_e_dice_modes_TB is
--  Port ( );
end fsmd_e_dice_modes_TB;

architecture arch of fsmd_e_dice_modes_TB is
-- Define clock for test bench
constant clk_period : time := 10 ns;

component fsmd_e_dice_modes is
   port(
      clk, reset, stop: in std_logic;
      mode: in std_logic_vector (1 downto 0);
      result: in std_logic_vector(2 downto 0)  -- Selected result
      );
end component;

-- Define signal
signal clk, reset, stop: std_logic;
signal mode: std_logic_vector (1 downto 0);
signal result: std_logic_vector(2 downto 0);

-- ********** BEGIN **********
begin
-- Initiate unit under testing
uut: fsmd_e_dice_modes port map (
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
-- Initial setup reset on startup
    reset <= '1'; -- reset flipflops only on start
    stop <= '0';
    mode <= "00";
    result <= "000";
    wait for clk_period*2;

-- let clock go on 
    reset <= '0';
    wait for clk_period*10;

-- test stop
    stop <= '1'; 
    wait for clk_period*2;

-- test tripple probability 
    stop <= '0';
    result <= "100";
    mode <= "11";
    wait for clk_period*6; 

-- test stop on tripple probability 
    stop <= '1';
    wait for clk_period*2;

-- turn off stop and put mode into forbiden and result at 3
    stop <= '0';
    mode <= "01";
    result <= "011";
    wait for clk_period*2;

-- test stop again
    stop <= '1';
    wait for clk_period*2;    

-- turn off stop and put mode into predefined
    stop <= '0';
    mode <= "10";
    wait for clk_period*2;    

-- test stop again
    stop <= '1';
    wait for clk_period*2;    

-- Terminate simulation
    assert false
        report "Simulation Completed"
    severity failure;
end process;
end arch;
