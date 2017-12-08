library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  extend26  is
    port(
        clk, rst: in std_logic;
        in26 : in std_logic_vector(25 downto 0);
        out32 : out std_logic_vector(27 downto 0));
    
end extend26;

architecture  rtl  of  extend26  is
begin
   
    process (clk, rst) begin
        if (rst = '0') then
            out32 <= (others => '0');
        elsif (clk'event and clk = '1') then
                out32 <= in26 & "00";
        end if;
    end process;

end;
