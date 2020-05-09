
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------
entity FSMDISPANDRAM is
    generic (   ADDR_WIDTH: integer := 12;
                DATA_WIDTH: integer := 8 );
        
    port (  clk, reset          : in STD_LOGIC;
            from_mode           : in STD_LOGIC;
            from_rx_done_tick   : in STD_LOGIC;
            from_tx_done_tick   : in STD_LOGIC;
            from_rx_bus         : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            ram_bus             : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
            to_tx_bus           : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);  
            to_clr_key          : out STD_LOGIC;
            to_inc_key          : out STD_LOGIC;
            to_enc              : out STD_LOGIC;
            to_dec              : out STD_LOGIC;
            to_wr               : out STD_LOGIC;
            to_abus             : out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
            to_tx_start_tick    : out STD_LOGIC );
end FSMDISPANDRAM;
----------------------------------------------------
architecture arch of FSMDISPANDRAM is
    type state_type is (init, check_for_ascii, store_1, store_2,
                        transmit_1, transmit_2, transmit_all, transmit_ram1, transmit_ram2, transmit_cr1, transmit_cr2);
    signal state_next, state_reg : state_type;
    signal pcntr_next   : unsigned (ADDR_WIDTH-1 downto 0); -- program counter (increment abus)
    signal pcntr_reg    : unsigned (ADDR_WIDTH-1 downto 0) := (others => '0');
    signal ram_message  : std_logic := '0';
----------------------------------------------------------------------------------
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
    ----------------------------------------------------    
    -- next state and output logic
    process(state_reg,  from_mode, from_rx_done_tick, from_tx_done_tick) begin
        state_next <= state_reg;
        pcntr_next <= pcntr_reg; -- address counter
        to_clr_key <= '0';
        to_inc_key <= '0';
        to_tx_start_tick <= '0';
        to_wr <= '0'; 
    ----------------------------------------------------
        case state_reg is
        when init =>
            ram_message <= '0';
            to_clr_key <= '1';              -- clear key counter
            state_next <= check_for_ascii;
    ----------------------------------------------------    
        when check_for_ascii =>
            ram_message <= '0';
            if (from_rx_done_tick = '1') then
                -- X"0A" = Line feed, X"0D" = "Enter"-key (carriage return), X"20" = space
                if ((from_rx_bus>=X"61" and from_rx_bus<=X"7a") or from_rx_bus = X"0A" or from_rx_bus = X"0D" or from_rx_bus = X"20") then -- go to store_1 if ascii 'a' to 'z'
                    state_next <= store_1;
                else
                    state_next <= check_for_ascii;    
                end if;
            else
                state_next <= check_for_ascii;
            end if;
    ----------------------------------------------------
        when store_1 =>
            ram_message <= '0';
            to_wr <= '1';
            state_next <= store_2;
    ----------------------------------------------------
        when store_2 =>
            ram_message <= '0';
            state_next <= transmit_1;
            pcntr_next <= pcntr_reg + 1;
    ----------------------------------------------------
        when transmit_1 =>
            ram_message <= '0';
            to_tx_start_tick <= '1';
            state_next <= transmit_2;
    ----------------------------------------------------
        when transmit_2 =>
            ram_message <= '0';
            to_tx_start_tick <= '0';
            if (from_tx_done_tick = '1') then
                if (from_rx_bus = X"0D" or from_rx_bus = X"0A") then -- X"0A" = Line feed, X"0D" = "Enter"-key (carriage return)
                    state_next <= transmit_all;
                else
                    state_next <= check_for_ascii;
                    to_inc_key <= '1';          -- increment rom key
                end if;
            else
                state_next <= transmit_2;
            end if;
    ----------------------------------------------------
        when transmit_all =>
            ram_message <= '1';
            pcntr_next <= (others => '0');
            state_next <= transmit_ram1;
    ----------------------------------------------------
        when transmit_ram1 =>
            ram_message <= '1';
            to_tx_start_tick <= '1';
            state_next <= transmit_ram2;    
    ---------------------------------------------------- 
        when transmit_ram2 =>
            ram_message <= '1';
            to_tx_start_tick <= '0';
            if (from_tx_done_tick = '1') then    
                if (ram_bus = X"0A" or ram_bus = X"0D" ) then  -- X"0A" = Line feed, X"0D" = "Enter"-key (carriage return)
                    pcntr_next <= (others => '0');                                    
                    state_next <= transmit_cr1;
                else
                    state_next <= transmit_ram1;
                    pcntr_next <= pcntr_reg + 1;
                end if;   
            else
                state_next <= transmit_ram2;
            end if;
    ----------------------------------------------------
        when transmit_cr1=>
            ram_message <= '0';
            to_tx_start_tick <= '1';
            state_next <= transmit_cr2;
    ----------------------------------------------------
        when transmit_cr2=>
            ram_message <= '0';
            to_tx_start_tick <= '0';
            if (from_tx_done_tick = '1') then                                      
                state_next <= init;
            else
                state_next <= transmit_cr2;
            end if;
        end case;
    end process;
    ----------------------------------------------------
    to_enc <= not from_mode;
    to_dec <= from_mode;
    to_abus <= std_logic_vector(pcntr_reg);
    -- X"0A" = Line feed, X"0D" = "Enter"-key (carriage return)
    to_tx_bus <= X"0A" when ( from_rx_bus = X"0D" and ram_message= '0' ) else
                 from_rx_bus when ram_message = '0' else
                 ram_bus;  
end arch;
