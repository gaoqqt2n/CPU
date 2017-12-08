library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity if_stage_tb is  
end if_stage_tb;  
 
architecture stimulus of if_stage_tb is 
component if_stage  
    port(
        clk, rst : in std_logic;
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend16 : in std_logic_vector(31 downto 0);
        extend26  : in std_logic_vector(27 downto 0);
        inst : out std_logic_vector(31 downto 0)
        );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;  
signal adsel_ctrl, hactrl : std_logic_vector(1 downto 0);
signal extend16 : std_logic_vector(31 downto 0);
signal extend26  : std_logic_vector(27 downto 0);
signal inst : std_logic_vector(31 downto 0) ;

begin  
    dut : if_stage port map(clk, rst, adsel_ctrl, hactrl, extend16, extend26, inst) ; 
 
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
        rst <= '0'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for delay; 
        wait for cycle; 
        rst <= '0'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        rst <= '1'; adsel_ctrl <= "00"; hactrl <= "00"; extend16 <= x"00000000"; extend26 <= x"0000000";
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_if_stage_tb of if_stage_tb is  
    for stimulus  
    end for; 
end cfg_if_stage_tb; 
 
