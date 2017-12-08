library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  if_stage  is
    port(
        clk, rst : in std_logic;
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend16 : in std_logic_vector(31 downto 0);
        extend26  : in std_logic_vector(27 downto 0);
        inst : out std_logic_vector(31 downto 0)
        );
end if_stage;

architecture  rtl  of  if_stage  is
signal pc_im, adder_adsel, adsel_pc : std_logic_vector(31 downto 0);
signal passout : std_logic_vector(7 downto 0);--debug
-- signal adselflag : std_logic_vector(1 downto 0);--debug
-- signal bbpcout : std_logic_vector(31 downto 0);--debug
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
        clk, rst : in std_logic;
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend26 : in std_logic_vector(27 downto 0); 
        pc4, extend16 : in std_logic_vector(31 downto 0);
        ifdebugout : out std_logic_vector(7 downto 0);
        next_address : out std_logic_vector(31 downto 0)
        );
end component;
begin

    M1 : pc port map (clk, rst, adsel_pc, pc_im);
    M2 : im port map (pc_im(6 downto 2), inst);
    M3 : adder port map (pc_im, adder_adsel);
    -- M4 : adsel port map (adsel_ctrl, hactrl, adselflag, extend26, adder_adsel, extend16, adselflag, bbpcout, flagout, adsel_pc); --debug
    M4 : adsel port map (clk, rst, adsel_ctrl, hactrl, extend26, adder_adsel, extend16, passout, adsel_pc);


end;
