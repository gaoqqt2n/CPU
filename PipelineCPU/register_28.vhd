library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_28 is
    port(
        clk, rst : in std_logic;
        in28 : in std_logic_vector(27 downto 0);
        out28 : out std_logic_vector(27 downto 0)
    );
end register_28;

architecture rtl of register_28 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out28 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out28 <= in28;
        end if;
    end process;

end;