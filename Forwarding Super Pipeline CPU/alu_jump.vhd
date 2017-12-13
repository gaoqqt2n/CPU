library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity alu_jump is
    port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        adsel_ctrl : out std_logic_vector(1 downto 0)
    );
end   alu_jump;

architecture rtl of alu_jump is
begin
    
    process (rst, aluctrl, in1, in2) 
    -- variable sc : integer := conv_integer(shamt); 
    -- variable tmp : std_logic_vector(31 downto 0) := x"00000000";
    begin
        
        if (rst = '0') then
            adsel_ctrl <= "00";
        else
            if (aluctrl = "1101" and (in1 = in2)) then --beq
                adsel_ctrl <= "01";
            elsif (aluctrl = "1110") then --jump
                adsel_ctrl <= "10";
            else 
                adsel_ctrl <= "00"; --pc+4
            end if;

        end if;
    end process;

end;