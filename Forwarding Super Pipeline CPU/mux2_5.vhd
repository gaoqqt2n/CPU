library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  mux2_5  is
    port (
          sel : in std_logic; 
          in0, in1 : in std_logic_vector(4 downto 0);
          out1 : out std_logic_vector(4 downto 0));
end mux2_5;

architecture  rtl  of  mux2_5  is
    begin
        out1 <= in0 when (sel = '0') else in1;
    end;