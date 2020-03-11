-- top design module

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (  rx, clk, reset, play : in  STD_LOGIC;
            loudspeaker : out  STD_LOGIC;
            leds : out std_logic_vector(7 downto 0) );
    end top;

architecture Behavioral of top is
    signal tick : std_logic; 
    signal dout : std_logic_vector(7 downto 0);
    signal m_in : std_logic_vector(17 downto 0);
    signal rx_done_tick, t_in, clr_FF : std_logic; 
    signal abus : std_logic_vector(11 downto 0);
    signal wr_en : std_logic; 
    signal ram_data : std_logic_vector(7 downto 0);
    signal td_on, td_done : std_logic;
begin 

leds <= dout;
----------------------------------------------------------
    baud_gen_unit : entity work.baud_rate_generator(arch)
        port map ( clk=>clk, reset=>reset, q=>open, max_tick=>tick );

-----------------------------------------------------------
    uart_rx_unit : entity work.uart_rx(arch)
        port map (  clk => clk, reset => reset, from_rx => rx,
                    s_tick => tick, to_rx_done_tick => rx_done_tick, 
                    to_dout => dout ); 	

--------------------------------------------------------------
    code_converter_unit : entity work.CodeConverter(arch)
        port map ( from_dout=>ram_data, to_m_in=>m_in );		

----------------------------------------------------------		
    mod_m_cntr_unit : entity work.mod_m_counter(arch)
        port map (  clk=>clk, reset=>reset,
                    from_m_in=>m_in, to_t_in=>t_in );		

------------------------------------------------------------------
    t_ff_unit : entity work.T_FF(arch)
        port map (  clk=>clk, reset=>reset,
                    from_t_in=>t_in,
                    from_clr_FF=>clr_FF,
                    to_ldspkr=>loudspeaker );

-------------------------------------------------------------------		
    fsm_unit : entity work.FSM(arch)
        port map (  from_play => play,
                    from_rx_done_tick => rx_done_tick,
                    from_dout =>  dout,
                    to_abus => abus,
                    to_wr_en => wr_en,
                    from_rdbus => ram_data,
                    to_td_on => td_on,
                    from_td_done => td_done,
                    to_clr_FF => clr_FF,
                    reset=>reset, clk=>clk );

-------------------------------------------------------------------
    RAM_unit : entity work.RAM(arch)
        port map (  clk => clk, we => wr_en,
                    addr => abus, wrbus => dout,
                    rdbus => ram_data );

-----------------------------------------------------------------
    delay_unit : entity work.TimerDelay(arch)
        port map (  clk => clk, reset => reset,
                    from_td_on => td_on, to_td_done => td_done); 	  
end Behavioral;