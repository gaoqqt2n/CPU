library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  id_stage  is
    port(
        clk, rst : in std_logic;
        regwe : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        inst, wdata : in std_logic_vector(31 downto 0);
        hactrl : out std_logic_vector(1 downto 0);
        rtad, rdad, shamt : out std_logic_vector(4 downto 0);
        ctrlout : out std_logic_vector(8 downto 0);
        ex26 : out std_logic_vector(27 downto 0);
        rs, rt, ex16_1, ex16_2 : out std_logic_vector(31 downto 0)
        );
end id_stage;

architecture  rtl  of  id_stage  is
signal stallout : std_logic_vector(31 downto 0);
signal R_stall_out : std_logic_vector(31 downto 0);
signal stall_stall : std_logic;

component stall_if
    port(
        inst : in std_logic_vector(31 downto 0);
        hactrl : out std_logic_vector(1 downto 0); --hold address control
        pout : out std_logic
    );
end component;

component stall_out
    port(
        inst : in std_logic_vector(31 downto 0);
        pin : in std_logic;
        instout : out std_logic_vector(31 downto 0)
    );
end component;

component regfile
    port(
        clk, rst, we : in std_logic;
        wad, rad1, rad2 : in std_logic_vector(4 downto 0);
        indata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end component;

component register_5
    port(
        clk, rst : in std_logic;
        in5 : in std_logic_vector(4 downto 0);
        out5 : out std_logic_vector(4 downto 0)
    );
end component;

component extend16 
    port(
        clk, rst: in std_logic;
        in16 : in std_logic_vector(15 downto 0);
        out1 : out std_logic_vector(31 downto 0); --adsel
        out2 : out std_logic_vector(31 downto 0) --alu
    );
end component;

component extend26
    port(
        clk, rst: in std_logic;
        in26 : in std_logic_vector(25 downto 0);
        out28 : out std_logic_vector(27 downto 0)
    );
end component;

component register_32
    port(
        clk, rst : in std_logic;
        in32 : in std_logic_vector(31 downto 0);
        out32 : out std_logic_vector(31 downto 0)
    );
end component;

component ctrl
    port(
        clk, rst : in std_logic;
        opcode, funct : in std_logic_vector(5 downto 0);
        ctrl : out std_logic_vector(8 downto 0) --mux:1,alu:4,dm:1,mux:1,mux:1,regfile:1
    );
end component;

begin

    M1 : stall_if port map (inst, hactrl, stall_stall);
    M2 : register_32 port map (clk, rst, inst, R_stall_out);
    M3 : stall_out port map (R_stall_out, stall_stall, stallout);
    M4 : regfile port map (clk, rst, regwe, wad, stallout(25 downto 21), stallout(20 downto 16), wdata, rs, rt);
    M5 : register_5 port map (clk, rst, stallout(20 downto 16), rtad);
    M6 : register_5 port map (clk, rst, stallout(15 downto 11), rdad);
    M7 : extend16 port map (clk, rst, stallout(15 downto 0), ex16_1, ex16_2);
    M8 : extend26 port map (clk, rst, stallout(25 downto 0), ex26);
    M9 : register_5 port map (clk, rst, stallout(10 downto 6), shamt);
    M10 : ctrl port map (clk, rst, stallout(31 downto 26), stallout(5 downto 0), ctrlout);

end;
