library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity regfile is
    port(
        clk, rst, we : in std_logic;
        wad, rad1, rad2 : in std_logic_vector(4 downto 0);
        indata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end regfile;

architecture rtl of regfile is
   subtype regword is std_logic_vector(31 downto 0);
   type regarray is array (0 to 31) of regword;
   signal regdata : regarray;
   begin
    
    process (clk, rst) 
    variable tmp : std_logic_vector(31 downto 0) := x"00000000";
    begin
        if (rst = '0') then
            for i in regarray'range loop
                regdata(i) <= (others => '0');
                tmp := (others => '0');
                out1 <= (others => '0');
                out2 <= (others => '0');
            end loop;
        elsif (clk'event and clk = '1') then
            if (we = '1' and wad /= "00000") then
                regdata(conv_integer(wad)) <= indata;
                tmp := indata;
            end if;
            if (wad = rad1) then
                out1 <= tmp;
                out2 <= regdata(conv_integer(rad2));
            elsif (wad = rad2) then 
                out1 <= regdata(conv_integer(rad1));
                out2 <= tmp;
            elsif (wad = rad1 and rad1 = rad2) then 
                out1 <= tmp;
                out2 <= tmp;
            else
                out1 <= regdata(conv_integer(rad1));
                out2 <= regdata(conv_integer(rad2));
            end if;
        end if;
    end process;

end;