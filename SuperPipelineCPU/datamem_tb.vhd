library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity datamem_tb is  
end datamem_tb;  
 
architecture stimulus of datamem_tb is 
component datamem  
    port(
        clk, rst, we : in std_logic;
        address : in std_logic_vector(4 downto 0);
        indata : in std_logic_vector(31 downto 0);
        outdata : out std_logic_vector(31 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst, we : std_logic;  
signal address : std_logic_vector(4 downto 0);
signal indata, outdata : std_logic_vector(31 downto 0);  
 
begin  
    dut : datamem port map(clk, rst, we, address, indata, outdata); 
 
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
        rst <= '0'; we <= '0'; address <= "00000"; indata <= x"00004444";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "00000"; indata <= x"00004444";
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "00001"; indata <= x"11112222";
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "00010"; indata <= x"11112222";
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "00011"; indata <= x"11112222";
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "00100"; indata <= x"11112222";
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "01000"; indata <= x"11112222";
        wait for cycle; 
        rst <= '1'; we <= '1'; address <= "01100"; indata <= x"33338888";
        wait for cycle; 
        rst <= '1'; we <= '0'; address <= "01100"; indata <= x"33335555";
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_datamem_tb of datamem_tb is  
    for stimulus  
    end for; 
end cfg_datamem_tb; 
 
