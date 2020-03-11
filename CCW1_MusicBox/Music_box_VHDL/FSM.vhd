-- FSM Control Path

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM is
    generic (   ADDR_WIDTH: integer := 12;
                DATA_WIDTH: integer := 8 );
        
    port (  clk, reset, from_play           : in STD_LOGIC;
            from_rx_done_tick, from_td_done : in STD_LOGIC;
            from_dout, from_rdbus           : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
            to_abus                         : out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
            to_wr_en, to_td_on              : out STD_LOGIC;
            to_clr_FF                       : out STD_LOGIC );
end FSM;

architecture arch of FSM is
    type state_type is (init, check_for_ABC, store_1, store_2, store_3, 
                        wait_for_play, play_1, play_2);
    signal state_next, state_reg : state_type;
    signal pcntr_next, pcntr_reg : unsigned (ADDR_WIDTH-1 downto 0); -- program counter (increment abus)
begin
    -- state register
    process(clk, reset) begin
        if (reset = '1') then
            state_reg <= init;
            pcntr_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            pcntr_reg <= pcntr_next;
        end if;
    end process;
        
    -- next state and output logic
    process(from_play, state_reg, pcntr_reg, from_rx_done_tick, from_dout, from_rdbus, from_td_done)
    begin
        state_next <= state_reg;
        pcntr_next <= pcntr_reg; -- address counter
        to_clr_FF <= '0';
        to_td_on <= '0';
        to_wr_en <= '0';
        case state_reg is
    ----------------------------------------------------
        when init =>
            to_clr_FF <= '1';
            if (from_rx_done_tick = '1') then 
                if (from_dout = X"28") then	-- ASCII for '('
                    state_next <= check_for_ABC;
                end if;
            end if;
    ----------------------------------------------------
        when check_for_ABC =>
            to_clr_FF <= '1';
            pcntr_next <= (others => '0');
            if (from_rx_done_tick = '1') then
                -- octave 4
                if ( from_dout = X"43" or from_dout = X"44" or from_dout = X"45" or from_dout = X"46"  
                    or from_dout = X"47" or from_dout = X"41" or from_dout = X"42"
                -- octave 5
                    or from_dout = X"63" or from_dout = X"64" or from_dout = X"65" or from_dout = X"66" 
                    or from_dout = X"67" or from_dout = X"61" or from_dout = X"62") then 
                        state_next <= store_1;
                end if;
            end if;
    ----------------------------------------------------
        when store_1 =>
            to_clr_FF <= '1';
            to_wr_en <= '1';
            state_next <= store_2;
    ----------------------------------------------------
        when store_2 =>
            to_clr_FF <= '1';
            pcntr_next <= pcntr_reg+1; -- increment abus
            state_next <= store_3;
    ----------------------------------------------------
        when store_3 =>
            to_clr_FF <= '1';
            if (from_rx_done_tick = '1') then
                if (from_dout = X"29") then	-- ASCII for ')'
                    to_wr_en <= '1';
                    state_next <= wait_for_play;
                    -- octave 4
                elsif (from_dout = X"43" or from_dout = X"44" or from_dout = X"45" or from_dout = X"46"  
                    or from_dout = X"47" or from_dout = X"41" or from_dout = X"42" 
                    -- octave 5
                    or from_dout = X"63" or from_dout = X"64" or from_dout = X"65" or from_dout = X"66" 
                    or from_dout = X"67" or from_dout = X"61" or from_dout = X"62") then 
                        state_next <= store_1;
                end if;
            end if;
    ----------------------------------------------------
        when wait_for_play =>
            to_clr_FF <= '1';
            pcntr_next <= (others => '0');
            if (from_play = '1') then
                state_next <= play_1;
            elsif (from_rx_done_tick = '1') then
                if (from_dout = X"28") then -- ASCII for '('
                    state_next <= check_for_ABC;
                end if;
            end if;
    ----------------------------------------------------
        when play_1 =>
            to_td_on <= '1';
            if (from_rdbus = X"29") then	-- ')' end of tune
                state_next <= wait_for_play;
            elsif (from_td_done = '1') then
                state_next <= play_2;
            end if;
    ----------------------------------------------------
        when play_2 =>
            to_td_on <= '1';
            pcntr_next <= pcntr_reg+1; -- increment abus
            state_next <= play_1;
        end case;
    end process;
    to_abus <= std_logic_vector (pcntr_reg);
end arch;
