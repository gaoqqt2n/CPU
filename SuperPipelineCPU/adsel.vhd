library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  adsel  is
    port(
        clk, rst : in std_logic;
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend26 : in std_logic_vector(27 downto 0); 
        pc4, extend16 : in std_logic_vector(31 downto 0);
        ifdebugout : out std_logic_vector(7 downto 0);
        next_address : out std_logic_vector(31 downto 0)
        );
    
end adsel;

architecture  rtl  of  adsel  is
-- signal befpc : std_logic_vector(31 downto 0) := x"00000000";
-- signal pcflag : std_logic := '0';
 
   begin
-- pcflag <= pc4(2);
-- pcflag <= '0' when (befpc = pc4) else '1' ;

   process (clk)
      variable pc, bpc, bbpc : std_logic_vector(31 downto 0) := x"00000000";
      variable flag : std_logic_vector(1 downto 0) := "00";
      variable abc : std_logic_vector(7 downto 0) := "00000000"; --debug
      begin
        if (rst = '0') then
            next_address <= x"00000000";

    elsif (clk'event and clk = '1') then
      abc := "00000000";
      if (hactrl = "01") then
        bpc := pc4 - 12;
        flag := "01";
        abc := "00000001";
      elsif (hactrl = "10") then
        bbpc := pc4 - 12;
        flag := "10";
        abc := "00000010";
      end if;

      case (adsel_ctrl) is 
         when "00" =>
            if(hactrl = "00") then
                if (flag = "01") then 
                    next_address <= bpc;
                    flag := "00";
                    abc := "00000100";
                elsif (flag = "10") then
                    next_address <= bbpc;
                    flag := "00";
                    abc := "00001000";
                else
                    next_address <= pc4;
                    abc := "00010000";
                end if;
            else 
                next_address <= pc4;
                abc := "00100000";
            end if;
         when "01" => next_address <= extend16 + pc4 - x"00000014";
                      flag := "00";
                      abc := "01000000";
         when "10" =>
            pc := pc4 - x"00000004"; 
            next_address <= pc(31 downto 28) & extend26;
                      flag := "00";
                      abc := "10000000";
         when others => next_address <= pc4; 
      end case;
        end if;
ifdebugout <= abc;
   end process;

end;
