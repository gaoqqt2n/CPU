library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity id_stage_tb is  
end id_stage_tb;  
 
architecture stimulus of id_stage_tb is 
component id_stage  
    port(
        clk, rst : in std_logic;
        regwe : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        inst, wdata : in std_logic_vector(31 downto 0);
        hactrl : out std_logic_vector(1 downto 0);
        rtad, rdad, shamt : out std_logic_vector(4 downto 0);
        ctrlout : out std_logic_vector(8 downto 0);
        ex26 : out std_logic_vector(27 downto 0);
        rs, rt, ex16_1, ex16_2 : out std_logic_vector(31 downto 0)
        );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal clk, rst : std_logic;
signal regwe : std_logic;
signal wad : std_logic_vector(4 downto 0);
signal inst, wdata : std_logic_vector(31 downto 0);
signal hactrl : std_logic_vector(1 downto 0);
signal rtad, rdad, shamt : std_logic_vector(4 downto 0);
signal ctrlout : std_logic_vector(8 downto 0);
signal ex26 : std_logic_vector(27 downto 0);
signal rs, rt, ex16_1, ex16_2 : std_logic_vector(31 downto 0);

begin  
    dut : id_stage port map(clk, rst, regwe, wad, inst, wdata, hactrl, rtad, rdad, shamt, ctrlout, ex26, rs, rt, ex16_1, ex16_2) ; 
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
        rst <= '0'; regwe <= '0'; wad <= "00000"; inst <= x"00000000"; wdata <= x"00000000";
        wait for delay; 
        wait for cycle; 
        rst <= '1'; regwe <= '1'; wad <= "00011"; inst <= x"00221820"; wdata <= x"00001111"; --add 1 2 3, 00001111 3
        wait for cycle; 
        rst <= '1'; regwe <= '1'; wad <= "00001"; inst <= x"00254020"; wdata <= x"00003333"; --add 1 5 8, 00003333 1
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"8C860004"; wdata <= x"00000000"; --load 4 6 4
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00232020"; wdata <= x"00000000"; --add 1 3 4
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"ACC30004"; wdata <= x"00000000"; --store 6 3 4
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00253020"; wdata <= x"00000000"; --add 1 5 6
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00000000"; wdata <= x"00000000";
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00000000"; wdata <= x"00000000";
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00000000"; wdata <= x"00000000";
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00000000"; wdata <= x"00000000";
        wait for cycle; 
        rst <= '1'; regwe <= '0'; wad <= "00000"; inst <= x"00000000"; wdata <= x"00000000";
        wait for cycle; 

        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_id_stage_tb of id_stage_tb is  
    for stimulus  
    end for; 
end cfg_id_stage_tb; 
