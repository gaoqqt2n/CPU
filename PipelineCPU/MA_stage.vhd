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
signal R3_mux : std_logic;
signal dm_R, R_mux, R1_mux : std_logic_vector(31 downto 0);

component datamem
    port(
        clk, rst, we : in std_logic;
        address : in std_logic_vector(5 downto 0);
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

component register_1
    port(
        clk, rst, in1 : in std_logic;
        out1 : out std_logic
    );
end component;

begin

    M1 : datamem port map (clk, rst, ctrlout_3(2), aluout(5 downto 0), rtdata, dm_R);
    M3 : mux2_32 port map (R3_mux, dm_R, R1_mux, outdata);
    M4 : register_5 port map (clk, rst, wad, regwad);
    M5 : register_32 port map (clk, rst, aluout, R1_mux);
    M6 : register_1 port map (clk, rst, ctrlout_3(1), R3_mux);
    M7 : register_1 port map (clk, rst, ctrlout_3(0), regwe);

end;
