library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  ma_stage  is
    port(
        clk, rst : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        ctrlout_3 : in std_logic_vector(2 downto 0);
        aluout, rtdata : in std_logic_vector(31 downto 0);
        regwe : out std_logic;
        regwad : out std_logic_vector(4 downto 0); -- regfile write address
        outdata : out std_logic_vector(31 downto 0) --regfile in data
        );
end ma_stage;

architecture  rtl  of  ma_stage  is
signal dm_mux, R_mux : std_logic_vector(31 downto 0);

component datamem
    port(
        clk, rst, wren : in std_logic;
        address : in std_logic_vector(4 downto 0);
        indata : in std_logic_vector(31 downto 0);
        outdata : out std_logic_vector(31 downto 0)
    );
end component;

component mux2_32
    port (
          sel : in std_logic; 
          in0, in1 : in std_logic_vector(31 downto 0);
          out1 : out std_logic_vector(31 downto 0)
   );
end component;

component register_5
    port(
        clk, rst : in std_logic;
        in5 : in std_logic_vector(4 downto 0);
        out5 : out std_logic_vector(4 downto 0)
    );
end component;

component register_32
    port(
        clk, rst : in std_logic;
        in32 : in std_logic_vector(31 downto 0);
        out32 : out std_logic_vector(31 downto 0)
    );
end component;

begin

    M1 : datamem port map (clk, rst, ctrlout_3(2), aluout(6 downto 2), rtdata, dm_mux);
    M2 : mux2_32 port map (ctrlout_3(1), dm_mux, R_mux, outdata);
    M3 : register_5 port map (clk, rst, wad, regwad);
    M4 : register_32 port map (clk, rst, aluout, R_mux);

    regwe <= ctrlout_3(0);

end;
