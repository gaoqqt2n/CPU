library IEEE;
use IEEE.std_logic_1164.all;

entity adder_tb is 
end adder_tb;

architecture stimulus of adder_tb is
component adder 
    port(
         address     : in   std_logic_vector(31 downto 0);
         pc_adder   : out std_logic_vector(31 downto 0)
    );
end component;

signal A, B : std_logic_vector(31 downto 0); 

begin 
    dut : adder port map(A, B);

    A <= x"00000000",
         x"00000004" after 100 ns,
         x"0000000c" after 200 ns,
         x"00000000" after 300 ns;
end stimulus;
        
