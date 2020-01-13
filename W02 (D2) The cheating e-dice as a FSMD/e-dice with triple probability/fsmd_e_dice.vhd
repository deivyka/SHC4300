library	ieee;
use	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity fsmd_e_dice is
   port(
      clk, reset, stop, mode: in std_logic;
      result: in std_logic_vector(2 downto 0)  -- Selected result
      );
end fsmd_e_dice;

architecture arch of fsmd_e_dice is
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
      when state1 =>                                    -- Remain in the same state if stop is pressed
        if (stop='1') then                              
            state_next <= state1;
        elsif (mode = '1') then                         -- In cheating mode 
            if (result_count = unsigned(result)) then   -- when result counter matches selected result  
                if (trprob_count = "00") then           -- reset triple probability counter and increment result
                    trprob_count <= "10";
                    result_count <= result_count +1;
                    if (result_count = "110") then
                        result_count <= "001";       
                        state_next <= state1;        
                    else                             
                        state_next <= state1;           
                    end if;                          
                else
                    trprob_count <= trprob_count -1;    -- decrement triple probability counter
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
        else                                            -- When no cheating is selected increment result counter
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