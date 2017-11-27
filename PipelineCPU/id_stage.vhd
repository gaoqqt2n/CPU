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
        -- stout : out std_logic_vector(31 downto 0) --debug
        );
end id_stage;

architecture  rtl  of  id_stage  is
-- signal rs_rf, rt_rf, rd_R, stall_shamt : std_logic_vector(4 downto 0);
-- signal stall_opcode, stall_funct : std_logic_vector(5 downto 0);
-- signal stall_ex16 : std_logic_vector(15 downto 0);
-- signal stall_ex26 : std_logic_vector(25 downto 0);
signal hazard : std_logic_vector(1 downto 0);
signal stallflag : std_logic_vector(1 downto 0);
signal stallout : std_logic_vector(31 downto 0);

component stall 
    port(
        inst : in std_logic_vector(31 downto 0);
        inhactrl : in std_logic_vector(1 downto 0); --hold address control
        inflag : in std_logic_vector(1 downto 0); --
        outflag : out std_logic_vector(1 downto 0); --
        outhactrl : out std_logic_vector(1 downto 0); --hold address control
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
        out32 : out std_logic_vector(27 downto 0)
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

    M1 : stall port map (inst, hazard, stallflag, stallflag, hazard, stallout);
    M2 : regfile port map (clk, rst, regwe, wad, stallout(25 downto 21), stallout(20 downto 16), wdata, rs, rt);
    M3 : register_5 port map (clk, rst, stallout(20 downto 16), rtad);
    M4 : register_5 port map (clk, rst, stallout(15 downto 11), rdad);
    M5 : extend16 port map (clk, rst, stallout(15 downto 0), ex16_1, ex16_2);
    M6 : extend26 port map (clk, rst, stallout(25 downto 0), ex26);
    M7 : register_5 port map (clk, rst, stallout(10 downto 6), shamt);
    M8 : ctrl port map (clk, rst, stallout(31 downto 26), stallout(5 downto 0), ctrlout);

    -- stout <= stall_opcode & rs_rf & rt_rf & rd_R & stall_shamt & stall_funct;
    -- stout <= stallout;
    hactrl <= hazard;

end;
