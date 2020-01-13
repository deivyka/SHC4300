library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsmd_e_dice_modes is
   port(
      clk, reset, stop: in std_logic;
      mode: in std_logic_vector (1 downto 0);
      result: in std_logic_vector(2 downto 0)  -- Selected result and mode
      );
end fsmd_e_dice_modes;

architecture arch of fsmd_e_dice_modes is
-- internal signals   
   signal result_count: unsigned(2 downto 0);
   signal trprob_count: unsigned(1 downto 0);
   type state_type is (state0, state1); -- Signal declaration for FSM
   signal state_reg, state_next: state_type;

   
-- ********** BEGIN **********
begin
-- clock register
process(clk)
begin
    if(reset = '1') then
        state_reg <= state0;  
    elsif rising_edge(clk) then
        state_reg <= state_next;    
    end if;
end process;

-- next-state logic
process(clk)
begin
   case state_reg is
      -- State 0 -------------------- 
      when state0 =>
        result_count<="001";
        trprob_count<="10";
        state_next <= state1;
      
      -- State 1 --------------------  
      when state1 =>      
        if (stop='1') then                              -- skip or 
            if (mode = "00" or mode = "11") then
                state_next <= state1;
            elsif (mode = "10") then
                result_count <= unsigned(result);
                state_next <= state1;
            elsif (result_count = unsigned(result)) then
                result_count <= result_count + 1;
                if (result_count = "110") then
                    result_count <= "001";
                    state_next <= state1;
                else
                    state_next <= state1;
                end if;
            else
                state_next <= state1;
            end if;
        elsif (mode = "00" or mode = "10") then            -- increment in these modes
            result_count <= result_count +1;
            if (result_count = "110") then
                result_count <= "001";
                state_next <= state1;
            else
                state_next <= state1;
            end if;
        elsif (mode = "11") then                            -- triple probability
            if (result_count = unsigned(result)) then
                if (trprob_count = "00") then
                    trprob_count <= "10";
                    result_count <= result_count +1;
                    if (result_count = "110") then
                        result_count <= "001";
                        state_next <= state1;
                    else
                        state_next <= state1;
                    end if;
                else
                    trprob_count <= trprob_count -1;
                    state_next <= state1;
                end if;
            else
                result_count <= result_count +1;
                    if (result_count = "110") then
                        result_count <= "001";
                        state_next <= state1;
                    else
                        state_next <= state1;
                    end if;
            end if;
        else                                                -- if no stop or mode, increment
            result_count <= result_count +1;
                if (result_count = "110") then   
                    result_count <= "001";          
                    state_next <= state1;            
                else                                 
                    state_next <= state1;            
                end if;                              
        end if;
    end case;        
end process;
end arch;