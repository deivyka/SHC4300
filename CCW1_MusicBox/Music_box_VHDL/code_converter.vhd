-- Code Converter
-- ASCII to notes (octave 4 & 5)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity CodeConverter is
    port ( from_dout : in  STD_LOGIC_VECTOR (7 downto 0); -- ASCII in
           to_m_in : out  STD_LOGIC_VECTOR (17 downto 0) ); -- Note out
end CodeConverter;

architecture arch of CodeConverter is
begin
    process(from_dout) begin		
	   case from_dout is						
		    when "01000011" =>   to_m_in <= "101110101010001001"; -- ASCII: C | Note: C4
		    when "01000100" =>   to_m_in <= "101001100100010110"; -- ASCII: D | Note: D4
		    when "01000101" =>   to_m_in <= "100101000010000110"; -- ASCII: E | Note: E4 
		    when "01000110" =>   to_m_in <= "100010111101000101"; -- ASCII: F | Note: F4
		    when "01000111" =>   to_m_in <= "011111001001000001"; -- ASCII: G | Note: G4 
		    when "01000001" =>   to_m_in <= "011011101111100100"; -- ASCII: A | Note: A4
		    when "01000010" =>   to_m_in <= "011000101101110111"; -- ASCII: B | Note: B4 
			   
		    when "01100011" =>   to_m_in <= "010111010101000100"; -- ASCII: c | Note: C5
		    when "01100100" =>   to_m_in <= "010100110010001011"; -- ASCII: d | Note: D5 
		    when "01100101" =>   to_m_in <= "010010100001000011"; -- ASCII: e | Note: E5 
		    when "01100110" =>   to_m_in <= "010001011110100010"; -- ASCII: f | Note: F5 
		    when "01100111" =>   to_m_in <= "001111100100100000"; -- ASCII: g | Note: G5 
		    when "01100001" =>   to_m_in <= "001101110111110010"; -- ASCII: a | Note: A5 
		    when "01100010" =>   to_m_in <= "001100010110111011"; -- ASCII: b | Note: B5 
		    when others     =>   to_m_in <= "000000000000000001";    
	   end case; 
    end process; 
end arch;
