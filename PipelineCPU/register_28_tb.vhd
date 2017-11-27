library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity register_28_tb is  
end register_28_tb;  
 
architecture stimulus of register_28_tb is 
component register_28  
    port( 
        clk, rst : in std_logic; 
        in28 : in std_logic_vector(27 downto 0);
        out28 : out std_logic_vector(27 downto 0)
    ); 
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;
signal in28 : std_logic_vector(27 downto 0);  
signal out28 : std_logic_vector(27 downto 0);  
 
begin  
    dut : register_28 port map(clk, rst, in28, out28);
 
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
        in28 <= x"0000000"; rst <= '0';
        wait for delay; 
        wait for cycle;
        in28 <= x"0011001"; 
        wait for cycle;
        in28 <= x"0010010";rst <= '1';
        wait for cycle;
        in28 <= x"0011111";
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_register_28_tb of register_28_tb is  
    for stimulus  
    end for; 
end cfg_register_28_tb; 
 
