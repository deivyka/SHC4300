----------------------------------------------------------------------------------
-- FSM control path
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fsm_controller is
    port ( 
        from_rx_done_tick: in std_logic;
        from_dout : in std_logic_vector(7 downto 0);
        to_led: out std_logic_vector(7 downto 0)
        );
end fsm_controller;

architecture arch of fsm_controller is
    
----------------------------------------------------------------------------------
begin

    -- Dispaly ASCII from UART on Basys3 LEDs
    process(from_rx_done_tick) begin
        if (from_rx_done_tick = '1') then
            to_led <= from_dout;
        end if;
    end process;  

end arch;