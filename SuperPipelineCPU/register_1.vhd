library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity register_1 is
    port(
        clk, rst, in1 : in std_logic;
        out1 : out std_logic
    );
end register_1;

architecture rtl of register_1 is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            out1 <= '0';
        elsif (clk'event and clk = '1') then
            out1 <= in1;
        end if;
    end process;

end;