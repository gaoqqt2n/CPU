library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  im  is
    port(
         address : in std_logic_vector(4 downto 0);
         inst : out std_logic_vector(31 downto 0));
    
end im;

architecture  rtl  of  im  is
constant nop : std_logic_vector(31 downto 0) := x"04000000"; --nop 
constant M0 : std_logic_vector(31 downto 0) := x"8c010001"; --load 0 1 1
constant M1 : std_logic_vector(31 downto 0) := x"8c020002"; --load 0 2 2
constant M2 : std_logic_vector(31 downto 0) := x"8c030003"; --load 0 3 3
constant M3 : std_logic_vector(31 downto 0) := x"ac010004"; --store 0 1 4
constant M4 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M5 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M6 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M7 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M8 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M9 : std_logic_vector(31 downto 0) := x"8c050004"; --load 0 5 4
constant M10 : std_logic_vector(31 downto 0) := x"10220002"; --beq 1 2 2
constant M11 : std_logic_vector(31 downto 0) := x"10000001"; --beq 0 0 1
constant M12 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M13 : std_logic_vector(31 downto 0) := x"08000002"; --jump 2 0 0
constant M14 : std_logic_vector(31 downto 0) := x"8c080003"; --load 0 8 3
--end architecture

type mem_array is array (0 to 31) of std_logic_vector(31 downto 0);
constant mem : mem_array := ( 
                             nop, nop, M0,  M1,  M2, m14, NOP, NOP, NOP, NOP, NOP, NOP, NOP,  M3,  m4, m5,
                             m6, m7, m8, nop, nop, m9, m10, m11, m12, m13,
                             nop, nop, nop, nop, nop,
                             NOP);
    
begin

inst <= mem(conv_integer(address));

end;
