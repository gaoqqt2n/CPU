library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity stall_if is
    port(
        clk, rst : in std_logic;
        inst : in std_logic_vector(31 downto 0);
        inhactrl : in std_logic_vector(1 downto 0) := "00"; --hold address control
        inflag : in std_logic_vector(2 downto 0) := "000"; 
        outflag : out std_logic_vector(2 downto 0); 
        outhactrl : out std_logic_vector(1 downto 0); --hold address control
        forwarding_ctrl : out std_logic_vector(3 downto 0);
        pout : out std_logic
    );
end stall_if;

architecture rtl of stall_if is
    signal brt, brd : std_logic_vector(4 downto 0) := "00000";
    signal bopcd : std_logic_vector(5 downto 0) := "111111";
    begin
        
        process (clk, rst, inst) 
        variable bbrt, bbrd : std_logic_vector(4 downto 0) := "00000";
        variable bbopcd : std_logic_vector(5 downto 0) := "111111";
        variable pouttmp : std_logic := "0";
        begin

        if (rst = '0') then
            brt <= "00000";
            brd <= "00000";
            bopcd <= "111111";
            bbrt := "00000";
            bbrd := "00000";
            bbopcd := "111111";
            bbbrt := "00000";
            bbbrd := "00000";
            bbbopcd := "111111";
            pouttmp := '0';
            outhactrl <= "00";
            forwarding_ctrl <= "0001";
            outflag <= "000";
        elsif (clk'event and clk = '1') then
            case(inhactrl) is
                when "00" =>
                
                if (inflag = "010"or inflag = "011") then --happened datahazard after 2clock 3clock
                    pouttmp := '0';
                    outflag <= inflag + 1;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                    forwarding_ctrl <= "0001";
                elsif (inflag = "100") then --happened datahazard after 4clock
                    pouttmp := '0';
                    outflag <= "000";
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                    forwarding_ctrl <= "0001";
                elsif (((bopcd = "100011") and (inst(31 downto 26) = "000100")) and ((brt /= "00000") and (brt = inst(25 downto 21)))) then --load - beq --nop
                    pouttmp := '1';
                    outhactrl <= "10";
                    outflag <= "001";
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                    forwarding_ctrl <= "0001";
                elsif (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) and (brd /= "00000")) then
                    if (brd = inst(25 downto 21)) then --r-b-rs
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbrd = inst(25 downto 21)) then --r-bb-rs
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbbrd = inst(25 downto 21)) then --r-bbb-rs
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    end if;
                elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) and (brt /= "00000")) then
                    if (brt = inst(25 downto 21)) then --lw-b-rs
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbrt = inst(25 downto 21)) then --lw-bb-rs
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbbrt = inst(25 downto 21)) then --lw-bbb-rs
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    end if;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and (brd /= "00000")) then
                    if (brd = inst(20 downto 16)) then --r-b-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbrd = inst(20 downto 16)) then --r-bb-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbbrd = inst(20 downto 16)) then --r-bbb-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    end if;
                elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and (brt /= "00000")) then
                    if (brt = inst(20 downto 16)) then --lw-b-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbrt = inst(20 downto 16)) then --lw-bb-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbbrt = inst(20 downto 16)) then --lw-bbb-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    end if;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bopcd = "000000") and (inst(31 downto 26) = "100011")) and (brd /= "00000")) then
                    if (brd = inst(20 downto 16)) then --r-blw-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbrd = inst(20 downto 16)) then --r-bblw-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbbrd = inst(20 downto 16)) then --r-bbblw-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    end if;
                elsif (((bopcd = "100011") and (inst(31 downto 26) = "100011") and (brt /= "00000")) then
                    if (brt = inst(20 downto 16)) then --lw-blw-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbrt = inst(20 downto 16)) then --lw-bblw-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    elsif (bbbrt = inst(20 downto 16)) then --lw-bbblw-rt
                        pouttmp := '1';
                        forwarding_ctrl <= "0110";
                    end if;
