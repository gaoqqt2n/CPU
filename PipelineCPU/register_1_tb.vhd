library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity register_1_tb is  
end register_1_tb;  
 
architecture stimulus of register_1_tb is 
component register_1  
    port( 
        clk, rst, in1 : in std_logic; 
        out1 : out std_logic
    ); 
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst, in1 : std_logic;  
signal out1 : std_logic;  
 
begin  
    dut : register_1 port map(clk, rst, in1, out1);
 
    process begin    
 
    clock : for I in 0 to 9 loop 
        CLK <= transport '0'; 
        wait for cycle;
        CLK <= transport '1'; 
        wait for cycle; 
        end loop;  
        wait; 
    end process; 
 
     process begin  
        in1 <= '0'; rst <= '0';
        wait for delay; 
        wait for cycle;
        in1 <= '1'; 
        wait for cycle;
        in1 <= '0';rst <= '1';
        wait for cycle;
        in1 <= '1';
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_register_1_tb of register_1_tb is  
    for stimulus  
    end for; 
end cfg_register_1_tb; 
 
