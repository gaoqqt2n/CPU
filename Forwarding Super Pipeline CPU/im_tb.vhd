library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity im_tb is  
end im_tb;  
 
architecture stimulus of im_tb is 
component im  
port(
    address : in std_logic_vector(5 downto 0);
    inst : out std_logic_vector(31 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal address : std_logic_vector(5 downto 0);  
signal inst : std_logic_vector(31 downto 0);  
 
begin  
    dut : im port map(address, inst);
 
    process begin
        address <= "000000";
        wait for delay; 
        address <= "000001";
        wait for cycle;
        address <= "000010";
        wait for cycle;
        address <= "000011";
        wait for cycle;
        address <= "000100";
        wait for cycle;
        address <= "000101";
        wait for cycle;
        address <= "000110";
        wait for cycle;
        address <= "000111";
        wait for cycle;
        address <= "001000";
        wait for cycle;
        address <= "001001";
        wait for cycle;
        address <= "001010";
        wait for cycle;
        address <= "001011";
        wait for cycle;
        address <= "001100";
        wait for cycle;
        address <= "001101";
        wait for cycle;
        address <= "001110";
        wait for cycle;
        address <= "001111";
        wait for cycle;
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_im_tb of im_tb is  
    for stimulus  
    end for; 
end cfg_im_tb; 
 
