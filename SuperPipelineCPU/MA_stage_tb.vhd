library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity ma_stage_tb is  
end ma_stage_tb;  
 
architecture stimulus of ma_stage_tb is 
component ma_stage  
    port(
        clk, rst : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        ctrlout_3 : in std_logic_vector(2 downto 0);
        aluout, rtdata : in std_logic_vector(31 downto 0);
        regwe : out std_logic;
        regwad : out std_logic_vector(4 downto 0); -- regfile write address
        outdata : out std_logic_vector(31 downto 0) --regfile in data
        );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
 signal clk, rst : std_logic;
 signal wad : std_logic_vector(4 downto 0);
 signal ctrlout_3 : std_logic_vector(2 downto 0);
 signal aluout, rtdata : std_logic_vector(31 downto 0);
 signal regwe : std_logic;
 signal regwad : std_logic_vector(4 downto 0);
 signal outdata : std_logic_vector(31 downto 0);
 
begin  
    dut : ma_stage port map(clk, rst, wad, ctrlout_3, aluout, rtdata, regwe, regwad, outdata); 
 
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
        rst <= '0'; wad <= "00010"; ctrlout_3 <= "011"; aluout <= x"00000006"; rtdata <= x"00001111";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; wad <= "00100"; ctrlout_3 <= "100"; aluout <= x"00000006"; rtdata <= x"00001111";
        wait for cycle; 
        rst <= '1'; wad <= "00011"; ctrlout_3 <= "001"; aluout <= x"00000006"; rtdata <= x"00002222"; --
        wait for cycle; 
        rst <= '1'; wad <= "00001"; ctrlout_3 <= "010"; aluout <= x"00000006"; rtdata <= x"00001111";
        wait for cycle; 
        rst <= '1'; wad <= "00010"; ctrlout_3 <= "000"; aluout <= x"00000004"; rtdata <= x"00001111";
        wait for cycle; 
        rst <= '1'; wad <= "00010"; ctrlout_3 <= "000"; aluout <= x"0000000c"; rtdata <= x"00001111";
        wait for cycle; 
        rst <= '1'; wad <= "00010"; ctrlout_3 <= "011"; aluout <= x"0000000c"; rtdata <= x"00001111";
        wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_ma_stage_tb of ma_stage_tb is  
    for stimulus  
    end for; 
end cfg_ma_stage_tb; 
 
