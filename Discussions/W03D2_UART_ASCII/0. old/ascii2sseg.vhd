----------------------------------------------------------------------------------
-- Listing 8.4
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ascii2sseg is
   port (
      from_dout: in std_logic_vector(7 downto 0);
      sseg: out std_logic_vector(6 downto 0);
      anode: out std_logic_vector(3 downto 0)
      );
end ascii2sseg;

architecture arch of ascii2sseg is

----------------------------------------------------------------------------------
begin
    anode <= "1110";
    with from_dout select
        sseg <=
        --abcdefg         ascii
        "0000001" when "00110000", -- 0
        "1001111" when "00110001", -- 1
        "0010010" when "00110010", -- 2
        "0000110" when "00110011", -- 3
        "1001100" when "00110100", -- 4
        "0100100" when "00110101", -- 5
        "0100000" when "00110110", -- 6
        "0001111" when "00110111", -- 7
        "0000000" when "00111000", -- 8
        "0001100" when "00111001", -- 9
        "0001000" when "01000001", -- A
        "1100000" when "01100010", -- b
        "0110001" when "01000011", -- C
        "1000010" when "01100100", -- d
        "0110000" when "01000101", -- E
        "0111000" when "01000110", -- F
        "1111111" when others; -- nothing
end arch;
