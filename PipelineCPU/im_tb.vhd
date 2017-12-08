library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity im_tb is  
end im_tb;  
 
architecture stimulus of im_tb is 
component im  
port(
    address : in std_logic_vector(4 downto 0);
    inst : out std_logic_vector(31 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal address : std_logic_vector(4 downto 0);  
signal inst : std_logic_vector(31 downto 0);  
 
begin  
    dut : im port map(address, inst);
 
    process begin
        address <= "00000";
        wait for delay; 
        address <= "00001";
        wait for cycle;
        address <= "00010";
        wait for cycle;
        address <= "00011";
        wait for cycle;
        address <= "00100";
        wait for cycle;
        address <= "00101";
        wait for cycle;
        address <= "00110";
        wait for cycle;
        address <= "00111";
        wait for cycle;
        address <= "01000";
        wait for cycle;
        address <= "01001";
        wait for cycle;
        address <= "01010";
        wait for cycle;
        address <= "01011";
        wait for cycle;
        address <= "01100";
        wait for cycle;
        address <= "01101";
        wait for cycle;
        address <= "01110";
        wait for cycle;
        address <= "01111";
        wait for cycle;
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_im_tb of im_tb is  
    for stimulus  
    end for; 
end cfg_im_tb; 
 
