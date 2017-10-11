------------------------------------------
------------------------------------------
-- Date        : Tue Aug 01 13:39:48 2017
--
-- Author      : 
--
-- Company     : 
--
-- Description : 
--
------------------------------------------
------------------------------------------
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
    constant NOP : std_logic_vector(31 downto 0) := X"04000000";
    constant M0  : std_logic_vector(31 downto 0) := X"8C0A0000";
    constant M1  : std_logic_vector(31 downto 0) := X"8C0B0004";
    constant M2  : std_logic_vector(31 downto 0) := X"114B0008";
    constant M3  : std_logic_vector(31 downto 0) := X"014BA02A";
    constant M4  : std_logic_vector(31 downto 0) := X"12800003";
    constant M5  : std_logic_vector(31 downto 0) := X"016A5822";
    constant M6  : std_logic_vector(31 downto 0) := X"08000002";
    constant M7  : std_logic_vector(31 downto 0) := X"04000000";
    constant M8  : std_logic_vector(31 downto 0) := X"014B5022";
    constant M9  : std_logic_vector(31 downto 0) := X"08000002";
    constant M10 : std_logic_vector(31 downto 0) := X"04000000";
    constant M11 : std_logic_vector(31 downto 0) := X"AC0A0008";
    constant M12 : std_logic_vector(31 downto 0) := X"0800000C";

type mem_array is array (0 to 31) of std_logic_vector(31 downto 0);
constant mem : mem_array := ( 
                             M0,  M1,  M2,  M3,  M4,  M5,  M6,  M7,
                             M8,  M9, M10, M11, M12, NOP, NOP, NOP,
                             NOP, NOP, NOP, NOP, NOP, NOP, NOP, NOP,
                             NOP, NOP, NOP, NOP, NOP, NOP, NOP, NOP);
    
begin

inst <= mem(conv_integer(address));

end;
