library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity extend16_tb is  
end extend16_tb;  
 
architecture stimulus of extend16_tb is 
component extend16  
    port(
        clk, rst: in std_logic;
        in16 : in std_logic_vector(15 downto 0);
        out1 : out std_logic_vector(31 downto 0);
        out2 : out std_logic_vector(31 downto 0)
        );
end component; 
 
constant cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 

signal clk, rst : std_logic;  
signal in16 : std_logic_vector(15 downto 0);  
signal out1 : std_logic_vector(31 downto 0);  
signal out2 : std_logic_vector(31 downto 0);  

begin  
    dut : extend16 port map(clk, rst, in16, out1, out2);
 
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
        rst <= '0'; in16 <= "1000100010001000";
        wait for delay;
        wait for cycle; rst <= '1'; 
        wait for cycle; in16 <= "1000100010001000";
        wait for 2*cycle; in16 <= "1111111111111111";
        wait for 2*cycle; in16 <= "0000000000000000"; 
        wait for 2*cycle; in16 <= "0011111111111100"; 
        wait; 
    end process;     
 
end stimulus; 
 
configuration cfg_extend16_tb of extend16_tb is  
    for stimulus  
    end for; 
end cfg_extend16_tb; 
 
