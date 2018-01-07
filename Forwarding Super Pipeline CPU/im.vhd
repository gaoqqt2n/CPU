library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  im  is
    port(
         address : in std_logic_vector(5 downto 0);
         inst : out std_logic_vector(31 downto 0));
end im;

architecture  rtl  of  im  is
constant nop : std_logic_vector(31 downto 0) := x"04000000"; --nop 
constant M0 : std_logic_vector(31 downto 0) := x"8c010001"; --load 0 1 1
constant M1 : std_logic_vector(31 downto 0) := x"8c020000"; --load 0 2 0
constant M2 : std_logic_vector(31 downto 0) := x"8c05000a"; --load 0 5 10
constant M3 : std_logic_vector(31 downto 0) := x"00221020"; --add 1 2 2
constant M4 : std_logic_vector(31 downto 0) := x"00431820"; --add 2 3 3
constant M5 : std_logic_vector(31 downto 0) := x"10450002"; --beq 2 5 2
constant M6 : std_logic_vector(31 downto 0) := x"08000004"; --jump 4 0 0
constant M7 : std_logic_vector(31 downto 0) := x"ac03000c"; --store 0 3 12
constant M8 : std_logic_vector(31 downto 0) := x"8c07000c"; --load 0 7 12
constant M9 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M10 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M11 : std_logic_vector(31 downto 0) := x"04000000"; --nop
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
constant M31 : std_logic_vector(31 downto 0) := x"04000000"; --nop
--end architecture

type mem_array is array (0 to 63) of std_logic_vector(31 downto 0);
constant mem : mem_array := ( 
                             nop, M0, M1, M2, M3,  m4, m5,
                             m6, m7, m8, m9, m10, m11, m12, m13,
                             m14, m15, m16, m17, m18, m19, m20, m21, m22, m23, m24, m25,
                             m26, m27, m28, m29, m30,
                             nop, nop, nop, nop, nop, nop, nop, nop ,nop, nop,
                             nop, nop, nop, nop, nop, nop, nop, nop ,nop, nop,
                             nop, nop, nop, nop, nop, nop, nop, nop ,nop, nop,
                             nop, nop);
    
begin

inst <= mem(conv_integer(address));

end;
