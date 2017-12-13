library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity memo_tb is  
end memo_tb;  
 
architecture stimulus of memo_tb is 
component memo  
    port( 
        clk, rst, we : in std_logic; 
        next_address : in std_logic_vector(31 downto 0); 
        address : out std_logic_vector(31 downto 0) 
    ); 
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst, we : std_logic;  
signal next_address, address : std_logic_vector(31 downto 0);  
 
begin  
    dut : memo port map(clk, rst, we, next_address, address); 
 
    process begin    
 
    clock : for I in 0 to 9 loop 
            CLK <= transport '0'; 
            wait for half_cycle; 
            CLK <= transport '1'; 
            wait for half_cycle; 
        end loop;  
        wait; 
    end process; 
 
     process begin  
        next_address <= x"00000004"; rst <= '0'; we <= '0'; 
        wait for delay; 
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_memo_tb of memo_tb is  
    for stimulus  
    end for; 
end cfg_memo_tb; 
 
