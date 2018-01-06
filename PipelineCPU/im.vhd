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
constant M3 : std_logic_vector(31 downto 0) := x"8c040004"; --load 0 4 4
constant M4 : std_logic_vector(31 downto 0) := x"8c050005"; --load 0 5 5
constant M5 : std_logic_vector(31 downto 0) := x"8c060006"; --load 0 6 6
constant M6 : std_logic_vector(31 downto 0) := x"8c070007"; --load 0 7 7
constant M7 : std_logic_vector(31 downto 0) := x"8c080008"; --load 0 8 8
constant M8 : std_logic_vector(31 downto 0) := x"8c090009"; --load 0 9 9
constant M9 : std_logic_vector(31 downto 0) := x"8c0a000a"; --load 0 10 10
constant M10 : std_logic_vector(31 downto 0) := x"00226020"; --add 1 2 12
constant M11 : std_logic_vector(31 downto 0) := x"00646820"; --add 3 4 13
constant M12 : std_logic_vector(31 downto 0) := x"00a67020"; --add 5 6 14
constant M13 : std_logic_vector(31 downto 0) := x"00e87820"; --add 7 8 15
constant M14 : std_logic_vector(31 downto 0) := x"012a8020"; --add 9 10 16
constant M15 : std_logic_vector(31 downto 0) := x"018d9020"; --add 12 13 18
constant M16 : std_logic_vector(31 downto 0) := x"01ee9820"; --add 15 14 19
constant M17 : std_logic_vector(31 downto 0) := x"0212a820"; --add 16 18 21
constant M18 : std_logic_vector(31 downto 0) := x"0275b820"; --add 19 21 23
constant M19 : std_logic_vector(31 downto 0) := x"ac17000c"; --store 0 23 12
constant M20 : std_logic_vector(31 downto 0) := x"8c19000c"; --load 0 25 12
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
                             nop, M0, M1, M2, M3,  m4, m5,
                             m6, m7, m8, m9, m10, m11, m12, m13,
                             m14, m15, m16, m17, m18, m19, m20, m21, m22, m23, m24, m25,
                             m26, m27, m28, m29, m30);
    
begin

inst <= mem(conv_integer(address));

end;
