library IEEE;
use IEEE.std_logic_1164.all;  
 
entity adsel_tb is  
end adsel_tb;  
 
architecture stimulus of adsel_tb is 
component adsel  
    port(
        clk, rst : in std_logic; 
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend26 : in std_logic_vector(27 downto 0); 
        pc4, extend16 : in std_logic_vector(31 downto 0);
        ifdebugout : out std_logic_vector(7 downto 0);
        next_address : out std_logic_vector(31 downto 0)
        );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 

signal clk, rst : std_logic;
signal adsel_ctrl, hactrl : std_logic_vector(1 downto 0);  
signal extend26 : std_logic_vector(27 downto 0);  
signal pc4, extend16 : std_logic_vector(31 downto 0);
signal ifdebugout : std_logic_vector(7 downto 0);
signal next_address : std_logic_vector(31 downto 0);
 
begin  
    dut : adsel port map(clk, rst, adsel_ctrl, hactrl, extend26, pc4, extend16, ifdebugout, next_address); 
 
    process begin    
    clock : for I in 0 to 20 loop 
            CLK <= transport '0'; 
            wait for half_cycle; 
            CLK <= transport '1'; 
            wait for half_cycle; 
        end loop;  
        wait; 
    end process; 

     process begin  
        rst <= '0'; hactrl <= "00"; adsel_ctrl <= "00"; extend26 <= x"8888888"; pc4 <= x"11111118"; extend16 <= x"33333333"; 
        wait for cycle; 
        rst <= '1'; hactrl <= "01"; adsel_ctrl <= "00"; extend26 <= x"4444444"; pc4 <= x"44444444"; extend16 <= x"55555555";
        wait for cycle; 
        hactrl <= "10"; adsel_ctrl <= "00"; extend26 <= x"ccccccc"; pc4 <= x"00000008"; extend16 <= x"88888888";      
        wait for cycle; 
        hactrl <= "11"; adsel_ctrl <= "00"; extend26 <= x"4444444"; pc4 <= x"88888888"; extend16 <= x"00005555"; 
        wait for cycle; 
        hactrl <= "00"; adsel_ctrl <= "00"; extend26 <= x"ccccccc"; pc4 <= x"00001111"; extend16 <= x"00008888";      
        wait for cycle; 
        hactrl <= "00"; adsel_ctrl <= "01"; extend26 <= x"fffffff"; pc4 <= x"20000000"; extend16 <= x"44444444";        
        wait for cycle; 

        hactrl <= "00"; adsel_ctrl <= "00"; extend26 <= x"8888888"; pc4 <= x"11111118"; extend16 <= x"33333333"; 
        wait for cycle; 
        hactrl <= "01"; adsel_ctrl <= "00"; extend26 <= x"4444444"; pc4 <= x"44444444"; extend16 <= x"55555555"; 
        wait for cycle; 
        hactrl <= "10"; adsel_ctrl <= "00"; extend26 <= x"ccccccc"; pc4 <= x"00000008"; extend16 <= x"88888888";      
        wait for cycle; 
        hactrl <= "11"; adsel_ctrl <= "00"; extend26 <= x"fffffff"; pc4 <= x"20000000"; extend16 <= x"44444444";        
        wait for cycle; 
        
        hactrl <= "00"; adsel_ctrl <= "00"; extend26 <= x"8888888"; pc4 <= x"11111118"; extend16 <= x"33333333"; 
        wait for cycle; 
        hactrl <= "01"; adsel_ctrl <= "00"; extend26 <= x"4444444"; pc4 <= x"44444444"; extend16 <= x"55555555"; 
        wait for cycle; 
        hactrl <= "10"; adsel_ctrl <= "00"; extend26 <= x"ccccccc"; pc4 <= x"00000008"; extend16 <= x"88888888";      
        wait for cycle; 
        hactrl <= "11"; adsel_ctrl <= "00"; extend26 <= x"fffffff"; pc4 <= x"20000000"; extend16 <= x"44444444";        
        wait for cycle; 

        hactrl <= "00"; adsel_ctrl <= "00"; extend26 <= x"8888888"; pc4 <= x"11111118"; extend16 <= x"33333333"; 
        wait for cycle; 
        hactrl <= "01"; adsel_ctrl <= "00"; extend26 <= x"4444444"; pc4 <= x"44444444"; extend16 <= x"55555555"; 
        wait for cycle; 
        hactrl <= "10"; adsel_ctrl <= "00"; extend26 <= x"ccccccc"; pc4 <= x"00000008"; extend16 <= x"88888888";      
        wait for cycle; 
        hactrl <= "11"; adsel_ctrl <= "00"; extend26 <= x"fffffff"; pc4 <= x"20000000"; extend16 <= x"44444444";        
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_adsel_tb of adsel_tb is  
    for stimulus  
    end for; 
end cfg_adsel_tb; 
 