-----------------------------------------------------------------------------------------------------------------------------------------------------
--                 elsif (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and (brd /= "00000")) then
--                     if (brd = inst(25 downto 21)) then --r-b-rs
--                         if (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and 
--                             ((bbrd /= "00000") and (bbrd = inst(20 downto 15)))) then --r-bb-rt
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "0110";
--                         elsif (((bbopcd = "000000") and (inst(31 downto 26) = "101011")) and 
--                             ((bbrd /= "00000") and (bbrd = inst(20 downto 15)))) then --r-bbst-rt
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1100";
--                         else 
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "0100";
--                         end if;
--                     elsif (brd = inst(20 downto 16) and (inst(31 downto 26) = "101011")) then --r-bst-rt
--                         if (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                             ((bbrd /= "00000") and (bbrd = inst(25 downto 21)))) then --r-bb-rs
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1101";
--                         else
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1010";
--                         end if;
--                     elsif (brd = inst(20 downto 16)) then --r-b-rt
--                         if (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                             ((bbrd /= "00000") and (bbrd = inst(25 downto 21)))) then --r-bb-rs
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1000";
--                         else
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "0010";
--                         end if;
--                     elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                         ((bbrd /= "00000") and (bbrd = inst(25 downto 21)))) then --r-bb-rs
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "0111";
--                     elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and 
--                         ((bbrd /= "00000") and (bbrd = inst(20 downto 16)))) then --r-bb-rt
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "0011";
--                     elsif (((bbopcd = "000000") and (inst(31 downto 26) = "101011")) and 
--                         ((bbrd /= "00000") and (bbrd = inst(20 downto 16)))) then --r-bbrs-rt
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "1011";
--                     else
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "0001";
--                     end if;
--                 elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                     ((bbrd /= "00000") and (bbrd = inst(25 downto 21)))) then --r-bb-rs
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0111";
--                 elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and 
--                     ((bbrd /= "00000") and (bbrd = inst(20 downto 16)))) then --r-bb-rt
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0011";
--                 elsif (((bbopcd = "000000") and (inst(31 downto 26) = "101011")) and 
--                     ((bbrd /= "00000") and (bbrd = inst(20 downto 16)))) then --r-bbrs-rt
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "1011";
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                 elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and (brt /= "00000")) then
--                     if (brt = inst(25 downto 21)) then --lw-b-rs
--                         if (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                             ((bbrt /= "00000") and (bbrt = inst(20 downto 15)))) then --lw-bb-rt
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "0110";
--                         elsif (((bbopcd = "100011") and (inst(31 downto 26) = "101011")) and 
--                             ((bbrt /= "00000") and (bbrt = inst(20 downto 15)))) then --lw-bbst-rt
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1100";
--                         else 
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "0100";
--                         end if;
--                     elsif (brt = inst(20 downto 16) and (inst(31 downto 26) = "101011")) then --lw-bst-rt
--                         if (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                             ((bbrt /= "00000") and (bbrt = inst(25 downto 21)))) then --lw-bb-rs
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1101";
--                         else
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1010";
--                         end if;
--                     elsif (brt = inst(20 downto 16)) then --lw-b-rt
--                         if (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                             ((bbrd /= "00000") and (bbrd = inst(25 downto 21)))) then --lw-bb-rs
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "1000";
--                         else
--                             pouttmp := '1';
--                             bbrt := brt;
--                             bbrd := brd;
--                             bbopcd := bopcd;
--                             brt <= inst(20 downto 16);
--                             brd <= inst(15 downto 11);
--                             bopcd <= inst(31 downto 26);
--                             forwarding_ctrl <= "0010";
--                         end if;
--                     elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                         ((bbrt /= "00000") and (bbrt = inst(25 downto 21)))) then --lw-bb-rs
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "0111";
--                     elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and 
--                         ((bbrt /= "00000") and (bbrt = inst(20 downto 16)))) then --lw-bb-rt
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "0011";
--                     elsif (((bbopcd = "100011") and (inst(31 downto 26) = "101011")) and 
--                         ((bbrt /= "00000") and (bbrt = inst(20 downto 16)))) then --lw-bbst-rt
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "1011";
--                     else
--                         pouttmp := '1';
--                         bbrt := brt;
--                         bbrd := brd;
--                         bbopcd := bopcd;
--                         brt <= inst(20 downto 16);
--                         brd <= inst(15 downto 11);
--                         bopcd <= inst(31 downto 26);
--                         forwarding_ctrl <= "0001";
--                     end if;
--                 elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and 
--                     ((bbrt /= "00000") and (bbrt = inst(25 downto 21)))) then --lw-bb-rs
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0111";
--                 elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and 
--                     ((bbrt /= "00000") and (bbrt = inst(20 downto 16)))) then --lw-bb-rt
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0011";
--                 elsif (((bbopcd = "100011") and (inst(31 downto 26) = "101011")) and 
--                     ((bbrt /= "00000") and (bbrt = inst(20 downto 16)))) then --lw-bbst-rt
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "1011";
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                 elsif (((bopcd = "000000") and (inst(31 downto 26) = "100011")) and --r
--                         ((brd /= "00000") and (brd = inst(25 downto 21)))) then --r-blw-rs
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0100";
--                 elsif (((bbopcd = "000000") and (inst(31 downto 26) = "100011")) and --r
--                         ((bbrd /= "00000") and (bbrd = inst(25 downto 21)))) then --r-bblw-rs
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0111";
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                 elsif (((bopcd = "100011") and (inst(31 downto 26) = "100011")) and --lw
--                         ((brt /= "00000") and (brt = inst(25 downto 21)))) then --lw-blw-rs
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0100";
--                 elsif (((bbopcd = "100011") and (inst(31 downto 26) = "100011")) and --lw
--                         ((bbrt /= "00000") and (bbrt = inst(25 downto 21)))) then --r-bblw-rs
--                     pouttmp := '1';
--                     bbrt := brt;
--                     bbrd := brd;
--                     bbopcd := bopcd;
--                     brt <= inst(20 downto 16);
--                     brd <= inst(15 downto 11);
--                     bopcd <= inst(31 downto 26);
--                     forwarding_ctrl <= "0111";
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                
                elsif ((inst(31 downto 26) = "000010") or (inst(31 downto 26) = "000100")) then --jump, beq
                    pouttmp := '1';
                    outhactrl <= "01";
                    outflag <= "001";
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                    forwarding_ctrl <= "0001";
                else 
                    pouttmp := '1';
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                    forwarding_ctrl <= "0001";
                end if;

            when "01" => 
                if (inflag = "001") then
                    pouttmp := '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                    forwarding_ctrl <= "0001";
                else 
                    pouttmp := '1';
                    outhactrl <= "00";
                    outflag <= "000";
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                    forwarding_ctrl <= "0001";
                end if;
            when "10" => 
                if (inflag = "001") then
                    pouttmp := '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                    forwarding_ctrl <= "0001";
                else 
                    pouttmp := '1';
                    outhactrl <= "00";
                    outflag <= "000";
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                    forwarding_ctrl <= "0001";
                end if;
            when others => 
                pouttmp := '1';
                outhactrl <= "00";
                outflag <= "000";
                bbrt := brt;
                bbrd := brd;
                bbopcd := bopcd;
                brt <= inst(20 downto 16);
                brd <= inst(15 downto 11);
                bopcd <= inst(31 downto 26);
                forwarding_ctrl <= "0001";
            end case;
        end if;
    end process;
    

end;
