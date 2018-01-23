library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity alu_calc is
    port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        shamt : in std_logic_vector(4 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        aluout : out std_logic_vector(31 downto 0)
    );
end   alu_calc;

architecture rtl of alu_calc is
begin
    
    process (rst, aluctrl, shamt, in1, in2) 
    begin
        
        if (rst = '0') then
            aluout <= (others => '0');
        else
            case(aluctrl) is
            
               when "0000" => aluout <= shl(in2, shamt); --hidari ronri 
               when "0001" => aluout <= shr(in2, shamt); --migi ronri
               when "0010" => aluout <= std_logic_vector(shr(signed(in2),unsigned(shamt))); --migi sanjutu
               when "0100" => aluout <= in1 + in2;
               when "0101" => aluout <= in1 - in2;
               when "1000" => aluout <= in1 and in2;
               when "1001" => aluout <= in1 or in2;
               when "1010" => aluout <= in1 nor in2;
               when "1011" => aluout <= in1 xor in2;
               when "1100" => --set on less than
                  if (in1 < in2) then 
                    aluout <= X"00000001"; 
                  else
                    aluout <= X"00000000";
                  end if;

               when others => aluout <= (others => '0');  
                 
            end case ;

        end if;
    end process;

end;