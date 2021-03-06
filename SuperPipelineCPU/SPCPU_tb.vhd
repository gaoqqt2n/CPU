library IEEE; 
use IEEE.std_logic_1164.all;  

use IEEE.std_logic_textio.all;
library STD;
use STD.textio.all;
 
entity spcpu_tb is  
end spcpu_tb;  
 
architecture stimulus of spcpu_tb is 
component spcpu  
    port(
        clk, rst : in std_logic;
        outdata : out std_logic_vector(31 downto 0)
        );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;  
signal outdata : std_logic_vector(31 downto 0);  
 
begin  
    dut : spcpu port map(clk, rst, outdata);
 
    process begin    
 
    clock : for I in 0 to 900 loop 
            CLK <= transport '0'; 
            wait for half_cycle; 
            CLK <= transport '1'; 
            wait for half_cycle; 
        end loop;  
        wait; 
    end process; 

     process begin  
        rst <= '0';
        wait for delay; 
        wait for cycle; 
        rst <= '1';
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_spcpu_tb of spcpu_tb is  
    for stimulus  
    end for; 
end cfg_spcpu_tb; 
 
