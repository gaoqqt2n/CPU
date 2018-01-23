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
constant M0 : std_logic_vector(31 downto 0) := x"8c060035"; --load 0 6 53
constant M1 : std_logic_vector(31 downto 0) := x"8c010001"; --load 0 1 1
constant M2 : std_logic_vector(31 downto 0) := x"00011020"; --add 0 1 2
constant M3 : std_logic_vector(31 downto 0) := x"8c430000"; --load 2 3 0
constant M4 : std_logic_vector(31 downto 0) := x"00411020"; --add 2 1 2
constant M5 : std_logic_vector(31 downto 0) := x"8c440000"; --load 2 4 0
constant M6 : std_logic_vector(31 downto 0) := x"00411020"; --add 2 1 2
constant M7 : std_logic_vector(31 downto 0) := x"00832020"; --add 4 3 4
constant M8 : std_logic_vector(31 downto 0) := x"00884020"; --add 4 8 8
constant M9 : std_logic_vector(31 downto 0) := x"10460002"; --beq 2 6 2
constant M10 : std_logic_vector(31 downto 0) := x"08000004"; --jump 4 0 0
constant M11 : std_logic_vector(31 downto 0) := x"ac08003c"; --store 0 8 60
constant M12 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M13 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M14 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M15 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M16 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M17 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M18 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M19 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M20 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M21 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M22 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M23 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M24 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M25 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M26 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M27 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M28 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M29 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M30 : std_logic_vector(31 downto 0) := x"04000000"; --nop
--end architecture

type mem_array is array (0 to 31) of std_logic_vector(31 downto 0);
constant mem : mem_array := ( 
                             nop, m0, m1, m2, m3,  m4, m5,
                             m6, m7, m8, m9, m10, m11, m12, m13,
                             m14, m15, m16, m17, m18, m19, m20, m21, m22, m23, m24, m25,
                             m26, m27, m28, m29, m30);
    
begin

inst <= mem(conv_integer(address));

end;
