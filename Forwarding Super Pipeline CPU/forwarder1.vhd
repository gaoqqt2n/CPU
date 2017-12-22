library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity forwarder1 is
    port(
        ctrl : in std_logic_vector(4 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end   forwarder1;

architecture rtl of forwarder1 is
begin
    
    process (ctrl, in1, in2, exoutdata, maoutdata) 
    variable bbbdata : std_logic_vector(31 downto 0) := x"00000000";
    begin
        
        case (ctrl(4 downto 3)) is
            when "00" =>
                out1 <= in1;
            when "01" =>
                out1 <= exoutdata;
            when "10" =>
                out1 <= maoutdata;
            when "11"=>
                out1 <= bbbdata;
            when others =>
                out1 <= in1;
        end case;
        
        case (ctrl(1 downto 0)) is
            when "00"=>
                out2 <= in2;
            when "01"=>
                out2 <= exoutdata;
            when "10"=>
                out2 <= maoutdata;
            when "11"=>
                out2 <= bbbdata;
            when others =>
                out2 <= in2;
        end case;
        bbbdata := maoutdata;
    end process;

end;