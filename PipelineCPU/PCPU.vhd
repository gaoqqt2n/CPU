library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  pcpu  is
    port(
        clk, rst : in std_logic;
        outdata : out std_logic_vector(31 downto 0)
        );
end pcpu;

architecture  rtl  of  pcpu  is
signal regwe : std_logic;
signal adsel_ctrl, hactrl : std_logic_vector(1 downto 0);
signal ctrlout_3_R, R_ctrlout_3 : std_logic_vector(2 downto 0);
signal regwad, rtad_R, R_rtad, rdad_R, R_rdad, shamt_R, R_shamt, wad_R, R_wad : std_logic_vector(4 downto 0);
signal ctrl_R, R_ctrl : std_logic_vector(8 downto 0);
signal ex26_R, R_ex26 : std_logic_vector(27 downto 0);
signal ex16_1, inst_R, R_inst, rs_R, R_rs, rt_R, R_rt, ex16_2_R, R_ex16_2, aluout_R, R_aluout, rtdata_R, R_rtdata, regwdata : std_logic_vector(31 downto 0);

component if_stage
    port(
        clk, rst : in std_logic;
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend16 : in std_logic_vector(31 downto 0);
        extend26  : in std_logic_vector(27 downto 0);
        inst : out std_logic_vector(31 downto 0)
        );
end component;

component id_stage
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
end component;

component ex_stage
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
end component;

component ma_stage
    port(
        clk, rst : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        ctrlout_3 : in std_logic_vector(2 downto 0);
        aluout, rtdata : in std_logic_vector(31 downto 0);
        regwe : out std_logic;
        regwad : out std_logic_vector(4 downto 0); -- regfile write address
        outdata : out std_logic_vector(31 downto 0) --regfile in data
        );
end component;

component register_3
    port(
        clk, rst : in std_logic;
        in3 : in std_logic_vector(2 downto 0);
        out3 : out std_logic_vector(2 downto 0)
    );
end component;

component register_5
    port(
        clk, rst : in std_logic;
        in5 : in std_logic_vector(4 downto 0);
        out5 : out std_logic_vector(4 downto 0)
    );
end component;

component register_9
    port(
        clk, rst : in std_logic;
        in9 : in std_logic_vector(8 downto 0);
        out9 : out std_logic_vector(8 downto 0)
    );
end component;

component register_28
    port(
        clk, rst : in std_logic;
        in28 : in std_logic_vector(27 downto 0);
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

begin

    M1 : if_stage port map (clk, rst, adsel_ctrl, hactrl, ex16_1, R_ex26, inst_R);
    M2 : register_32 port map (clk, rst, inst_R, R_inst);
    M3 : id_stage port map (clk, rst, regwe, regwad, R_inst, regwdata, hactrl, rtad_R, rdad_R, shamt_R, ctrl_R, ex26_R, rs_R, rt_R, ex16_1, ex16_2_R);
    M4 : register_28 port map (clk, rst, ex26_R, R_ex26);
    M5 : register_32 port map (clk, rst, rs_R, R_rs);
    M6 : register_32 port map (clk, rst, rt_R, R_rt);
    M7 : register_32 port map (clk, rst, ex16_2_R, R_ex16_2);
    M8 : register_5 port map (clk, rst, rtad_R, R_rtad);
    M9 : register_5 port map (clk, rst, rdad_R, R_rdad);
    M10 : register_5 port map (clk, rst, shamt_R, R_shamt);
    M11 : register_9 port map (clk, rst, ctrl_R, R_ctrl);
    M12 : ex_stage port map (rst, R_rtad, R_rdad, R_shamt, R_ctrl, R_rs, R_rt, R_ex16_2, adsel_ctrl, ctrlout_3_R, wad_R, aluout_R, rtdata_R);
    M13 : register_32 port map (clk, rst, aluout_R, R_aluout);
    M14 : register_32 port map (clk, rst, rtdata_R, R_rtdata);
    M15 : register_5 port map (clk, rst, wad_R, R_wad);
    M16 : register_3 port map (clk, rst, ctrlout_3_R, R_ctrlout_3);
    M17 : ma_stage port map (clk, rst, R_wad, R_ctrlout_3, R_aluout, R_rtdata, regwe, regwad, regwdata);

outdata <= regwdata;
end;