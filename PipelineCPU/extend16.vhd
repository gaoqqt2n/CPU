library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  extend16  is
    port(
        clk, rst: in std_logic;
        in16 : in std_logic_vector(15 downto 0);
        out1 : out std_logic_vector(31 downto 0); --adsel
        out2 : out std_logic_vector(31 downto 0)); --alu
    
end extend16;

architecture  rtl  of  extend16  is
begin
   
    process (clk, rst) begin
        if (rst = '0') then
            out1 <= (others => '0');
            out2 <= (others => '0');
        elsif (clk'event and clk = '1') then
            if(in16(15) = '1') then
                out1 <= shl(x"ffff" & in16, "10");
            else
                out1 <= shl(x"0000" & in16, "10");     
            end if;        
            out2 <= x"0000" & in16;  
        end if;
    end process;

end;
