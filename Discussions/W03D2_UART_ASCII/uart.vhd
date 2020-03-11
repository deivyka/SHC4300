----------------------------------------------------------------------------------
-- listing 7.1
-- UART receiver
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------
entity uart is
    generic (
        DBIT: integer := 8; -- data bits
        SB_TICK: integer := 16 ); -- ticks for stop bits

    Port ( 
        clk, rst, rx, from_s_tick: in std_logic;
        rx_done_tick : out std_logic;
        to_dout : out std_logic_vector(7 downto 0) );
end uart;

architecture arch of uart is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type; -- current and next state
    signal s_reg, s_next : unsigned(3 downto 0); -- keep track of sampling ticks and count to 7 in the 'start' state
    signal n_reg, n_next : unsigned(2 downto 0); -- keep track of data bits received in the 'data' state
    signal b_reg, b_next : std_logic_vector(7 downto 0); -- (deserializes rx) retrieved bits are shifted into and reassembled in the 'b' register

----------------------------------------------------------------------------------
begin

-- State registers
    process(clk, rst) begin
        if rst = '1' then
            state_reg <= idle;
            s_reg <= (others => '0');
            n_reg <= (others => '0');
            b_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;

-- next-state logic
    process(state_reg, s_reg, n_reg, b_reg, from_s_tick, rx)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done_tick <= '0';
        case state_reg is 
------------------------------------------------------------                
            when idle =>
                if rx='0' then
                    state_next <= start;
                    s_next <= (others=>'0');
                -- else stay idle
                end if;
------------------------------------------------------------                
            when start =>
                if (from_s_tick = '1') then
                    if s_reg=7 then -- restart counter
                        state_next <= data;
                        s_next <= (others=>'0');
                        n_next <= (others=>'0');
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------                
            when data =>
                if (from_s_tick = '1') then
                    if s_reg=15 then -- read RxD, feed its value to deserializer, restart counter
                        s_next <= (others => '0');
                        b_next <= rx & b_reg(7 downto 1); -- b = rx & (b >> 1)
                        if n_reg=(DBIT-1) then
                            state_next <= stop;
                        else
                            n_next <= n_reg+1;
                        end if;
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
------------------------------------------------------------
            when stop =>
                if (from_s_tick = '1') then
                    if s_reg=(SB_TICK-1) then
                        state_next <= idle;
                        rx_done_tick <= '1';
                    else
                        s_next <= s_reg+1;
                    end if;
                end if;
        end case;
    end process;
    
    -- Output
    to_dout <= b_reg;
end arch;
