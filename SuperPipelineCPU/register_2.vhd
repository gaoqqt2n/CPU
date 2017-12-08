library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_2 is
    port(
        clk, rst : in std_logic;
        in2 : in std_logic_vector(1 downto 0);
        out2 : out std_logic_vector(1 downto 0)
    );
end register_2;

architecture rtl of register_2 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out2 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out2 <= in2;
        end if;
    end process;

end;