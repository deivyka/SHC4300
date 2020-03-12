library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-----------------------------------------------
entity encode_decode is  
    Port (  from_enc     : in std_logic;
            from_dec     : in std_logic;
            from_rx_bus  : in std_logic_vector(7 downto 0);
            from_key_bus : in std_logic_vector(7 downto 0);
            to_ram_bus   : out std_logic_vector(7 downto 0));
end encode_decode;
-----------------------------------------------
architecture arch of encode_decode is
begin    
    to_ram_bus <=   X"20" when from_rx_bus = X"20" else -- check for space
                    X"0D" when  from_rx_bus = X"0D"  or from_rx_bus = X"0A" else
                    std_logic_vector(((25 - unsigned(from_rx_bus) + unsigned(from_key_bus)) mod 26) +97) when (from_enc = '1') else
                    std_logic_vector(((25 + unsigned(from_key_bus) - unsigned(from_rx_bus)) mod 26) +97);
end arch;
