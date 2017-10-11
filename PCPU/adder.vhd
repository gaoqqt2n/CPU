
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity  adder  is
    port(
         address     : in   std_logic_vector(31 downto 0);
         pc_adder   : out std_logic_vector(31 downto 0));
end adder;

architecture  rtl  of  adder  is
begin
    
    pc_adder <= address + x"00000004";
     
end;
