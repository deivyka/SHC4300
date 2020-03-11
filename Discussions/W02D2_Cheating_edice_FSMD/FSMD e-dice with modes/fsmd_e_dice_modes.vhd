-- 00: No cheating, 01: Forbidden result, 10: Fixed result, 11: Triple probability
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsmd_e_dice_modes is
   port(
      clk, reset, stop: in std_logic;
      mode: in std_logic_vector (1 downto 0);       -- selected mode
      result: in std_logic_vector(2 downto 0);      -- selected result
      sseg, led: out std_logic_vector(6 downto 0);  -- 7 segment dispaly
      anode: out std_logic_vector(3 downto 0)       -- anode for 7 segment display
      );
end fsmd_e_dice_modes;

architecture arch of fsmd_e_dice_modes is
-- internal signals   
   type state_type is (state0, state1);             -- Signal declaration for FSM
   signal state_reg, state_next: state_type;
   signal result_reg, result_next: unsigned(2 downto 0);    -- result counter
   signal trprob_reg, trprob_next: unsigned(1 downto 0);    -- triple probability counter

   
-- ********** BEGIN **********
begin
-- clock process
process(clk, reset)
begin
    if(reset = '1') then                -- asynchronous reset
        state_reg <= state0;
        result_reg <= (others => '0');
        trprob_reg <= (others => '0');
    elsif rising_edge(clk) then         -- synchronous update
        state_reg <= state_next;
        result_reg <= result_next;
        trprob_reg <= trprob_next;
    end if;
end process;

-- next-state logic process
process(state_reg, stop, mode, result_reg, trprob_reg)
begin
    state_next <= state_reg;            
    result_next <= result_reg;
    trprob_next <= trprob_reg;
   
   case state_reg is
      -- State 0 -------------------- 
      when state0 =>
        result_next<="001";
        trprob_next<="10";
        state_next <= state1;
      
      -- State 1 --------------------  
      when state1 =>      
        if (stop='1') then                              -- stop is pressed 
            if (mode = "10") then                       -- predefined result
                result_next <= unsigned(result);
            elsif (result_reg = unsigned(result)) then  -- forbidden result
                result_next <= result_reg + 1;
                if (result_reg = "110") then            -- result owerflow
                    result_next <= "001";
                end if;
            end if;
        elsif (mode = "11") then                        -- triple probability
            if (result_reg = unsigned(result)) then
                if (trprob_reg = "00") then
                    trprob_next <= "10";
                    result_next <= result_reg +1;
                    if (result_reg = "110") then        -- result owerflow
                        result_next <= "001";
                    end if;
                else
                    trprob_next <= trprob_reg -1;
                end if;
            else
                result_next <= result_reg +1;
                    if (result_reg = "110") then        -- result owerflow
                        result_next <= "001";
                    end if;
            end if;
        else                                            -- if stop is not pressed then increment in forbidden and predifined modes
            result_next <= result_reg +1;
                if (result_reg = "110") then            -- result owerflow  
                    result_next <= "001";                     
                end if;                              
        end if;
    end case;        
end process;

-- Process for 7-seg display decoding
    anode <= "0111";
    sseg <= 
      -- abcdefg
        "1001111" when (result_reg = 1) else  --1
        "0010010" when (result_reg = 2) else  --2
        "0000110" when (result_reg = 3) else  --3
        "1001100" when (result_reg = 4) else  --4
        "0100100" when (result_reg = 5) else  --5
        "0100000";                            --6

-- Process for led decoding   
    led <=                 
        "0000001" when (result_reg = 1) else  --1
        "0000011" when (result_reg = 2) else  --2
        "0000111" when (result_reg = 3) else  --3
        "0001111" when (result_reg = 4) else  --4
        "0011111" when (result_reg = 5) else  --5
        "0111111";                            --6 

end arch;