library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity stall is
    port(
        inst : in std_logic_vector(31 downto 0);
        hactrl : out std_logic_vector(1 downto 0); --hold address control
        instout : out std_logic_vector(31 downto 0)
    );
end stall;

architecture rtl of stall is
    begin
        
        process (inst) 
        variable ctrltmp : std_logic_vector(1 downto 0) := "00";
        variable flag : std_logic_vector(1 downto 0) := "00";
        variable brt, brd : std_logic_vector(4 downto 0) := "00000";
        variable bopcd : std_logic_vector(5 downto 0) := "111111";
        begin

        if (ctrltmp = "00") then
            
            if ((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011"))) then --R
                if ((brd /= "00000") and ((brd = inst(25 downto 21)) or (brd = inst(20 downto 16)))) then --happned datahazard
                    instout <= x"04000000"; --nop
                    ctrltmp := "10";
                    flag := "01";
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                else
                    instout <= inst;
                    brt := inst(20 downto 16);
                    brd := inst(15 downto 11);
                    bopcd := inst(31 downto 26);
                end if;
            elsif ((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011"))) then --lw
                if ((brt /= "00000") and ((brt = inst(25 downto 21)) or (brt = inst(20 downto 16)))) then 
                    instout <= x"04000000"; --nop
                    ctrltmp := "10";
                    flag := "01";
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                else 
                    instout <= inst;
                    brt := inst(20 downto 16);
                    brd := inst(15 downto 11);
                    bopcd := inst(31 downto 26);
                end if;
            elsif ((bopcd = "101011") and (inst(31 downto 26) = "100011")) then --st
                if ((brt /= "00000") and ((brt = inst(25 downto 21)) or (brt = inst(20 downto 16)))) then 
                    instout <= x"04000000"; --nop
                    ctrltmp := "10";
                    flag := "01";
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                else 
                    instout <= inst;
                    brt := inst(20 downto 16);
                    brd := inst(15 downto 11);
                    bopcd := inst(31 downto 26);
                end if;
            elsif (flag = "10") then
                instout <= x"04000000"; --nop
                flag := "00";
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            elsif (flag = "11") then --jump, beq after 4clock
                instout <= x"04000000"; --nop
                flag := "00";         
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            elsif ((inst(31 downto 26) = "000010") or (inst(31 downto 26) = "000100")) then --jump, beq
                instout <= inst;
                ctrltmp := "01";
                flag := "01";
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            else 
                instout <= inst;
                brt := inst(20 downto 16);
                brd := inst(15 downto 11);
                bopcd := inst(31 downto 26);
            end if;

        elsif (ctrltmp = "01") then 
            if (flag = "01") then
                instout <= x"04000000"; --nop
                flag := flag + 1;
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";

            elsif (flag = "10") then
                instout <= x"04000000"; --nop
                flag := flag + 1;
                ctrltmp := "00";
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            else 
                instout <= x"04000000"; --nop
                ctrltmp := "00";
                flag := "00";
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            end if;
        elsif (ctrltmp = "10") then
            if (flag = "01") then
                instout <= x"04000000"; --nop
                ctrltmp := "00";
                flag := flag + 1;
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            else 
                instout <= x"04000000"; --nop
                ctrltmp := "00";
                flag := "00";
                brt := (others => '0');
                brd := (others => '0');
                bopcd := "000001";
            end if;
        else --ctrltmp = "11"
            instout <= inst;
            ctrltmp := "00";
            flag := "00";
            brt := inst(20 downto 16);
            brd := inst(15 downto 11);
            bopcd := inst(31 downto 26);
        end if;
        hactrl <= ctrltmp;
    end process;
    
end;