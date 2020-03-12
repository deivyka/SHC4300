
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------
entity key_rom is
   port(  addr: in std_logic_vector(4 downto 0);
          data: out std_logic_vector(7 downto 0) );
end key_rom;
-------------------------------------------------------

-- victordeivyleilabiplav
-- 01110110 01101001 01100011 01110100 01101111 01110010 01100100 01100101 01101001 01110110 01111001 01101100 01100101 01101001 01101100 01100001 01100010 01101001 01110000 01101100 01100001 01110110

architecture arch of key_rom is
   constant ADDR_WIDTH: integer:=5;
   constant DATA_WIDTH: integer:=8;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   
   -- ROM definition
   constant HEX2LED_ROM: rom_type:=(  -- 2^4-by-7
     "01110110",   --addr 00  , value 'v'    
     "01101001",   --addr 01  , value 'i'
     "01100011",   --addr 02  , value 'c'
     "01110100",   --addr 03  , value 't'
     "01101111",   --addr 04  , value 'o'
     "01110010",   --addr 05  , value 'r'
     "01100100",   --addr 06  , value 'd'
     "01100101",   --addr 07  , value 'e'
     "01101001",   --addr 08  , value 'i'
     "01110110",   --addr 09  , value 'v'
     "01111001",   --addr 10  , value 'y'
     "01101100",   --addr 11  , value 'l'
     "01100101",   --addr 12  , value 'e'
     "01101001",   --addr 13  , value 'i'
     "01101100",   --addr 14  , value 'l'
     "01100001",   --addr 15  , value 'a'
     "01100010",   --addr 16  , value 'b'
     "01101001",   --addr 17  , value 'i'
     "01110000",   --addr 18  , value 'p'
     "01101100",   --addr 19  , value 'l'
     "01100001",   --addr 20  , value 'a'
     "01110110",   --addr 21  , value 'v'
     "00000000",   --addr 22  , value 
     "00000000",   --addr 23  , value 
     "00000000",   --addr 24  , value 
     "00000000",   --addr 25  , value 
     "00000000",   --addr 26  , value 
     "00000000",   --addr 27  , value 
     "00000000",   --addr 28  , value 
     "00000000",   --addr 29  , value 
     "00000000",   --addr 30  , value 
     "00000000"    --addr 31  , value 
   );
-------------------------------------------------------
begin
   data <= HEX2LED_ROM(to_integer(unsigned(addr)));
end arch;