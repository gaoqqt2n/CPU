library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  id_stage  is
    port(
        clk, rst : in std_logic;
        wad : in std_logic_vector(4 downto 0);
        inst, wdata : in std_logic_vector(31 downto 0);
        mux1, dmwe, mux2, mux3, we : out std_logic;
        hactrl : out std_logic_vector(1 downto 0);
        aluctrl : out std_logic_vector(3 downto 0);
        rtad, rdad : out std_logic_vector(4 downto 0);
        ex26 : out std_logic_vector(27 downto 0)
        rs, rt, ex16_1, ex16_2 : out std_logic_vector(31 downto 0)
        );
end id_stage;

architecture  rtl  of  id_stage  is
signal rt_R, rd_R : std_logic_vector(4 downto 0);
signal stall_opcode, stall_funct : std_logic_vector(5 downto 0);
signal stall_ex16 : std_logic_vector(15 downto 0);
signal stall_ex26 : std_logic_vector(25 downto 0);
signal rs_rf, rt_rf : std_logic_vector(31 downto 0);
component pc  
    port(
        clk, rst : in std_logic;
        next_address : in std_logic_vector(31 downto 0);
        address : out std_logic_vector(31 downto 0)
        );
end component;

component im
    port(
        address : in std_logic_vector(4 downto 0);
        inst : out std_logic_vector(31 downto 0)
        );    
end component;

component adder
    port(
         address     : in   std_logic_vector(31 downto 0);
         pc4   : out std_logic_vector(31 downto 0)
         );
end component;

component adsel
    port(
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend26 : in std_logic_vector(27
         downto 0); 
        pc4, extend16 : in std_logic_vector(31 downto 0);
        next_address : out std_logic_vector(31 downto 0)
        );
end component;
begin

    M1 : pc port map (clk, rst, adsel_pc, pc_im);
    M2 : im port map (pc_im(6 downto 2), inst);
    M3 : adder port map (pc_im, adder_adsel);
    M4 : adsel port map (adsel_ctrl, hactrl, extend26, adder_adsel, extend16, adsel_pc);

end;
