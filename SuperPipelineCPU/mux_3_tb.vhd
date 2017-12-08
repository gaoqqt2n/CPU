library IEEE;
use IEEE.std_logic_1164.all;

entity mux3_32_tb is 
end mux3_32_tb;

architecture stimulus of mux3_32_tb is
component mux3_32 
    port (
          sel : in std_logic_vector(1 downto 0); 
          in0, in1, in2 : in std_logic_vector(31 downto 0);
          out1 : out std_logic_vector(31 downto 0)
          );
end component;

signal sel : std_logic_vector(1 downto 0);
signal in0, in1, in2, out1 : std_logic_vector(31 downto 0);

begin 
    dut : mux3_32 port map(sel, in0, in1, in2, out1);

    process begin
        sel <= "00"; in0 <= x"00000004"; in1 <= x"00000005"; in2 <= x"00000006";
        wait for 100 ns;
        sel <= "01";
        wait for 100 ns;
        sel <= "10";
        wait for 100 ns;
        sel <= "00"; in0 <= x"00000007"; in1 <= x"00000008"; in2 <= x"00000009";
        wait for 100 ns;
        sel <= "01";
        wait for 100 ns;
        sel <= "10";
        wait for 100 ns;        
        wait;
    end process ; -- identifier

end stimulus;