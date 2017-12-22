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
        variable fdctrl2 : std_logic_vector(2 downto 0) := "000";
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
            fdctrl2 := "000";
            outflag <= "000";
        elsif (clk'event and clk = '1') then
            case(inhactrl) is
                when "00" =>
                
                if (inflag = "010"or inflag = "011") then --happened datahazard after 2clock 3clock
                    pouttmp := '0';
                    outflag <= inflag + 1;
                    fdctrl1 := "00";
                    fdctrl2 := "000";
                elsif (inflag = "100") then --happened datahazard after 4clock
                    pouttmp := '0';
                    outflag <= "000";
                    fdctrl1 := "00";
                    fdctrl2 := "000";
                elsif (((bopcd = "100011") and (inst(31 downto 26) = "000100")) and ((brt /= "00000") and (brt = inst(25 downto 21)))) then --load - beq --nop
                    pouttmp := '1';
                    outhactrl <= "10";
                    outflag <= "001";
                    fdctrl1 := "00";
                    fdctrl2 := "000";
                elsif ((inst(31 downto 26) = "000010") or (inst(31 downto 26) = "000100")) then --jump, beq
                    pouttmp := '1';
                    outhactrl <= "01";
                    outflag <= "001";
                    fdctrl1 := "00";
                    fdctrl2 := "000";
                else
                    if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) and (brd /= "00000")) then
                        if (brd = inst(25 downto 21)) then --r-b-rs
                            pouttmp := '1';
                            fdctrl1 := "01";
                        elsif (bbrd = inst(25 downto 21)) then --r-bb-rs
                            pouttmp := '1';
                            fdctrl1 := "10";
                        elsif (bbbrd = inst(25 downto 21)) then --r-bbb-rs
                            pouttmp := '1';
                            fdctrl1 := "11";
                        else 
                            pouttmp := '1';
                            fdctrl1 := "00";
                        end if;
                    elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100") or (inst(31 downto 26) = "100011"))) and (brt /= "00000")) then
                        if (brt = inst(25 downto 21)) then --lw-b-rs
                            pouttmp := '1';
                            fdctrl1 := "01";
                        elsif (bbrt = inst(25 downto 21)) then --lw-bb-rs
                            pouttmp := '1';
                            fdctrl1 := "10";
                        elsif (bbbrt = inst(25 downto 21)) then --lw-bbb-rs
                            pouttmp := '1';
                            fdctrl1 := "11";
                        else 
                            pouttmp := '1';
                            fdctrl1 := "00";
                        end if;
                    else 
                        pouttmp := '1';
                        fdctrl1 := "00";
                    end if;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    if (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and (brd /= "00000")) then
                        if (brd = inst(20 downto 16)) then --r-b-rt
                            pouttmp := '1';
                            fdctrl2 := "001";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbrd = inst(20 downto 16)) then --r-bb-rt
                            pouttmp := '1';
                            fdctrl2 := "010";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbbrd = inst(20 downto 16)) then --r-bbb-rt
                            pouttmp := '1';
                            fdctrl2 := "011";
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
                            fdctrl2 := "000";
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
                    elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "000100"))) and (brt /= "00000")) then
                        if (brt = inst(20 downto 16)) then --lw-b-rt
                            pouttmp := '1';
                            fdctrl2 := "001";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbrt = inst(20 downto 16)) then --lw-bb-rt
                            pouttmp := '1';
                            fdctrl2 := "010";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbbrt = inst(20 downto 16)) then --lw-bbb-rt
                            pouttmp := '1';
                            fdctrl2 := "011";
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
                            fdctrl2 := "000";
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    elsif (((bopcd = "000000") and (inst(31 downto 26) = "101011")) and (brd /= "00000")) then
                        if (brd = inst(20 downto 16)) then --r-bst-rt
                            pouttmp := '1';
                            fdctrl2 := "101";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbrd = inst(20 downto 16)) then --r-bbst-rt
                            pouttmp := '1';
                            fdctrl2 := "110";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbbrd = inst(20 downto 16)) then --r-bbbst-rt
                            pouttmp := '1';
                            fdctrl2 := "111";
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
                            fdctrl2 := "000";
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
                    elsif (((bopcd = "100011") and (inst(31 downto 26) = "101011")) and (brt /= "00000")) then
                        if (brt = inst(20 downto 16)) then --lw-bst-rt
                            pouttmp := '1';
                            fdctrl2 := "101";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbrt = inst(20 downto 16)) then --lw-bbst-rt
                            pouttmp := '1';
                            fdctrl2 := "110";
                                    bbbrt := bbrt;
        bbbrd := bbrd;
        bbbopcd := bbopcd;
        bbrt := brt;
        bbrd := brd;
        bbopcd := bopcd;
        brt <= inst(20 downto 16);
        brd <= inst(15 downto 11);
        bopcd <= inst(31 downto 26);
                        elsif (bbbrt = inst(20 downto 16)) then --lw-bbbst-rt
                            pouttmp := '1';
                            fdctrl2 := "111";
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
                            fdctrl2 := "000";  
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
                    else 
                        pouttmp := '1';
                        fdctrl2 := "000";
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
                end if;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                
            when "01" => 
                if (inflag = "001") then
                    pouttmp := '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    fdctrl1 := "00";
                    fdctrl2 := "000";
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
                    fdctrl2 := "000";
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
                    fdctrl2 := "000";
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
                    fdctrl2 := "000";
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
                fdctrl2 := "000";
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
        forwarding_ctrl <= fdctrl1 & fdctrl2;
    
    end process;
    

end;
