library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity datamem is
    port(
        clk, rst, we : in std_logic;
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
            memdata(0) <= x"11111111";
            memdata(1) <= x"22222222";
            memdata(2) <= x"00005555";
            for i in 3 to 31 loop
                memdata(i) <= (others => '0');
            end loop;
            outdata <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (we = '1') then
                memdata(conv_integer(address)) <= indata;
            end if;
            outdata <= memdata(conv_integer(address));
        end if;
    end process;
    
end;