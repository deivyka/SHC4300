----------------------------------------------------------------------------------
-- UART Transmitter (Listing 7.3 in FPGA Prototyping by VHDL Examples, Pong P. Chu)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------
entity uart_tx is
   generic (   DBIT       : integer:=8;       -- # data bits
               SB_TICK    : integer:=16 );    -- # ticks for stop bits
   
   port (   clk, reset          : in std_logic;
            from_baud_tick      : in std_logic;
            from_tx_bus         : in std_logic_vector(7 downto 0);
            from_tx_start_tick  : in std_logic;
            to_tx_done_tick     : out std_logic;
            to_tx               : out std_logic );
end uart_tx ;
--------------------------------------------------------
architecture arch of uart_tx is
   type state_type is (idle, start, data, stop);
   signal state_reg, state_next : state_type;
   signal s_reg, s_next    : unsigned(3 downto 0);
   signal n_reg, n_next    : unsigned(2 downto 0);
   signal b_reg, b_next    : std_logic_vector(7 downto 0);
   signal tx_reg, tx_next  : std_logic;
--------------------------------------------------------
begin
   -- FSMD state & data registers
   process(clk,reset) begin
      if reset='1' then
         state_reg <= idle;
         s_reg <= (others=>'0');
         n_reg <= (others=>'0');
         b_reg <= (others=>'0');
         tx_reg <= '1';
      elsif rising_edge(clk) then
         state_reg <= state_next;
         s_reg <= s_next;
         n_reg <= n_next;
         b_reg <= b_next;
         tx_reg <= tx_next;
      end if;
   end process;
------------------------------------------   
-- next-state logic & data path functional units/routing
   process(state_reg, s_reg, n_reg, b_reg, from_baud_tick, tx_reg, from_tx_start_tick, from_tx_bus)
   begin
      state_next <= state_reg;
      s_next <= s_reg;
      n_next <= n_reg;
      b_next <= b_reg;
      tx_next <= tx_reg;
      to_tx_done_tick <= '0';
      case state_reg is
      ------------------------------------------ 
         when idle =>
            tx_next <= '1';
            if from_tx_start_tick='1' then
               state_next <= start;
               s_next <= (others=>'0');
               b_next <= from_tx_bus;
            end if;
      ------------------------------------------ 
         when start =>
            tx_next <= '0';
            if (from_baud_tick = '1') then
               if s_reg=15 then
                  state_next <= data;
                  s_next <= (others=>'0');
                  n_next <= (others=>'0');
               else
                  s_next <= s_reg + 1;
               end if;
            end if;
      ------------------------------------------ 
         when data =>
            tx_next <= b_reg(0);
            if (from_baud_tick = '1') then
               if s_reg=15 then
                  s_next <= (others=>'0');
                  b_next <= '0' & b_reg(7 downto 1);
                  if n_reg=(DBIT-1) then
                     state_next <= stop;
                  else
                     n_next <= n_reg + 1;
                  end if;
               else
                  s_next <= s_reg + 1;
               end if;
            end if;
      ------------------------------------------ 
         when stop =>
            tx_next <= '1';
            if (from_baud_tick = '1') then
               if s_reg=(SB_TICK-1) then
                  state_next <= idle;
                  to_tx_done_tick <= '1';
               else
                  s_next <= s_reg + 1;
               end if;
            end if;
      end case;
   end process;
   ------------------------------------------ 
   to_tx <= tx_reg;
end arch;