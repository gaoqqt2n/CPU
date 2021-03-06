library IEEE;
use IEEE.std_logic_1164.all;

entity mux2_32_tb is 
end mux2_32_tb;

architecture stimulus of mux2_32_tb is
component mux2_32 
    port (
          sel : in std_logic; 
          in0, in1 : in std_logic_vector(31 downto 0);
          out1 : out std_logic_vector(31 downto 0)
          );
end component;

signal sel : std_logic;
signal in0, in1, out1 : std_logic_vector(31 downto 0);

begin 
    dut : mux2_32 port map(sel, in0, in1, out1);

    process begin
        sel <= '0'; in0 <= x"00000004"; in1 <= x"00000005";
        wait for 100 ns;
        sel <= '1';
        wait for 100 ns;
        sel <= '0'; in0 <= x"00000007"; in1 <= x"00000008";
        wait for 100 ns;
        sel <= '1';
        wait for 100 ns;
        wait;
    end process ; -- identifier

end stimulus;