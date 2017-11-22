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
    begin
        
        process (clk, rst, inst) 
        variable brt, brd : std_logic_vector(4 downto 0) := "00000";
        variable bopcd : std_logic_vector(5 downto 0) := "111111";
        begin

        if (rst = '0') then
            brt := "00000";
            brd := "00000";
            bopcd := "111111";
            pout <= '0';
            outhactrl <= "00";
            outflag <= "000";
        elsif (clk'event and clk = '1') then
            case(inhactrl) is
                when "00" =>
                
                if ((bopcd = "000000") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011"))) then --R
                    if ((brd /= "00000") and ((brd = inst(25 downto 21)) or (brd = inst(20 downto 16)))) then --happned datahazard
                        pout <= '0';
                        outhactrl <= "10";
                        outflag <= "001";
                        brt := (others => '0');
                        brd := (others => '0');
                        bopcd := "000001";
                    else
                        pout <= '1';
                        brt := inst(20 downto 16);
                        brd := inst(15 downto 11);
                        bopcd := inst(31 downto 26);
                    end if;
                elsif ((bopcd = "100011") and ((inst(31 downto 26) = "000000") or (inst(31 downto 26) = "100011") or (inst(31 downto 26) = "101011"))) then --lw
                    if ((brt /= "00000") and ((brt = inst(25 downto 21)) or (brt = inst(20 downto 16)))) then 
                        pout <= '0';
                        outhactrl <= "10";
                        outflag <= "001";
                        brt := (others => '0');
                        brd := (others => '0');
                        bopcd := "000001";
                    else 
                        pout <= '1';
                        brt := inst(20 downto 16);
                        brd := inst(15 downto 11);
                        bopcd := inst(31 downto 26);
                    end if;
                elsif ((bopcd = "101011") and (inst(31 downto 26) = "100011")) then --st
                    if ((brt /= "00000") and ((brt = inst(25 downto 21)) or (brt = inst(20 downto 16)))) then 
                        pout <= '0';
                        outhactrl <= "10";
                        outflag <= "001";
                        brt := (others => '0');
                        brd := (others => '0');
                        bopcd := "000001";
                    else 
                        pout <= '1';
                        brt := inst(20 downto 16);
                        brd := inst(15 downto 11);
                        bopcd := inst(31 downto 26);
                    end if;
                elsif (inflag = "100") then --happened datahazard after 5clock
                    pout <= '0';
                    outflag <= "000";
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                elsif (inflag = "101") then --jump, beq after 6clock
                    pout <= '0';
                    outflag <= "000";
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                elsif ((inst(31 downto 26) = "000010") or (inst(31 downto 26) = "000100")) then --jump, beq
                    pout <= '0';
                    outhactrl <= "01";
                    outflag <= "001";
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                else 
                    pout <= '1';
                    brt := inst(20 downto 16);
                    brd := inst(15 downto 11);
                    bopcd := inst(31 downto 26);
                end if;

            when "01" => 
                if ((inflag = "001") or (inflag = "010") or (inflag = "011")) then 
                    pout <= '0';
                    outflag <= inflag + 1;
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                elsif (inflag = "100") then
                    pout <= '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                else 
                    pout <= '1';
                    outhactrl <= "00";
                    outflag <= "000";
                    brt := inst(20 downto 16);
                    brd := inst(15 downto 11);
                    bopcd := inst(31 downto 26);
                end if;
            when "10" => 
                if ((inflag = "001") or (inflag = "010")) then
                    pout <= '0';
                    outflag <= inflag + 1;
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                elsif ((inflag = "011")) then
                    pout <= '0';
                    outhactrl <= "00";
                    outflag <= inflag + 1;
                    brt := (others => '0');
                    brd := (others => '0');
                    bopcd := "000001";
                else 
                    pout <= '1';
                    outhactrl <= "00";
                    outflag <= "000";
                    brt := inst(20 downto 16);
                    brd := inst(15 downto 11);
                    bopcd := inst(31 downto 26);
                end if;
            when others => 
                pout <= '1';
                outhactrl <= "00";
                outflag <= "000";
                brt := inst(20 downto 16);
                brd := inst(15 downto 11);
                bopcd := inst(31 downto 26);
            end case;
        end if;
    end process;
    

end;
