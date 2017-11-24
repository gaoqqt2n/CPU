library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  adsel  is
    port(
        adsel_ctrl, hactrl : in std_logic_vector(1 downto 0);
        extend26 : in std_logic_vector(27 downto 0); 
        pc4, extend16 : in std_logic_vector(31 downto 0);
        next_address : out std_logic_vector(31 downto 0)
        );
    
end adsel;

architecture  rtl  of  adsel  is

   begin

   process (pc4)
      variable pc, bpc, bbpc : std_logic_vector(31 downto 0) := x"00000000";
      variable flag : std_logic_vector(1 downto 0) := "00";
      begin
      if (hactrl = "01") then
        bpc := pc4 - 4;
        flag := "01";
      elsif (hactrl = "10") then
        bbpc := pc4 - 16;
        flag := "10";
      end if;

      case (adsel_ctrl) is 
         when "00" =>
            if(hactrl = "00") then
                if (flag = "01") then 
                    next_address <= bpc;
                    flag := "00";
                elsif (flag = "10") then
                    next_address <= bbpc;
                    flag := "00";
                else
                    next_address <= pc4;
                end if;
            else 
                next_address <= pc4;
            end if;
         when "01" => next_address <= extend16 + pc4 - x"00000008";
         when "10" =>
            pc := pc4 - x"00000004"; 
            next_address <= pc(31 downto 28) & extend26;
         when others => next_address <= pc4; 
      end case;

   end process;

end;
