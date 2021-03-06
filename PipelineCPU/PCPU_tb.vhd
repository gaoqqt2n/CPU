library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity pcpu_tb is  
end pcpu_tb;  
 
architecture stimulus of pcpu_tb is 
component pcpu  
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
    dut : pcpu port map(clk, rst, outdata); 
 
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
 
configuration cfg_pcpu_tb of pcpu_tb is  
    for stimulus  
    end for; 
end cfg_pcpu_tb; 
 
