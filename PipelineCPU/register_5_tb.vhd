library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity register_5_tb is  
end register_5_tb;  
 
architecture stimulus of register_5_tb is 
component register_5  
    port( 
        clk, rst : in std_logic; 
        in5 : in std_logic_vector(4 downto 0);
        out5 : out std_logic_vector(4 downto 0)
    ); 
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;
signal in5 : std_logic_vector(4 downto 0);  
signal out5 : std_logic_vector(4 downto 0);  
 
begin  
    dut : register_5 port map(clk, rst, in5, out5);
 
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
        in5 <= "00000"; rst <= '0';
        wait for delay; 
        wait for cycle;
        in5 <= "11001"; 
        wait for cycle;
        in5 <= "10010";rst <= '1';
        wait for cycle;
        in5 <= "11111";
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_register_5_tb of register_5_tb is  
    for stimulus  
    end for; 
end cfg_register_5_tb; 
 
