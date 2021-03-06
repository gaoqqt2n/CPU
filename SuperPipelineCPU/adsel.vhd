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
        ifdebugout : out std_logic_vector(7 downto 0);--debug
        next_address : out std_logic_vector(31 downto 0)
        );
    
end adsel;

architecture  rtl  of  adsel  is
 
   begin

   process (clk)
      variable pc, bpc, bbpc : std_logic_vector(31 downto 0) := x"00000000";
      variable flag : std_logic_vector(1 downto 0) := "00";
      variable next_pc4 : std_logic_vector(31 downto 0) := x"00000000";
      variable jump_address : std_logic_vector(31 downto 0) := x"00000000";
      begin
    if (rst = '0') then
        next_pc4 := x"00000000";
        jump_address := x"00000000";
        next_address <= x"00000000";
    else
        next_pc4 := pc4;
    end if;

        abc := "00000000";
        if (hactrl = "01") then
            bpc := pc4 - 16;
            flag := "01";
        elsif (hactrl = "10") then
            bbpc := pc4 - 20;
            flag := "10";
        end if;

        case (adsel_ctrl) is 
            when "00" =>
                if(hactrl = "00") then
                    if (flag = "01") then 
                        jump_address := bpc;
                        flag := "00";
                    elsif (flag = "10") then
                        jump_address := bbpc;
                        flag := "00";
                    else
                        jump_address := pc4;
                    end if;
                elsif (hactrl = "01") then
                    jump_address := bpc;
                    flag := "00";
                elsif (hactrl = "10") then
                    jump_address := bbpc;
                    flag := "00";
                else 
                    jump_address := pc4;
                end if;
            when "01" => 
                jump_address := extend16 + pc4 - x"00000014";
                flag := "00";
            when "10" =>
                pc := pc4 - x"00000004"; 
                jump_address := pc(31 downto 28) & extend26;
                flag := "00";
            when others => jump_address := pc4; 
        end case;
    
    if (adsel_ctrl = "01" or adsel_ctrl = "10" or (hactrl = "01" and adsel_ctrl = "00") or (hactrl = "10" and adsel_ctrl = "00") or (adsel_ctrl = "00" and hactrl = "00" and (flag = "01" or flag = "10"))) then 
        next_address <= jump_address;
    else 
        next_address <= next_pc4;
    end if;
ifdebugout <= adsel_ctrl & hactrl & flag & "00";
    end process;

end;
