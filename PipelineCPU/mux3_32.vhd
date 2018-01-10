------------------------------------------
------------------------------------------
-- Date        : Mon Jul 31 13:36:47 2017
--
-- Author      : 
--
-- Company     : 
--
-- Description : 
--
------------------------------------------
------------------------------------------
library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;


entity  mux3_32  is
    port (
          sel : in std_logic_vector(1 downto 0); 
          in0, in1, in2 : in std_logic_vector(31 downto 0);
          out1 : out std_logic_vector(31 downto 0));
end mux3_32;

architecture  rtl  of  mux3_32  is
    begin
        process (sel, in0, in1, in2) begin
            case sel is 
                when "00" => out1 <= in0;
                when "01" => out1 <= in1;
                when others  => out1 <= in2;
            end case;
        end process;
    end;
    