library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  spcpu  is
    port(
        clk, rst : in std_logic;
        outdata : out std_logic_vector(31 downto 0)
        );
end spcpu;

architecture  rtl  of  spcpu  is
signal regwe, stall_if_R, R_stall_out : std_logic;
signal adsel_ctrl, hactrl : std_logic_vector(1 downto 0);
signal exRma_ctrlout : std_logic_vector(2 downto 0);
signal regwad, rtad_R, R_rtad, rdad_R, R_rdad, shamt_R, R_shamt, wad_R, R_wad, ex1_shamt_R, R_ex2_shamt : std_logic_vector(4 downto 0);
signal R_alu_calc_shamt, R_alu_calc_wad, exRma_wad : std_logic_vector(4 downto 0);
signal ctrlout_7_R, R_ctrlout_7, R_alu_calc_ctrlout : std_logic_vector(6 downto 0);
signal ctrl_R, R_ctrl : std_logic_vector(8 downto 0);
signal ex26_R, R_ex26 : std_logic_vector(27 downto 0);
signal instout, inst_R2, R2_inst : std_logic_vector(31 downto 0);
signal ex16_1, inst_R, R_inst, rs_R, R_rs, rt_R, R_rt, ex16_2_R, R_ex16_2, aluout_R, R_aluout, rsdata_R, R_rsdata, rtdata_R, R_rtdata, regwdata : std_logic_vector(31 downto 0);
signal R_rtdata_R,  mux32out_R, R_mux32out, R_alu_calc_mux32, R_alu_calc_rsdata, exRma_rtdata : std_logic_vector(31 downto 0);

component if_stage
    port(
        clk, rst : in std_logic;
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend16 : in std_logic_vector(31 downto 0);
        extend26  : in std_logic_vector(27 downto 0);
        inst : out std_logic_vector(31 downto 0)
        );
end component;

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

component id_stage
    port(
        clk, rst : in std_logic;
        regwe : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        stallout, wdata : in std_logic_vector(31 downto 0);
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
        wad, shamtout : out std_logic_vector(4 downto 0);
        ctrlout_7 : out std_logic_vector(6 downto 0);
        exout_rsdata, mux32out, exout_rtdata : out std_logic_vector(31 downto 0)
        );
end component;

component alu_jump
    port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        adsel_ctrl : out std_logic_vector(1 downto 0)
    );
end component;

component alu_calc
    port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        shamt : in std_logic_vector(4 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        aluout : out std_logic_vector(31 downto 0)
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

component register_1
    port(
        clk, rst, in1 : in std_logic;
        out1 : out std_logic
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

component register_7
    port(
        clk, rst : in std_logic;
        in7 : in std_logic_vector(6 downto 0);
        out7 : out std_logic_vector(6 downto 0)
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
    M3 : stall_if port map (R_inst, hactrl, stall_if_R);
    M4 : register_32 port map (clk, rst, R_inst, R2_inst);
    M5 : register_1 port map (clk, rst, stall_if_R, R_stall_out);
    M6 : stall_out port map (R2_inst, R_stall_out, instout);
    M7 : id_stage port map (clk, rst, regwe, regwad, instout, regwdata, rtad_R, rdad_R, shamt_R, ctrl_R, ex26_R, rs_R, rt_R, ex16_1, ex16_2_R);
    M8 : register_28 port map (clk, rst, ex26_R, R_ex26);
    M9 : register_32 port map (clk, rst, rs_R, R_rs);
    M10 : register_32 port map (clk, rst, rt_R, R_rt);
    M11 : register_32 port map (clk, rst, ex16_2_R, R_ex16_2);
    M12 : register_5 port map (clk, rst, rtad_R, R_rtad);
    M13 : register_5 port map (clk, rst, rdad_R, R_rdad);
    M14 : register_5 port map (clk, rst, shamt_R, R_shamt);
    M15 : register_9 port map (clk, rst, ctrl_R, R_ctrl);
    M16 : ex_stage port map (rst, R_rtad, R_rdad, R_shamt, R_ctrl, R_rs, R_rt, R_ex16_2, wad_R, ex1_shamt_R, ctrlout_7_R, rsdata_R, mux32out_R, rtdata_R);
    M17 : register_32 port map (clk, rst, rsdata_R, R_rsdata);
    M18 : register_32 port map (clk, rst, mux32out_R, R_mux32out);
    M19 : register_32 port map (clk, rst, rtdata_R, R_rtdata);
    M20 : register_5 port map (clk, rst, wad_R, R_wad);
    M21 : register_5 port map (clk, rst, ex1_shamt_R, R_ex2_shamt);
    M22 : register_7 port map (clk, rst, ctrlout_7_R, R_ctrlout_7);
    M23 : alu_jump port map (rst, R_ctrlout_7(6 downto 3), R_rsdata, R_mux32out, adsel_ctrl);
    M24 : register_7 port map (clk, rst, R_ctrlout_7, R_alu_calc_ctrlout);
    M25 : register_5 port map (clk, rst, R_ex2_shamt, R_alu_calc_shamt);
    M26 : register_5 port map (clk, rst, R_wad, R_alu_calc_wad);
    M27 : register_32 port map (clk, rst, R_rsdata, R_alu_calc_rsdata);
    M28 : register_32 port map (clk, rst, R_mux32out, R_alu_calc_mux32);
    M29 : register_32 port map (clk, rst, R_rtdata, R_rtdata_R);
    M30 : alu_calc port map (rst, R_alu_calc_ctrlout(6 downto 3), R_alu_calc_shamt, R_alu_calc_rsdata, R_alu_calc_mux32, aluout_R);
    M31 : register_32 port map (clk, rst, aluout_R, R_aluout);
    M32 : register_32 port map (clk, rst, R_rtdata_R, exRma_rtdata);
    M33 : register_5 port map (clk, rst, R_alu_calc_wad, exRma_wad);
    M34 : register_3 port map (clk, rst, R_alu_calc_ctrlout(2 downto 0), exRma_ctrlout);
    M35 : ma_stage port map (clk, rst, exRma_wad, exRma_ctrlout, R_aluout, exRma_rtdata, regwe, regwad, regwdata);

outdata <= regwdata;
end;
