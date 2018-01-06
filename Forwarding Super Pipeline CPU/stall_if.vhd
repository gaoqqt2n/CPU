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
        forwarding_ctrl : out std_logic_vector(4 downto 0);
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
        variable bbbrt, bbbrd : std_logic_vector(4 downto 0) := "00000";
        variable bbbopcd : std_logic_vector(5 downto 0) := "111111";
        variable pouttmp : std_logic := '0';
        variable fdctrl1 : std_logic_vector(1 downto 0) := "00";
        variable is_stflag : std_logic := '0';
        variable fdctrl2 : std_logic_vector(1 downto 0) := "00";
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
            fdctrl1 := "00";
            fdctrl2 := "00";
            outflag <= "000";
        elsif (clk'event and clk = '1') then
            case(inhactrl) is
                when "00" =>
                
                if (inflag = "010"or inflag = "011") then --happened datahazard after 2clock 3clock
                    pouttmp := '0';
                    outflag <= inflag + 1;
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (inflag = "100") then --happened datahazard after 4clock
                    pouttmp := '0';
                    outflag <= "000";
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (((bopcd = "100011") and (inst(31 downto 26) = "000100")) and ((brt /= "00000") and (brt = inst(25 downto 21)))) then --load - beq --nop
                    pouttmp := '0';
                    outhactrl <= "10";
                    outflag <= "001";
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (inst(31 downto 26) = "000010") then --jump
                    pouttmp := '1';
                    outhactrl <= "01";
                    outflag <= "001";
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011")))
                    and (brd /= "00000")and (brd = inst(25 downto 21))) then --r-b-rs
                        fdctrl1 := "01";
                        if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        else
                            pouttmp := '1';
                            fdctrl2 := "00";
                            bbbrt := bbrt;
                            bbbrd := bbrd;
                            bbbopcd := bbopcd;
                            bbrt := brt;
                            bbrd := brd;
                            bbopcd := bopcd;
                            brt <= inst(20 downto 16);
                            brd <= inst(15 downto 11);
                            bopcd <= inst(31 downto 26);
                        end if;
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011")))
                    and (brt /= "00000")and (brt = inst(25 downto 21))) then --lw-b-rs
                        fdctrl1 := "01";
                        if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        else
                            pouttmp := '1';
                            fdctrl2 := "00";
                            bbbrt := bbrt;
                            bbbrd := bbrd;
                            bbbopcd := bbopcd;
                            bbrt := brt;
                            bbrd := brd;
                            bbopcd := bopcd;
                            brt <= inst(20 downto 16);
                            brd <= inst(15 downto 11);
                            bopcd <= inst(31 downto 26);
                        end if;
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011")))
                    and (bbrd /= "00000")and (bbrd = inst(25 downto 21))) then --r-bb-rs
                        fdctrl1 := "10";
                        if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        else
                            pouttmp := '1';
                            fdctrl2 := "00";
                            bbbrt := bbrt;
                            bbbrd := bbrd;
                            bbbopcd := bbopcd;
                            bbrt := brt;
                            bbrd := brd;
                            bbopcd := bopcd;
                            brt <= inst(20 downto 16);
                            brd <= inst(15 downto 11);
                            bopcd <= inst(31 downto 26);
                        end if;
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011")))
                    and (bbrt /= "00000")and (bbrt = inst(25 downto 21))) then --lw-bb-rs
                        fdctrl1 := "10";
                        if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        else
                            pouttmp := '1';
                            fdctrl2 := "00";
                            bbbrt := bbrt;
                            bbbrd := bbrd;
                            bbbopcd := bbopcd;
                            bbrt := brt;
                            bbrd := brd;
                            bbopcd := bopcd;
                            brt <= inst(20 downto 16);
                            brd <= inst(15 downto 11);
                            bopcd <= inst(31 downto 26);
                        end if;
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011")))
                    and (bbbrd /= "00000")and (bbbrd = inst(25 downto 21))) then --r-bbb-rs
                        fdctrl1 := "11";
                        if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        else
                            pouttmp := '1';
                            fdctrl2 := "00";
                            bbbrt := bbrt;
                            bbbrd := bbrd;
                            bbbopcd := bbopcd;
                            bbrt := brt;
                            bbrd := brd;
                            bbopcd := bopcd;
                            brt <= inst(20 downto 16);
                            brd <= inst(15 downto 11);
                            bopcd <= inst(31 downto 26);
                        end if;
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;              
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011")))
                    and (bbbrt /= "00000")and (bbbrt = inst(25 downto 21))) then --lw-bbb-rs
                        fdctrl1 := "11";
                        if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                                pouttmp := '1';
                                fdctrl2 := "01";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                                pouttmp := '1';
                                fdctrl2 := "10";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                            and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                                pouttmp := '1';
                                fdctrl2 := "11";
                                bbbrt := bbrt;
                                bbbrd := bbrd;
                                bbbopcd := bbopcd;
                                bbrt := brt;
                                bbrd := brd;
                                bbopcd := bopcd;
                                brt <= inst(20 downto 16);
                                brd <= inst(15 downto 11);
                                bopcd <= inst(31 downto 26);
                        else
                            pouttmp := '1';
                            fdctrl2 := "00";
                            bbbrt := bbrt;
                            bbbrd := bbrd;
                            bbbopcd := bbopcd;
                            bbrt := brt;
                            bbrd := brd;
                            bbopcd := bopcd;
                            brt <= inst(20 downto 16);
                            brd <= inst(15 downto 11);
                            bopcd <= inst(31 downto 26);
                        end if;
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;              
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                elsif (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                    and (brd /= "00000") and (brd = inst(20 downto 16))) then --r-b-rt
                        pouttmp := '1';
                        fdctrl1 := "00";
                        fdctrl2 := "01";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= inst(20 downto 16);
                        brd <= inst(15 downto 11);
                        bopcd <= inst(31 downto 26);
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
                elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                    and (brt /= "00000") and (brt = inst(20 downto 16))) then --lw-b-rt
                        pouttmp := '1';
                        fdctrl1 := "00";
                        fdctrl2 := "01";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= inst(20 downto 16);
                        brd <= inst(15 downto 11);
                        bopcd <= inst(31 downto 26);
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
                elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                    and (bbrd /= "00000") and (bbrd = inst(20 downto 16))) then --r-bb-rt
                        pouttmp := '1';
                        fdctrl1 := "00";
                        fdctrl2 := "10";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= inst(20 downto 16);
                        brd <= inst(15 downto 11);
                        bopcd <= inst(31 downto 26);
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
                elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                    and (bbrt /= "00000") and (bbrt = inst(20 downto 16))) then --lw-bb-rt
                        pouttmp := '1';
                        fdctrl1 := "00";
                        fdctrl2 := "10";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= inst(20 downto 16);
                        brd <= inst(15 downto 11);
                        bopcd <= inst(31 downto 26);
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
                elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                    and (bbbrd /= "00000") and (bbbrd = inst(20 downto 16))) then --r-bbb-rt
                        pouttmp := '1';
                        fdctrl1 := "00";
                        fdctrl2 := "11";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= inst(20 downto 16);
                        brd <= inst(15 downto 11);
                        bopcd <= inst(31 downto 26);
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;           
                elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) 
                    and (bbbrt /= "00000") and (bbbrt = inst(20 downto 16))) then --lw-bbb-rt
                        pouttmp := '1';
                        fdctrl1 := "00";
                        fdctrl2 := "11";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= inst(20 downto 16);
                        brd <= inst(15 downto 11);
                        bopcd <= inst(31 downto 26);
                        if (inst(31 downto 26) = "000100") then 
                            outhactrl <= "01";
                            outflag <= "001";
                        end if;   
                elsif (inst(31 downto 26) = "000100") then --beq
                    pouttmp := '1';
                    outhactrl <= "01";
                    outflag <= "001";
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);        
                else
                    pouttmp := '1';
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                end if;
                
                if (inst(31 downto 26) = "101011") then 
                    is_stflag := '1';
                else 
                    is_stflag := '0';
                end if;              
                

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                
            when "01" => 
                if (inflag = "001") then
                    pouttmp := '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                else 
                    pouttmp := '1';
                    outhactrl <= "00";
                    outflag <= "000";
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                end if;
            when "10" => 
                if (inflag = "001") then
                    pouttmp := '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                else 
                    pouttmp := '1';
                    outhactrl <= "00";
                    outflag <= "000";
                    fdctrl1 := "00";
                    fdctrl2 := "00";
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= inst(20 downto 16);
                    brd <= inst(15 downto 11);
                    bopcd <= inst(31 downto 26);
                end if;
            when others => 
                pouttmp := '1';
                outhactrl <= "00";
                outflag <= "000";
                fdctrl1 := "00";
                fdctrl2 := "00";
                bbbrd := bbrd;
                bbbopcd := bbopcd;
                bbrt := brt;
                bbrd := brd;
                bbopcd := bopcd;
                brt <= inst(20 downto 16);
                brd <= inst(15 downto 11);
                bopcd <= inst(31 downto 26);
            end case;
        end if;

        -- if (pouttmp = '1') then 
        -- bbbrt := bbrt;
        -- bbbrd := bbrd;
        -- bbbopcd := bbopcd;
        -- bbrt := brt;
        -- bbrd := brd;
        -- bbopcd := bopcd;
        --     brt <= (others => '0');
        --     brd <= (others => '0');
        --     bopcd <= "000001";
        -- brt <= inst(20 downto 16);
        -- brd <= inst(15 downto 11);
        -- bopcd <= inst(31 downto 26);
        -- else 
        -- end if;
        pout <= pouttmp;
        forwarding_ctrl <= fdctrl1 & is_stflag & fdctrl2;
    
    end process;
    

end;
