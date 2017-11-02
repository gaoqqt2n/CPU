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
constant M0 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M1 : std_logic_vector(31 downto 0) := x"8c010001"; --load 0 1 1
constant M2 : std_logic_vector(31 downto 0) := x"8c020002"; --load 0 2 2
constant M3 : std_logic_vector(31 downto 0) := x"8c030003"; --load 0 3 3
constant M4 : std_logic_vector(31 downto 0) := x"ac010004"; --store 0 1 4
constant M5 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M6 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M7 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M8 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M9 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M10 : std_logic_vector(31 downto 0) := x"8c050004"; --load 0 5 4
constant M11 : std_logic_vector(31 downto 0) := x"00220002"; --beq 1 2 2
constant M12 : std_logic_vector(31 downto 0) := x"00000001"; --beq 0 0 1
constant M13 : std_logic_vector(31 downto 0) := x"04000000"; --nop
constant M14 : std_logic_vector(31 downto 0) := x"02000002"; --jump 2 0 0
constant M15 : std_logic_vector(31 downto 0) := x"8c080003"; --load 0 8 3
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
constant nop : std_logic_vector(31 downto 0) := x"04000000";
constant M0 : std_logic_vector(31 downto 0) := x"8c010000";
constant M1 : std_logic_vector(31 downto 0) := x"8c020001";
constant M2 : std_logic_vector(31 downto 0) := x"8c030002";
constant M3 : std_logic_vector(31 downto 0) := x"00222020";
constant M4 : std_logic_vector(31 downto 0) := x"00412822";
constant M5 : std_logic_vector(31 downto 0) := x"00011041";
constant M6 : std_logic_vector(31 downto 0) := x"00032082";
constant M7 : std_logic_vector(31 downto 0) := x"00082043";
constant M8 : std_logic_vector(31 downto 0) := x"00232024";
constant M9 : std_logic_vector(31 downto 0) := x"00222825";
constant M10 : std_logic_vector(31 downto 0) := x"00223026";
constant M11 : std_logic_vector(31 downto 0) := x"00223827";
constant M12 : std_logic_vector(31 downto 0) := x"0041402a";
constant M13 : std_logic_vector(31 downto 0) := x"0022482a";
constant M14 : std_logic_vector(31 downto 0) := x"ac010004";
constant M15 : std_logic_vector(31 downto 0) := x"10220002";
constant M16 : std_logic_vector(31 downto 0) := x"10000001";
constant M17 : std_logic_vector(31 downto 0) := x"04000000";
constant M18 : std_logic_vector(31 downto 0) := x"08000002";
constant M19 : std_logic_vector(31 downto 0) := x"8c080003";

type mem_array is array (0 to 31) of std_logic_vector(31 downto 0);
constant mem : mem_array := ( 
                             nop, nop, M0,  M1,  M2, m19, NOP, NOP, NOP, NOP, NOP, NOP, NOP,  M3,  m4, m5,
                             m6, m7, m8, nop, nop, m9, m10, m11, m12, m13,
                             m14, m15, m16, m17, m18,
                             NOP);
    
begin

inst <= mem(conv_integer(address));

end;
