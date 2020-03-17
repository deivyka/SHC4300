----------------------------------------------------------------------------------
-- top design module
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (  rx, clk, reset, mode : in std_logic;
            tx : out std_logic );
    end top;

architecture Behavioral of top is
    -- Key ROM signals
    signal clr_key      : std_logic;
    signal inc_key      : std_logic;
    
    -- Baud and uart signals
    signal baud_tick    : std_logic; 
    signal rx_done_tick : std_logic; 
    signal rx_bus       : std_logic_vector(7 downto 0);
    signal tx_start_tick: std_logic; 
    signal tx_done_tick : std_logic; 
    signal tx_bus       : std_logic_vector(7 downto 0);

    
    -- Encoder and decoder signals
    signal enc              : std_logic;
    signal dec              : std_logic; 
    signal key_bus          : std_logic_vector(7 downto 0);
    signal ram_bus          : std_logic_vector(7 downto 0);
    signal ram_input_bus    : std_logic_vector(7 downto 0);
    signal ram_wr           : STD_LOGIC;
    signal ram_abus         : STD_LOGIC_VECTOR (11 downto 0);
----------------------------------------------------------------------------------
begin 

FSM_NO_SAVE_Controller: entity work.FSMDISPANDRAM(arch)
    port map (  clk => clk,
                reset => reset,
                from_mode => mode,
                from_rx_done_tick => rx_done_tick,
                from_tx_done_tick => tx_done_tick,
                from_rx_bus => rx_bus,
                ram_bus => ram_bus,
                to_tx_bus => tx_bus,
                to_clr_key => clr_key,
                to_inc_key => inc_key,
                to_enc => enc,
                to_dec => dec,
                to_wr => ram_wr,
                to_abus => ram_abus,
                to_tx_start_tick => tx_start_tick );
----------------------------------------------------------
--    FSM_Controller : entity work.FSM(arch)
--        port map (  clk => clk,
--                    reset => reset,
--                    from_mode => mode,
--                    from_rx_done_tick => rx_done_tick,
--                    from_tx_done_tick => tx_done_tick,
--                    from_rx_bus => rx_bus,
--                    from_tx_bus => tx_bus,
--                    to_clr_key => clr_key,
--                    to_inc_key => inc_key,
--                    to_enc => enc,
--                    to_dec => dec,
--                    to_abus => abus,
--                    to_wr => wr,
--                    to_tx_start_tick => tx_start_tick );
                    
----------------------------------------------------------
    Baud_Gen : entity work.baud_rate_generator(arch)
        port map (  clk => clk, 
                    reset => reset, 
                    to_baud_tick => baud_tick );
----------------------------------------------------------
    Uart_Rx : entity work.uart_rx(arch)
        port map (  clk => clk, 
                    reset => reset, 
                    from_rx => rx,
                    from_baud_tick => baud_tick, 
                    to_rx_done_tick => rx_done_tick, 
                    to_rx_bus => rx_bus );  
----------------------------------------------------------
    Key_Block : entity work.key_block(arch)
        port map (  clk => clk,
                    from_clr_key => clr_key, 
                    from_inc_key => inc_key,
                    to_key_bus => key_bus ); 
----------------------------------------------------------
    Encoder_Decoder : entity work.encode_decode(arch)
        port map (  from_enc => enc,
                    from_dec => dec, 
                    from_rx_bus => rx_bus,
                    from_key_bus => key_bus, 
                    to_ram_bus => ram_input_bus );     
----------------------------------------------------------
    RAM : entity work.RAM(arch)
        port map (  clk => clk, 
                    from_wr => ram_wr,
                    from_abus => ram_abus, 
                    from_ram_bus => ram_input_bus,
                    to_tx_bus => ram_bus );
----------------------------------------------------------
    Uart_Tx : entity work.uart_tx(arch)
        port map (  clk => clk, 
                    reset => reset,
                    from_baud_tick => baud_tick,
                    from_tx_bus => tx_bus,
                    from_tx_start_tick => tx_start_tick, 
                    to_tx_done_tick => tx_done_tick,
                    to_tx => tx );  
----------------------------------------------------------
end Behavioral;
