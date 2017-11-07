library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_5 is
    port(
        clk, rst : in std_logic;
        in5 : in std_logic_vector(4 downto 0);
        out5 : out std_logic_vector(4 downto 0)
    );
end register_5;

architecture rtl of register_5 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out5 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out5 <= in5;
        end if;
    end process;

end;