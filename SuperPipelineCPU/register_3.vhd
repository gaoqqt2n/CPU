library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_3 is
    port(
        clk, rst : in std_logic;
        in3 : in std_logic_vector(2 downto 0);
        out3 : out std_logic_vector(2 downto 0)
    );
end register_3;

architecture rtl of register_3 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out3 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out3 <= in3;
        end if;
    end process;

end;