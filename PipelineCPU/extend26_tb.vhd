library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity extend26_tb is  
end extend26_tb;  
 
architecture stimulus of extend26_tb is 
component extend26  
    port(
        clk, rst: in std_logic;
        in26 : in std_logic_vector(25 downto 0);
        out32 : out std_logic_vector(27 downto 0)
        );
end component; 
 
constant cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 

signal clk, rst : std_logic;  
signal in26 : std_logic_vector(25 downto 0);  
signal out32 : std_logic_vector(27 downto 0);  

begin  
    dut : extend26 port map(clk, rst, in26, out32);
 
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
        rst <= '0'; in26 <= "01000100010001000100010001";
        wait for delay;
        wait for cycle; rst <= '1'; 
        wait for cycle; in26 <= "10100010001000100010001000";
        wait for 2*cycle; in26 <= "11111111111111111111111111";
        wait for 2*cycle; in26 <= "00000000000000000000000000"; 
        wait; 
    end process;     
 
end stimulus; 
 
configuration cfg_extend26_tb of extend26_tb is  
    for stimulus  
    end for; 
end cfg_extend26_tb; 
 
