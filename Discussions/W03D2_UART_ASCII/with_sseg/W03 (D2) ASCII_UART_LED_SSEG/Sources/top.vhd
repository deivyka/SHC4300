----------------------------------------------------------------------------------
-- Top design module 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port ( 
        clk, rst, rx : in std_logic;
        led :   out std_logic_vector(7 downto 0);
        sseg:   out std_logic_vector(6 downto 0);
        anode:  out std_logic_vector(3 downto 0)
        );
end top;

architecture arch of top is
    signal s_tick, rx_done_tick:    std_logic;
    signal dout:                    std_logic_vector(7 downto 0);

----------------------------------------------------------------------------------
begin
------------------------------------------------------------
-- FSM control
    FSM_Controler: entity work.fsm_controller(arch)
        port map (  from_dout=>dout, from_rx_done_tick=>rx_done_tick, 
                    to_led=>led );
---------------------------------------------------------
-- Baud generator
    Baud_Generator: entity work.mod_m(arch)
        port map (  clk=>clk, rst=>rst, to_s_tick=>s_tick );
---------------------------------------------------------
-- UART 
    UART: entity work.uart(arch)
        port map (  clk=>clk, rst=>rst, rx=>rx, to_dout=>dout,
                    from_s_tick=>s_tick, rx_done_tick=>rx_done_tick );
---------------------------------------------------------
-- ASCII to 7 segment display conversion
    ASCII_To_7SEG: entity work.ascii2sseg(arch)
        port map (  anode=>anode, sseg=>sseg, from_dout=>dout );
---------------------------------------------------------
end arch;
