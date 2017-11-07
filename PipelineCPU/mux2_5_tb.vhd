library IEEE;
use IEEE.std_logic_1164.all;

entity mux2_5_tb is 
end mux2_5_tb;

architecture stimulus of mux2_5_tb is
component mux2_5 
    port (
          sel : in std_logic; 
          in0, in1 : in std_logic_vector(4 downto 0);
          out1 : out std_logic_vector(4 downto 0)
          );
end component;

signal sel : std_logic;
signal in0, in1, out1 : std_logic_vector(4 downto 0);

begin 
    dut : mux2_5 port map(sel, in0, in1, out1);

    process begin
        sel <= '0'; in0 <= "00111"; in1 <= "00000";
        wait for 100 ns;
        sel <= '1';
        wait for 100 ns;
        sel <= '0'; in0 <= "00001"; in1 <= "00010";
        wait for 100 ns;
        sel <= '1';
        wait for 100 ns;
        wait;
    end process ; -- identifier

end stimulus;