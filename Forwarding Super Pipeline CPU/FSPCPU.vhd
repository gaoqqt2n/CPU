library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  fspcpu  is
    port(
        clk, rst : in std_logic;
        outdata : out std_logic_vector(31 downto 0)
        );
end fspcpu;

architecture  rtl  of  fspcpu  is
signal regwe, stall_if_R, R_stall_out : std_logic;
signal adsel_ctrl, hactrl, R1_hactrl, R2_hactrl, hactrl_adsel : std_logic_vector(1 downto 0);
signal stallflag : std_logic_vector(2 downto 0);
signal stall_if_forward, stall_out_forward, ID_forward, ex1_forward, in_forwarder2 : std_logic_vector(4 downto 0);
signal regwad, rtad_R, R_rtad, rdad_R, R_rdad, shamt_R, R_shamt, wad_R, R_wad, ex1_shamt_R, R_ex2_shamt : std_logic_vector(4 downto 0);
signal R_alu_calc_shamt, R_alu_calc_wad_ma : std_logic_vector(4 downto 0);
signal ctrlout_7_R, R_ctrlout_7, R_alu_calc_ctrlout : std_logic_vector(6 downto 0);
signal ctrl_R, R_ctrl : std_logic_vector(8 downto 0);
signal ex26_R, R_ex26, ex26 : std_logic_vector(27 downto 0);
signal instout, R2_inst : std_logic_vector(31 downto 0);
signal ex16_1_R, R_ex16_1, ex16_1, inst_R, R_inst, rs_R, R_rs, rt_R, R_rt, ex16_2_R, R_ex16_2, aluout_ma, rsdata_R, R_rsdata, rtdata_R, R_rtdata, regwdata : std_logic_vector(31 downto 0);
signal mux32out_R, R_mux32out, R_alu_calc_mux32, R_alu_calc_rsdata, exRma_rtdata, alu_jump_in1, alu_jump_in2, alu_calc_in1, alu_calc_in2 : std_logic_vector(31 downto 0);

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
        clk, rst : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        inhactrl : in std_logic_vector(1 downto 0) := "00"; --hold address control
        inflag : in std_logic_vector(2 downto 0) := "000"; 
        outflag : out std_logic_vector(2 downto 0); 
        outhactrl : out std_logic_vector(1 downto 0); --hold address control
        forwarding_ctrl : out std_logic_vector(4 downto 0);
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

component forwarder1 is
    port(
        ctrl : in std_logic_vector(4 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end component;

component forwarder2 is
    port(
        clk, rst : in std_logic;
        ctrl : in std_logic_vector(4 downto 0);
        in1, in2, rtdata : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2, outdatamem : out std_logic_vector(31 downto 0)
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

component register_2 is
    port(
        clk, rst : in std_logic;
        in2 : in std_logic_vector(1 downto 0);
        out2 : out std_logic_vector(1 downto 0)
    );
end component;

component register_4 
    port(
        clk, rst : in std_logic;
        in4 : in std_logic_vector(3 downto 0);
        out4 : out std_logic_vector(3 downto 0)
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

    M1 : if_stage port map (clk, rst, adsel_ctrl, hactrl_adsel, ex16_1, ex26, inst_R);
    M2 : register_32 port map (clk, rst, inst_R, R_inst);

    M3 : stall_if port map (clk, rst, inst_R, hactrl, stallflag, stallflag, hactrl, stall_if_forward, stall_if_R);
    M39 : register_2 port map (clk, rst, hactrl, R1_hactrl);
    M40 : register_2 port map (clk, rst, R1_hactrl, R2_hactrl);
    M41 : register_2 port map (clk, rst, R2_hactrl, hactrl_adsel);
    M4 : register_32 port map (clk, rst, R_inst, R2_inst);
    M5 : register_1 port map (clk, rst, stall_if_R, R_stall_out);
    M44 : register_5 port map (clk, rst, stall_if_forward, stall_out_forward);

    M6 : stall_out port map (R2_inst, R_stall_out, instout);
    M45 : register_5 port map (clk, rst, stall_out_forward, ID_forward);

    M7 : id_stage port map (clk, rst, regwe, regwad, instout, regwdata, rtad_R, rdad_R, shamt_R, ctrl_R, R_ex26, rs_R, rt_R, R_ex16_1, ex16_2_R);

    M9 : register_32 port map (clk, rst, R_ex16_1, ex16_1);

    M11 : register_28 port map (clk, rst, R_ex26, ex26);
    M12 : register_32 port map (clk, rst, rs_R, R_rs);
    M13 : register_32 port map (clk, rst, rt_R, R_rt);
    M14 : register_32 port map (clk, rst, ex16_2_R, R_ex16_2);
    M15 : register_5 port map (clk, rst, rtad_R, R_rtad);
    M16 : register_5 port map (clk, rst, rdad_R, R_rdad);
    M17 : register_5 port map (clk, rst, shamt_R, R_shamt);
    M18 : register_9 port map (clk, rst, ctrl_R, R_ctrl);
    M46 : register_5 port map (clk, rst, ID_forward, ex1_forward);

    M19 : ex_stage port map (rst, R_rtad, R_rdad, R_shamt, R_ctrl, R_rs, R_rt, R_ex16_2, R_wad, R_ex2_shamt, R_ctrlout_7, R_rsdata, R_mux32out, R_rtdata);

    -- M42 : forwarder port map (clk, rst, ex1_forward, R_rsdata, R_mux32out, aluout_ma, regwdata, alu_jump_in1, alu_jump_in2);
    M42 : forwarder1 port map (ex1_forward, R_rsdata, R_mux32out, aluout_ma, regwdata, alu_jump_in1, alu_jump_in2);

    M26 : alu_jump port map (rst, R_ctrlout_7(6 downto 3), alu_jump_in1, alu_jump_in2, adsel_ctrl);
    -- M47 : register_4 port map (clk, rst, ex1_forward, in_forwarder2);
    M27 : register_7 port map (clk, rst, R_ctrlout_7, R_alu_calc_ctrlout);
    M28 : register_5 port map (clk, rst, R_ex2_shamt, R_alu_calc_shamt);
    M29 : register_5 port map (clk, rst, R_wad, R_alu_calc_wad_ma);
    -- M30 : register_32 port map (clk, rst, R_rsdata, R_alu_calc_rsdata);
    -- M31 : register_32 port map (clk, rst, R_mux32out, R_alu_calc_mux32);
    -- M32 : register_32 port map (clk, rst, R_rtdata, exRma_rtdata);

    -- M43 : forwarder port map (clk, rst, in_forwarder2, R_alu_calc_rsdata, R_alu_calc_mux32, aluout_ma, regwdata, alu_calc_in1, alu_calc_in2);
    M43 : forwarder2 port map (clk, rst, ex1_forward, R_rsdata, R_mux32out, R_rtdata, aluout_ma, regwdata, alu_calc_in1, alu_calc_in2, exRma_rtdata);
    -- M43 : forwarder port map (in_forwarder2, R_alu_calc_rsdata, R_alu_calc_mux32, aluout_ma, regwdata, alu_calc_in1, alu_calc_in2);

    M33 : alu_calc port map (rst, R_alu_calc_ctrlout(6 downto 3), R_alu_calc_shamt, alu_calc_in1, alu_calc_in2, aluout_ma);

    M38 : ma_stage port map (clk, rst, R_alu_calc_wad_ma, R_alu_calc_ctrlout(2 downto 0), aluout_ma, exRma_rtdata, regwe, regwad, regwdata);

outdata <= regwdata;
end;
