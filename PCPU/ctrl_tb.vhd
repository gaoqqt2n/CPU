library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity ctrl_tb is  
end ctrl_tb;  
 
architecture stimulus of ctrl_tb is 
component ctrl  
    port( 
        clk, rst : in std_logic; 
        opcode, funct : in std_logic_vector(5 downto 0); 
        ctrl : out std_logic_vector(7 downto 0) 
    ); 
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;  
signal opcode, funct : std_logic_vector(5 downto 0);  
signal ctrlout : std_logic_vector(7 downto 0);  
 
begin  
    dut : ctrl port map(clk, rst, opcode, funct, ctrlout); 
 
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
        rst <= '0'; opcode <= "000000"; funct <= "000000";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; 
        wait for cycle; 
        rst <= '1'; opcode <= "100011"; 
        wait for cycle; 
        rst <= '1'; opcode <= "101011"; 
        wait for cycle; 
        rst <= '1'; opcode <= "000100"; 
        wait for cycle; 
        rst <= '1'; opcode <= "000010"; 
        wait for cycle; 
        rst <= '1'; opcode <= "011100"; 
        wait for cycle; 
        rst <= '0'; opcode <= "100011"; 
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; 
        wait for cycle; 
        rst <= '1'; opcode <= "000010"; 
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "000000";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "000001";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "000011";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "100000";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "100010";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "100100";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "100101";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "100110";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "100111";
        wait for cycle; 
        rst <= '1'; opcode <= "000000"; funct <= "101010";
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_ctrl_tb of ctrl_tb is  
    for stimulus  
    end for; 
end cfg_ctrl_tb; 
 
