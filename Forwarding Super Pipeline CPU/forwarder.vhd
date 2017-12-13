library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity forward is
    port(
        ctrl : in std_logic_vector(2 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        exoutdata, maoutdata : in std_logic_vector(31 downto 0);
        out1, out2 : out std_logic_vector(31 downto 0)
    );
end   forward;

architecture rtl of forward is
begin
    
   process (ctrl, in1, in2, exoutdata, maoutdata) 
   begin
       
      case (ctrl) is
         when "000" =>
            out1 <= in1;
            out2 <= in2;
         when "001" =>
            out1 <= in1;
            out2 <= exoutdata;
         when "010" =>
            out1 <= in1;
            out2 <= maoutdata;
         when "011" =>
            out1 <= in2;
            out2 <= exoutdata;
         when "100" =>
            out1 <= in2;
            out2 <= maoutdata;
         when "101"=>
            out1 <= exoutdata;
            out2 <= maoutdata;
         when "110"=>
            out1 <= exoutdata;
            out2 <= exoutdata;
         when "111"=>
            out1 <= maoutdata;
            out2 <= maoutdata;
         when others =>
            out1 <= (others => '0');
            out2 <= (others => '0');
      end case;
   end process;

end;