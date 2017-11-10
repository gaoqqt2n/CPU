library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  ex_stage  is
    port(
        rst : in std_logic;
        rtad, rdad, shamt : in std_logic_vector(4 downto 0);
        ctrlout : in std_logic_vector(8 downto 0);
        rsdata, rtdata, ex16 : in std_logic_vector(31 downto 0);
        wad, shamtout : out std_logic_vector(4 downto 0);
        ctrlout_7 : out std_logic_vector(6 downto 0);
        exout_rsdata, mux32out, exout_rtdata : out std_logic_vector(31 downto 0)
        );
end ex_stage;

architecture  rtl  of  ex_stage  is

component alu

end component;

component mux2_32
    port (
          sel : in std_logic; 
          in0, in1 : in std_logic_vector(31 downto 0);
          out1 : out std_logic_vector(31 downto 0)
   );
end component;

component mux2_5
   port (
          sel : in std_logic; 
          in0, in1 : in std_logic_vector(4 downto 0);
          out1 : out std_logic_vector(4 downto 0)
   );
end component;

begin

    M1 : mux2_32 port map (ctrlout(8), rtdata, ex16, mux32out);
    M2 : mux2_5 port map (ctrlout(7), rtad, rdad, wad);

    exout_rsdata <= rsdata;
    shamtout <= shamt;
    exout_rtdata <= rtdata;
    ctrlout_7 <= ctrlout(6 downto 0);

end;
