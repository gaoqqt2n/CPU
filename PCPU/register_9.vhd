library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_9 is
    port(
        clk, rst : in std_logic;
        in9 : in std_logic_vector(8 downto 0);
        out9 : out std_logic_vector(8 downto 0)
    );
end register_9;

architecture rtl of register_9 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out9 <= (others => '0');
        elsif (clk'event and clk = '1') then
            out9 <= in9;
        end if;
    end process;

end;