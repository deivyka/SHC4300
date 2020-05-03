-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Sorting Cell

-- Based on:
    -- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--------------------------------------
entity sorting_cell is
    generic ( data_width : integer := 8 );
    
    port ( clk, rst           : in std_logic;
           unsorted_data      : in std_logic_vector(data_width-1 downto 0);
           pre_data           : in std_logic_vector(data_width-1 downto 0);
           pre_full, pre_push : in boolean; 
           nxt_data           : out std_logic_vector(data_width-1 downto 0);
           nxt_full, nxt_push : out boolean );
end sorting_cell;
--------------------------------------
architecture arch of sorting_cell is
-- Each cell needs to keep track of its own state (empty or full)
    type state_type is (empty_state, full_state); 
    
    signal state_next, state_reg : state_type;
    signal full        : boolean := false;
    signal crrnt_data  : std_logic_vector(data_width-1 downto 0) := (others=>'0');
    signal accept_data : boolean := false;
--------------------------------------
begin
    accept_data <= (unsorted_data > crrnt_data) OR NOT full;
    nxt_data    <= crrnt_data;
    nxt_full    <= true when (full) else false;
    nxt_push    <= true when (accept_data AND full) else false;
--------------------------------------
    process (clk, rst) begin
        if rising_edge(clk) then
            state_reg <= state_next;
            if (rst = '1') then
                state_reg <= empty_state;
                crrnt_data <= (others=>'0');
            else
                if (pre_push) then
                    crrnt_data <= pre_data;
                elsif (accept_data AND NOT pre_push AND full) then
                    crrnt_data <= unsorted_data;
                elsif (NOT pre_push AND NOT full AND pre_full) then
                    crrnt_data <= unsorted_data;
                end if;
            end if;
        end if;
    end process;
--------------------------------------
    process(state_reg, pre_push, pre_full) begin
        state_next <= state_reg;
        case state_reg is
            when empty_state =>
                full <= false;
                if (pre_push) then
                    state_next <= full_state;
                elsif (NOT pre_push AND pre_full) then
                    state_next <= full_state;     
                else
                    state_next <= empty_state;
                end if;      
            when full_state => 
                full <= true; 
        end case;
    end process;
end arch;