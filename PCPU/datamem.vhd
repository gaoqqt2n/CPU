library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity datamem is
    port(
        clk, rst, wren : in std_logic;
        address : in std_logic_vector(4 downto 0);
        indata : in std_logic_vector(31 downto 0);
        outdata : out std_logic_vector(31 downto 0)
    );
end datamem;

architecture rtl of datamem is
   subtype memword is std_logic_vector(31 downto 0);
   type memarray is array (0 to 31) of memword;
   signal memdata : memarray;
   begin
    
    process (clk, rst) begin
        if (rst = '0') then
         for i in memarray'range loop
            memdata(i) <= (others => '0');
            end loop;
        elsif (clk'event and clk = '1') then
            if (wren = '1') then
                memdata(conv_integer(address)) <= indata;
            end if;
        end if;
    end process;

    outdata <= memdata(conv_integer(address));
    
end;