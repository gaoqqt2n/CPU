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
        ctrl : out std_logic_vector(8 downto 0) --mux:1,alu:4,dm:1,mux:1,mux:1,regfile:1
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
            when "000000" => ctrl <= "010000011"; --shift left logical
            when "000001" => ctrl <= "010001011"; --shift right logical
            when "000011" => ctrl <= "010010011"; --shift right arithmetic
            when "100000" => ctrl <= "010100011"; --add
            when "100010" => ctrl <= "010101011"; --sub
            when "100100" => ctrl <= "011000011"; --and
            when "100101" => ctrl <= "011001011"; --or
            when "100110" => ctrl <= "011010011"; --nor
            when "100111" => ctrl <= "011011011"; --xor
            when "101010" => ctrl <= "011100011"; --set on less than
            when others => ctrl <= (others => '0');
         end case;
         when "100011" => ctrl <= "100100001"; --load
         when "101011" => ctrl <= "110100100"; --store
         when "000100" => ctrl <= "011101010"; --beq
         when "000010" => ctrl <= "011110000"; --jump
         when "000001" => ctrl <= "010000000"; --nop

         when others => ctrl <= (others => '0');
      end case;
   end if;
   end process;

end;