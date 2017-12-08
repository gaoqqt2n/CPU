library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity stall_out is
    port(
        inst : in std_logic_vector(31 downto 0);
        pin : in std_logic;
        instout : out std_logic_vector(31 downto 0)
    );
end stall_out;

architecture rtl of stall_out is
    begin
        
        process (inst, pin) begin
            case (pin) is
                when '0' => instout <= x"04000000";
                when '1' => instout <= inst;
                when others => instout <= inst;
            end case;
        end process;
    
end;
