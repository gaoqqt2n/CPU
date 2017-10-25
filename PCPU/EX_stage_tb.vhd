library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity ex_stage_tb is  
end ex_stage_tb;  
 
architecture stimulus of ex_stage_tb is 
component ex_stage  
    port(
        rst : in std_logic;
        rtad, rdad, shamt : in std_logic_vector(4 downto 0);
        ctrlout : in std_logic_vector(8 downto 0);
        rsdata, rtdata, ex16 : in std_logic_vector(31 downto 0);
        adsel_ctrl : out std_logic_vector(1 downto 0);
        ctrlout_3 : out std_logic_vector(2 downto 0);
        wad : out std_logic_vector(4 downto 0);
        aluout, exout_rtdata : out std_logic_vector(31 downto 0)
        );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal rst : std_logic;
signal rtad, rdad, shamt : std_logic_vector(4 downto 0);
signal ctrlout : std_logic_vector(8 downto 0);
signal rsdata, rtdata, ex16 : std_logic_vector(31 downto 0);
signal adsel_ctrl : std_logic_vector(1 downto 0);
signal ctrlout_3 : std_logic_vector(2 downto 0);
signal wad : std_logic_vector(4 downto 0);
signal aluout, exout_rtdata : std_logic_vector(31 downto 0);
 
begin  
    dut : ex_stage port map(rst, rtad, rdad, shamt, ctrlout, rsdata, rtdata, ex16, adsel_ctrl, ctrlout_3, wad, aluout, exout_rtdata); 
 
     process begin  
        rst <= '0'; rtad <= "00001"; rdad <= "00010"; shamt <="00000"; ctrlout <= "011010001"; rsdata <= x"00002222"; rtdata <= x"00004444"; ex16 <= x"00001820";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; rtad <= "00001"; rdad <= "00010"; shamt <="00000"; ctrlout <= "010100001"; rsdata <= x"00001111"; rtdata <= x"00003333"; ex16 <= x"00001820";
        wait for cycle; 
        rst <= '1'; rtad <= "00100"; rdad <= "00111"; shamt <="00000"; ctrlout <= "011101001"; rsdata <= x"22222222"; rtdata <= x"22222222"; ex16 <= x"00000000";
        wait for cycle; 
        rst <= '1'; rtad <= "00100"; rdad <= "00111"; shamt <="00000"; ctrlout <= "001101001"; rsdata <= x"33333333"; rtdata <= x"44444444"; ex16 <= x"00000000";
        wait for cycle; 
        rst <= '1'; rtad <= "00001"; rdad <= "00010"; shamt <="00000"; ctrlout <= "011110001"; rsdata <= x"00001111"; rtdata <= x"00003333"; ex16 <= x"00001820";
        wait for cycle; 
        -- rst <= '1'; rtad <= "00001"; rdad <= "00010"; shamt <="00000"; ctrlout <= "010100011"; rsdata <= x"00001111"; rtdata <= x"00003333"; ex16 <= x"00001820";
        -- wait for cycle; 
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_ex_stage_tb of ex_stage_tb is  
    for stimulus  
    end for; 
end cfg_ex_stage_tb; 
 
