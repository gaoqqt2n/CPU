library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_7 is
    port(
        clk, rst : in std_logic;
        in7 : in std_logic_vector(6 downto 0);
        out7 : out std_logic_vector(6 downto 0)
    );
end register_7;

architecture rtl of register_7 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out7 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out7 <= in7;
        end if;
    end process;

end;