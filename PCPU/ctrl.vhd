library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity ctrl is
    port(
        clk, rst : in std_logic;
        opcode, funct : in std_logic_vector(5 downto 0);
        ctrl : out std_logic_vector(7 downto 0) --mux:1,alu:4,adsel:2,regfile:1
    );
end ctrl;

architecture rtl of ctrl is
begin
    
   process (clk, rst, opcode) begin
   if (rst = '0') then
      ctrl <= (others => '0');
   elsif (clk'event and clk = '1') then
      case (opcode) is 
         when "000000" =>
         case (funct) is
            when "000000" => ctrl <= "00000011"; --shift left logical
            when "000001" => ctrl <= "00001011"; --shift right logical
            when "000011" => ctrl <= "00010011"; --shift right arithmetic
            when "100000" => ctrl <= "00100011"; --add
            when "100010" => ctrl <= "00101011"; --sub
            when "100100" => ctrl <= "01000011"; --and
            when "100101" => ctrl <= "01001011"; --or
            when "100110" => ctrl <= "01010011"; --nor
            when "100111" => ctrl <= "01011011"; --xor
            when "101010" => ctrl <= "01100011"; --set on less than
         end case;
         when "100011" => ctrl <= "10100001"; --load
         when "101011" => ctrl <= "10100100"; --store
         when "000100" => ctrl <= "01101010"; --beq
         when "000010" => ctrl <= "01110000"; --jump
         when "000001" => ctrl <= "00000000"; --nop

         when others => ctrl <= (others => '0');
      end case;
   end if;
   end process;

end;