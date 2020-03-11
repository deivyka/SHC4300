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
      result: in std_logic_vector(2 downto 0);  -- Selected result
      sseg, led: out std_logic_vector(6 downto 0)
      );
end component;

-- Define signal
signal clk, reset, stop: std_logic;
signal mode: std_logic_vector (1 downto 0);
signal result: std_logic_vector(2 downto 0);
signal sseg, led:  std_logic_vector(6 downto 0);


-- ********** BEGIN **********
begin
-- Initiate unit under testing
uut: fsmd_e_dice_modes port map (
    clk=>clk, stop=>stop, reset=>reset, mode=>mode,
    result=>result, sseg=>sseg, led=>led
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
    reset <= '1';
    stop <= '0';
    mode <= "00";
    result <= "000";
    wait for clk_period*2;

-- count normally and set result to 3
    reset <= '0';
    result <= "011";
    wait for clk_period*10;

-- test stop
    stop <= '1'; 
    wait for clk_period*2;

-- test forbiden
    stop <= '0';
    mode <= "01";
    wait for clk_period*11;

    stop <= '1';
    wait for clk_period*2;

-- test predefined
    stop <= '0';
    mode <= "10";
    wait for clk_period*7;    

    stop <= '1';
    wait for clk_period*2;

-- test tripple probability 
    stop <= '0';
    mode <= "11";
    wait for clk_period*10; 

    stop <= '1';
    wait for clk_period*2;   

-- test reset 
    reset <= '1';
    wait for clk_period*2;
    
    reset <= '0';
    wait for clk_period*2;

-- Terminate simulation
    assert false
        report "Simulation Completed"
    severity failure;
end process;
end arch;
