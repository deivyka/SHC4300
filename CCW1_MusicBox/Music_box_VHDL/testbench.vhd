-- Testbench

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY musicbox_tb IS
END musicbox_tb;
 
ARCHITECTURE behavior OF musicbox_tb IS 
    COMPONENT top 
        port (  rx, clk, reset, play : IN  std_logic;
                loudspeaker : OUT  std_logic;
                leds : OUT  std_logic_vector(7 downto 0) );
    END COMPONENT;
    
    signal rx, clk, reset, play : std_logic := '0';
    signal loudspeaker : std_logic;
    signal leds : std_logic_vector(7 downto 0);
    
    constant clk_period : time := 10 ns;
    constant bit_period : time := 52083ns; -- time for 1 bit.. 1bit/19200bps = 52.08 us
    constant rx_data_ascii_B4: std_logic_vector(7 downto 0) := "01000010"; -- send Tone B4
    constant rx_data_ascii_B5: std_logic_vector(7 downto 0) := "01100010"; -- send Tone B5
    constant rx_data_ascii_C4: std_logic_vector(7 downto 0) := "01000011"; -- send Tone C4
    constant rx_data_ascii_F4: std_logic_vector(7 downto 0) := "01000110"; -- send Tone F4
    constant start_tune: std_logic_vector(7 downto 0) := "00101000"; -- start of tune '('
    constant end_tune: std_logic_vector(7 downto 0) := "00101001"; -- end of tune ')'
    
 
BEGIN
    uut: top PORT MAP 
        ( rx => rx,
 clk => clk,
          reset => reset,
          loudspeaker => loudspeaker,
          play => play,
 leds => leds );
    
    clk_process: process begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process begin		
        reset <= '1';
        play <= '0';
        wait for 100 ns;
        reset <= '0';
        rx <= '1';
        wait for clk_period;
        
        -- Send start of tune '('
        rx <= '0';		-- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= start_tune(i); -- 8 data bits
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;
        rx <= '1';  -- idle
        wait for clk_period*10; 
        
 
        -- Test Tone B5
        rx <= '0'; -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_data_ascii_B5(i);
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;       
        rx <= '1'; -- idle
        wait for clk_period*10; 
        
     
        -- Test Tone C4
        rx <= '0'; -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_data_ascii_C4(i);
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;
        rx <= '1'; -- idle
        wait for clk_period*10; 

        
        -- Test Tone F4
        rx <= '0'; -- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= rx_data_ascii_F4(i);
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;
        rx <= '1'; -- idle
        wait for clk_period*10; 
        
        
        -- Send end of tune ')'
        rx <= '0';		-- start bit
        wait for bit_period;
        for i in 0 to 7 loop
            rx <= end_tune(i);
                wait for bit_period;
        end loop;
        rx <= '1'; -- stop bit
        wait for bit_period;
        rx <= '1';  -- idle
        wait for clk_period*10; 

        
        play <= '1';
        wait for clk_period*10;
        play <= '0';
        wait for  clk_period*1000000;
        play <= '1';
        wait for clk_period*10000000;
        play <= '0';
        wait for clk_period;		
        wait;
    end process;
END;
