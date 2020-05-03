-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- Group 2: V. Hansen, B. Karna, D. Kazokas, L. Mozaffari
-- Array Sorter Top-module

-- Based on:
    -- https://hackaday.com/2016/01/20/a-linear-time-sorting-algorithm-for-fpgas/
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-------------------------------------------------
entity sort_top is
    generic ( num_cells  : integer := 64; 
              data_width : integer := 8 );
    
    port ( clk, rst       : in std_logic;
           from_ROM       : in std_logic_vector(7 downto 0);
           sorted_data    : out std_logic_vector(data_width-1 downto 0) );
end sort_top;
-------------------------------------------------
architecture arch of sort_top is
    component sorting_cell
        generic (data_width : integer := 8);
        
        port ( clk, rst           : in std_logic;
               unsorted_data      : in std_logic_vector(data_width-1 downto 0);
               pre_data           : in std_logic_vector(data_width-1 downto 0);
               pre_full, pre_push : in boolean;
               nxt_data           : out std_logic_vector(data_width-1 downto 0);
               nxt_full, nxt_push : out boolean );
    end component;
-------------------------------------------------
    type data_arr is array(0 to num_cells-1) of std_logic_vector(data_width-1 downto 0);
    type full_arr is array(0 to num_cells-1) of boolean;
    type push_arr is array(0 to num_cells-2) of boolean;
-------------------------------------------------
    signal data : data_arr; -- cell data
    signal full : full_arr; -- full/occupied cell
    signal push : push_arr;
    signal clr_data_in, inc_data_in : std_logic; 
-------------------------------------------------
begin
----------------------------------------------------------
    sorting_data : for n in 0 to num_cells-1 generate
        -- First cell
        first_cell : if n = 0 generate
            begin first_cell : sorting_cell 
                port map ( clk=>clk, rst=>rst, 
                           unsorted_data=>from_ROM,
                           pre_data=>(others=>'0'), -- pre_data doesn't exist 
                           pre_full=>true,
                           pre_push=>false,
                           nxt_data=>data(n),
                           nxt_full=>full(n),
                           nxt_push=>push(n) );
        end generate first_cell;
--------------------------------------
        -- Last cell
        last_cell : if n = num_cells-1 generate
            begin last_cell : sorting_cell 
                port map ( clk=>clk, rst=>rst, 
                           unsorted_data=>from_ROM,
                           pre_data=>data(n-1),
                           pre_full=>full(n-1),
                           pre_push=>push(n-1),
                           nxt_data=>sorted_data, -- output of the last cell will be the sorted data 
                           nxt_full=>full(n) );
        end generate last_cell;
--------------------------------------
        -- Regular cells ( i.e. the cells between the first and last cell)
        regular_cells : if (n/=0) AND (n/=num_cells-1) generate
            begin regular_cells : sorting_cell 
                port map ( clk=>clk, rst=>rst, 
                           unsorted_data=>from_ROM,
                           pre_data=>data(n-1),
                           pre_full=>full(n-1),
                           pre_push=>push(n-1),
                           nxt_data=>data(n),
                           nxt_full=>full(n),
                           nxt_push=>push(n) );
            end generate regular_cells;
    end generate sorting_data;
end arch;