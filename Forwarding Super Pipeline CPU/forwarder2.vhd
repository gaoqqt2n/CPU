library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity forwarder2 is
    port(
        clk, rst : in std_logic;
        ctrl : in std_logic_vector(3 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end   forwarder2;

architecture rtl of forwarder2 is
begin
    
    process (clk, rst, ctrl, in1, in2, exoutdata, maoutdata) 
    -- variable tmp1, tmp2 : std_logic_vector(31 downto 0) := x"00000000";
    begin
        
        if (rst = '0') then
            out1 <= in1;
            out2 <= in2;
        elsif (clk'event and clk = '1') then

        case (ctrl) is
            when "0001" =>
                out1 <= in1;
                out2 <= in2;
            when "0010" =>
                out1 <= in1;
                out2 <= exoutdata;
            when "0011" =>
                out1 <= in1;
                out2 <= maoutdata;
            when "0100"=>
                out1 <= exoutdata;
                out2 <= in2;
            when "0101"=>
                out1 <= exoutdata;
                out2 <= exoutdata;
            when "0110"=>
                out1 <= exoutdata;
                out2 <= maoutdata;
            when "0111"=>
                out1 <= maoutdata;
                out2 <= in2;
            when "1000"=>
                out1 <= maoutdata;
                out2 <= exoutdata;
            when "1001"=>
                out1 <= maoutdata;
                out2 <= maoutdata;
            when others =>
                out1 <= (others => '0');
                out2 <= (others => '0');
        end case;
        end if;
    end process;

end;