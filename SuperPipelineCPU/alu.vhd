library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity alu is
    port(
        rst: in std_logic;
        aluctrl : in std_logic_vector(3 downto 0);
        shamt : in std_logic_vector(4 downto 0);
        in1, in2 : in std_logic_vector(31 downto 0);
        adsel_ctrl : out std_logic_vector(1 downto 0);
        aluout : out std_logic_vector(31 downto 0)
    );
end   alu;

architecture rtl of alu is
begin
    
    process (rst, aluctrl, shamt, in1, in2) 
    variable sc : integer;    
    variable tmp : std_logic_vector(31 downto 0) := x"00000000";
    begin
        sc := conv_integer(shamt);
        
        if (rst = '0') then
            aluout <= (others => '0');
            adsel_ctrl <= "00";
        else
            case(aluctrl) is
            
               when "0000" => aluout <= shl(in2, shamt); --hidari ronri 
               when "0001" => aluout <= shr(in2, shamt); --migi ronri
               when "0010" => aluout <= std_logic_vector(shr(signed(in2),unsigned(shamt))); --migi sanjutu
               when "0011" => aluout <= shr(in1 + in2, "10"); --ld, st
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
               
                              adsel_ctrl <= (others => '0');  
            end case ;

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