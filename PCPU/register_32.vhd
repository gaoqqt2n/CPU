library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_1 is
    port(
        clk, rst : in std_logic;
        in32 : in std_logic_vector(31 downto 0);
        out32 : out std_logic_vector(31 downto 0)
    );
end register_1;

architecture rtl of register_1 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out32 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out32 <= in32;
        end if;
    end process;

end;