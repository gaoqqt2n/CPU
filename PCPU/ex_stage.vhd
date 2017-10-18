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
        adsel_ctrl : out std_logic_vector(1 downto 0);
        ctrlout_3 : out std_logic_vector(2 downto 0);
        wad : out std_logic_vector(4 downto 0);
        aluout, exout_rtdata : out std_logic_vector(31 downto 0)
        );
end ex_stage;

architecture  rtl  of  ex_stage  is
signal mux_alu : std_logic_vector(31 downto 0);

component alu
   port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        shamt : in std_logic_vector(4 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        adsel_ctrl : out std_logic_vector(1 downto 0);
        aluout : out std_logic_vector(31 downto 0)
   );
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

    M1 : alu port map (rst, ctrlout(7 downto 4), shamt, rsdata, mux_alu, adsel_ctrl, aluout);
    M2 : mux2_32 port map (ctrlout(8), rtdata, ex16, mux_alu);
    M3 : mux2_5 port map (ctrlout(1), rtad, rdad, wad);

    exout_rtdata <= rtdata;
    ctrlout_3 <= ctrlout(2 downto 0);

end;
