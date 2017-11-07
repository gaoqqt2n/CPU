library IEEE; 
use IEEE.std_logic_1164.all;  
 
entity stall_tb is  
end stall_tb;  
 
architecture stimulus of stall_tb is 
component stall  
port(
    inst : in std_logic_vector(31 downto 0);
    hactrl : out std_logic_vector(1 downto 0); --hold address control
    rs, rt, rd, shamt : out std_logic_vector(4 downto 0);
    opcode, funct : out std_logic_vector(5 downto 0);
    extend16 : out std_logic_vector(15 downto 0);
    extend26 : out std_logic_vector(25 downto 0)
);
end component; 
 
constant cycle  : time := 200 ns; 
constant half_cycle  : time := 100 ns; 
constant delay  : time := 20 ns; 
 
signal inst : std_logic_vector(31 downto 0);  
signal hactrl : std_logic_vector(1 downto 0);  
signal rs, rt, rd, shamt : std_logic_vector(4 downto 0);  
signal opcode, funct : std_logic_vector(5 downto 0);  
signal extend16 : std_logic_vector(15 downto 0);  
signal extend26 : std_logic_vector(25 downto 0); 
signal flagout : std_logic_vector(1 downto 0); --test 
signal brtout, brdout : std_logic_vector(4 downto 0); --test
signal bopcdout : std_logic_vector(5 downto 0); --test
 
begin  
    dut : stall port map(inst, hactrl, rs, rt, rd, shamt, opcode, funct, extend16, extend26); 
 
     process begin  
        inst <= "00000000001000100001100000100000"; --
        wait for cycle; 
        inst <= "00001000000000000000000000100000"; --
        wait for cycle;         
        inst <= "10001100100000110000000000000100";
        wait for cycle;         
        inst <= "10001100101000110000000000001000";
        wait for cycle; 
        inst <= "00000000000000000000000000100000"; --
        wait for cycle;         
        inst <= "10101100110000110000000000000100";
        wait for cycle;    
        inst <= "00000000001001010011000000100000"; --
        wait for cycle;              
        inst <= "10001100111000110000000000001100";
        wait for cycle; 
        inst <= "00000000011001000010100000100000";
        wait for cycle; 
        inst <= "10101100100001110000000000001000";
        wait for cycle; 
        inst <= "00000000000000000000000000100000"; --
        wait for cycle;         
        wait; 
     end process;     
 
end stimulus; 
 
configuration cfg_stall_tb of stall_tb is  
    for stimulus  
    end for; 
end cfg_stall_tb; 
 
