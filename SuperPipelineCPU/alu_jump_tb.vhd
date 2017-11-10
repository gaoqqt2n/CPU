library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity alu_jump_tb is  
end alu_jump_tb;  
 
architecture stimulus of alu_jump_tb is 
component alu_jump  
    port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        adsel_ctrl : out std_logic_vector(1 downto 0)
    );
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal rst : std_logic;
signal adsel_ctrl : std_logic_vector(1 downto 0);  
signal aluctrl : std_logic_vector(3 downto 0);  
signal in1, in2 : std_logic_vector(31 downto 0);
 
begin  
    dut : alu port map(rst, aluctrl, in1, in2, adsel_ctrl); 
 
    process begin  
        rst <= '0'; aluctrl <= "0000"; shamt <= "00010"; in1 <= x"00000004"; in2 <= x"00000006";
        wait for delay; 
        wait for cycle; 
        rst <= '1';
        wait for cycle; 
        aluctrl <= "0000"; shamt <= "00010"; in1 <= x"00000008"; in2 <= x"00000006"; --add
        wait for cycle; 
        aluctrl <= "0001"; shamt <= "00010"; in1 <= x"00000008"; in2 <= x"00000006"; --sub
        wait for cycle; 
        aluctrl <= "0010"; shamt <= "00010"; in1 <= x"0000000c"; in2 <= x"0000000a"; --and
        wait for cycle; 
        aluctrl <= "0011"; shamt <= "00010"; in1 <= x"0000000c"; in2 <= x"0000000a"; --or
        wait for cycle; 
        aluctrl <= "0100"; shamt <= "00010"; in1 <= x"0000000c"; in2 <= x"0000000a"; --nor
        wait for cycle; 
        aluctrl <= "0101"; shamt <= "00010"; in1 <= x"0000000c"; in2 <= x"0000000a"; --xor
        wait for cycle; 
        aluctrl <= "1000"; shamt <= "00010"; in1 <= x"c000000d"; in2 <= x"00000006"; --sll
        wait for cycle; 
        aluctrl <= "1001"; shamt <= "00010"; in1 <= x"c000000d"; in2 <= x"00000006"; --srl
        wait for cycle; 
        aluctrl <= "1010"; shamt <= "00010"; in1 <= x"c000000d"; in2 <= x"0000000c"; --sra
        wait for cycle;
        aluctrl <= "1100"; shamt <= "00010"; in1 <= x"00000005"; in2 <= x"00000002"; --set on less than
        wait for cycle;
        aluctrl <= "1100"; shamt <= "00010"; in1 <= x"00000005"; in2 <= x"00000005"; --set on less than
        wait for cycle;
        aluctrl <= "1100"; shamt <= "00010"; in1 <= x"00000005"; in2 <= x"0000000a"; --set on less than
        wait for cycle;
        aluctrl <= "1101"; shamt <= "00010"; in1 <= x"00000005"; in2 <= x"00000005"; --beq
        wait for cycle;
        aluctrl <= "1101"; shamt <= "00010"; in1 <= x"00000005"; in2 <= x"0000000a"; --beq
        wait for cycle;
        aluctrl <= "0011"; shamt <= "00010"; in1 <= x"00000008"; in2 <= x"00000004"; --ld, st
        wait for cycle;
        wait; 
    end process;
 
end stimulus; 

configuration cfg_alu_jump_tb of alu_jump_tb is  
    for stimulus  
    end for; 
end cfg_alu_jump_tb; 
 
