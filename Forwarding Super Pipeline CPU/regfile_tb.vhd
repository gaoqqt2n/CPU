library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity regfile_tb is  
end regfile_tb;  
 
architecture stimulus of regfile_tb is 
component regfile  
    port(
        clk, rst, we : in std_logic;
        wad, rad1, rad2 : in std_logic_vector(4 downto 0);
        indata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst, we : std_logic;  
signal wad, rad1, rad2 : std_logic_vector(4 downto 0);
signal indata : std_logic_vector(31 downto 0);
signal out1, out2 : std_logic_vector(31 downto 0);
 
begin  
    dut : regfile port map(clk, rst, we, wad, rad1, rad2, indata, out1, out2); 
 
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
        rst <= '0'; we <= '0'; wad <= "00001"; rad1 <= "00001"; rad2 <= "00010"; indata <= x"cccc3333";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; we <= '0'; wad <= "00001"; rad1 <= "00010"; rad2 <= "00011"; indata <= x"cccc3333"; 
        wait for cycle; 
        rst <= '1'; we <= '1'; wad <= "00001"; rad1 <= "00001"; rad2 <= "00100"; indata <= x"cccc3333"; 
        wait for cycle; 
        rst <= '1'; we <= '1'; wad <= "10010"; rad1 <= "10010"; rad2 <= "00001"; indata <= x"00001111"; 
        wait for cycle; 
        rst <= '0'; we <= '1'; wad <= "10000"; rad1 <= "10000"; rad2 <= "10010"; indata <= x"aaaa0000"; 
        wait for cycle; 
        rst <= '1'; we <= '1'; wad <= "11111"; rad1 <= "11111"; rad2 <= "10000"; indata <= x"bbbb0000"; 
        wait for cycle; 
        rst <= '1'; we <= '1'; wad <= "00000"; rad1 <= "00000"; rad2 <= "11111"; indata <= x"11111111"; 
        wait for cycle; 
        rst <= '1'; we <= '0'; wad <= "01100"; rad1 <= "00001"; rad2 <= "00000"; indata <= x"22225555"; 
        wait for cycle; 
        
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_regfile_tb of regfile_tb is  
    for stimulus  
    end for; 
end cfg_regfile_tb; 
 
