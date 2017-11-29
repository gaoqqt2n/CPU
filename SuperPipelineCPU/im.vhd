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
constant M8 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M9 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M10 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M11 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M12 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M13 : std_logic_vector(31 downto 0) := x"10280002"; --beq 1 8 2
constant M14 : std_logic_vector(31 downto 0) := x"10230002"; --beq 1 3 2
constant M15 : std_logic_vector(31 downto 0) := x"0800000d"; --jump 13 0 0
constant M16 : std_logic_vector(31 downto 0) := x"00643020"; --add 3 4 6
constant M17 : std_logic_vector(31 downto 0) := x"8cc70001"; --load 6 7 1
constant M18 : std_logic_vector(31 downto 0) := x"00a74020"; --add 5 7 8
constant M19 : std_logic_vector(31 downto 0) := x"00681020"; --add 3 8 2
constant M20 : std_logic_vector(31 downto 0) := x"ac410004"; --store 2 1 4
constant M21 : std_logic_vector(31 downto 0) := x"8c270004"; --load 1 7 4
constant M22 : std_logic_vector(31 downto 0) := x"8ce80001"; --load 7 8 1
constant M23 : std_logic_vector(31 downto 0) := x"ad01000a"; --store 8 1 10
constant M24 : std_logic_vector(31 downto 0) := x"00221820"; --add 1 2 3
constant M25 : std_logic_vector(31 downto 0) := x"ac23000d"; --store 1 3 13
constant M26 : std_logic_vector(31 downto 0) := x"8c85000a"; --load 4 5 10
constant M27 : std_logic_vector(31 downto 0) := x"acc5000a"; --store 6 5 10
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
