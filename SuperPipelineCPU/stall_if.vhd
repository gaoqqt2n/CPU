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
        begin

        if (rst = '0') then
            brt <= "00000";
            brd <= "00000";
            bopcd <= "111111";
            bbrt := "00000";
            bbrd := "00000";
            bbopcd := "111111";
            bbrt := "00000";
            bbrd := "00000";
            bbopcd := "111111";
            pout <= '0';
            outhactrl <= "00";
            outflag <= "000";
        elsif (clk'event and clk = '1') then
            case(inhactrl) is
                when "00" =>
                
                if (inflag = "010") then --happened datahazard after 5clock
                    pout <= '0';
                    outflag <= inflag + 1;
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (inflag = "011") then --happened datahazard after 5clock
                    pout <= '0';
                    outflag <= inflag + 1;
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (inflag = "100") then --jump, beq after 6clock
                    pout <= '0';
                    outflag <= "000";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and --R
                    ((brd /= "00000") and ((brd = inst(25 downto 21)) or (brd = inst(20 downto 16))))) then --happned datahazard
                        pout <= '0';
                        outhactrl <= "10";
                        outflag <= "001";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= (others => '0');
                        brd <= (others => '0');
                        bopcd <= "000001";
                    -- else
                    --     pout <= '1';
                    --     brt <= inst(20 downto 16);
                    --     brd <= inst(15 downto 11);
                    --     bopcd <= inst(31 downto 26);
                    --     bbrt := brt;
                    --     bbrd := brd;
                    --     bbopcd := bopcd;
                    -- end if;
                elsif (((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and --lw
                    ((brt /= "00000") and ((brt = inst(25 downto 21)) or (brt = inst(20 downto 16))))) then 
                        pout <= '0';
                        outhactrl <= "10";
                        outflag <= "001";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= (others => '0');
                        brd <= (others => '0');
                        bopcd <= "000001";
                    -- else 
                    --     pout <= '1';
                    --     brt <= inst(20 downto 16);
                    --     brd <= inst(15 downto 11);
                    --     bopcd <= inst(31 downto 26);
                    --     bbrt := brt;
                    --     bbrd := brd;
                    --     bbopcd := bopcd;
                    -- end if;
                elsif ((((bopcd = "101011") and (inst(31 downto 26) = "100011")) and --st
                        ((brt /= "00000") and ((brt = inst(25 downto 21)) or (brt = inst(20 downto 16)))))) then 
                        pout <= '0';
                        outhactrl <= "10";
                        outflag <= "001";
                        bbbrt := bbrt;
                        bbbrd := bbrd;
                        bbbopcd := bbopcd;
                        bbrt := brt;
                        bbrd := brd;
                        bbopcd := bopcd;
                        brt <= (others => '0');
                        brd <= (others => '0');
                        bopcd <= "000001";
                    -- else 
                    --     pout <= '1';
                    --     brt <= inst(20 downto 16);
                    --     brd <= inst(15 downto 11);
                    --     bopcd <= inst(31 downto 26);
                    --     bbrt := brt;
                    --     bbrd := brd;
                    --     bbopcd := bopcd;
                    -- end if;
                elsif (((bbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and --R
                        ((bbrd /= "00000") and ((bbrd = inst(25 downto 21)) or (bbrd = inst(20 downto 16))))) then --happned datahazard
                    pout <= '0';
                    outhactrl <= "10";
                    outflag <= "001";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;    
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (((bbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and --lw
                        ((bbrt /= "00000") and ((bbrt = inst(25 downto 21)) or (bbrt = inst(20 downto 16))))) then 
                    pout <= '0';
                    outhactrl <= "10";
                    outflag <= "001";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";    
                elsif (((bbbopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and --R
                        ((bbbrd /= "00000") and ((bbbrd = inst(25 downto 21)) or (bbbrd = inst(20 downto 16))))) then --happned datahazard 3 before
                    pout <= '0';
                    outhactrl <= "10";
                    outflag <= "001";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;    
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                elsif (((bbbopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011") or (inst(31 downto 26) = "000100"))) and --lw
                        ((bbbrt /= "00000") and ((bbbrt = inst(25 downto 21)) or (bbbrt = inst(20 downto 16))))) then --3 before
                    pout <= '0';
                    outhactrl <= "10";
                    outflag <= "001";
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";    
                -- elsif (inflag = "011") then --jump, beq after 6clock
                --     pout <= '0';
                --     outflag <= "000";
                --     bbrt := brt;
                --     bbrd := brd;
                --     bbopcd := bopcd;
                --     brt <= (others => '0');
                --     brd <= (others => '0');
                --     bopcd <= "000001";
                elsif ((inst(31 downto 26) = "000010") or (inst(31 downto 26) = "000100")) then --jump, beq
                    pout <= '1';
                    outhactrl <= "01";
                    outflag <= "001";
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
                    pout <= '1';
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

            when "01" => 
                -- if (inflag = "001" or inflag = "010") then 
                --     pout <= '0';
                --     outflag <= inflag + 1;
                --     bbrt := brt;
                --     bbrd := brd;
                --     bbopcd := bopcd;
                --     brt <= (others => '0');
                --     brd <= (others => '0');
                --     bopcd <= "000001";
                -- elsif (inflag = "011") then
                if (inflag = "001") then
                    pout <= '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
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
                    pout <= '1';
                    outhactrl <= "00";
                    outflag <= "000";
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
            when "10" => 
                if (inflag = "001") then
                    pout <= '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    bbbrt := bbrt;
                    bbbrd := bbrd;
                    bbbopcd := bbopcd;
                    bbrt := brt;
                    bbrd := brd;
                    bbopcd := bopcd;
                    brt <= (others => '0');
                    brd <= (others => '0');
                    bopcd <= "000001";
                -- elsif ((inflag = "010")) then
                --     pout <= '0';
                --     outhactrl <= "00";
                --     outflag <= inflag + 1;
                --     bbrt := brt;
                --     bbrd := brd;
                --     bbopcd := bopcd;
                --     brt <= (others => '0');
                --     brd <= (others => '0');
                --     bopcd <= "000001";
                else 
                    pout <= '1';
                    outhactrl <= "00";
                    outflag <= "000";
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
            when others => 
                pout <= '1';
                outhactrl <= "00";
                outflag <= "000";
                bbbrt := bbrt;
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
    end process;
    

end;
