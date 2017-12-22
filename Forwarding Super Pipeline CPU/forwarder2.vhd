library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity forwarder2 is
    port(
        clk, rst : in std_logic;
        ctrl : in std_logic_vector(4 downto 0);
        in1, in2, rtdata : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2, outdatamem : out std_logic_vector(31 downto 0)
    );
end   forwarder2;

architecture rtl of forwarder2 is
begin
    
    process (clk, rst, ctrl, in1, in2, rtdata, exoutdata, maoutdata) 
    variable bbbdata : std_logic_vector(31 downto 0) := x"00000000";
    begin
        
        if (rst = '0') then
            out1 <= in1;
            out2 <= in2;
            outdatamem <= rtdata;
        elsif (clk'event and clk = '1') then

            case (ctrl(4 downto 3)) is
                when "00" =>
                    out1 <= in1;
                    bbbdata := maoutdata;
                when "01" =>
                    out1 <= exoutdata;
                    bbbdata := maoutdata;
                when "10" =>
                    out1 <= maoutdata;
                    bbbdata := maoutdata;
                when "11"=>
                    out1 <= bbbdata;
                    bbbdata := maoutdata;
                when others =>
                    out1 <= in1;
                    bbbdata := maoutdata;
            end case;
            
            case (ctrl(2 downto 0)) is
                when "000"=>
                    out2 <= in2;
                    outdatamem <= rtdata;
                    bbbdata := maoutdata;
                when "001"=>
                    out2 <= exoutdata;
                    outdatamem <= rtdata;
                    bbbdata := maoutdata;
                when "010"=>
                    out2 <= maoutdata;
                    outdatamem <= rtdata;
                    bbbdata := maoutdata;
                when "011"=>
                    out2 <= bbbdata;
                    outdatamem <= rtdata;
                    bbbdata := maoutdata;
                when "101"=>
                    out2 <= in2;
                    outdatamem <= exoutdata;
                    bbbdata := maoutdata;
                when "110"=>
                    out2 <= in2;
                    outdatamem <= maoutdata;
                    bbbdata := maoutdata;
                when "111"=>
                    out2 <= in2;
                    outdatamem <= bbbdata;
                    bbbdata := maoutdata;
                when others =>
                    out2 <= in2;
                    outdatamem <= rtdata;
                    bbbdata := maoutdata;
            end case;

            -- bbbdata := maoutdata;
        
        end if;
    end process;

end;