library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity pc is
    port(
        clk, rst : in std_logic;
        next_address : in std_logic_vector(31 downto 0);
        address : out std_logic_vector(31 downto 0)
    );
end pc;

architecture rtl of pc is
begin
    
    process (clk, rst) begin
        if (rst = '0') then
            address <= (others => '0');
        elsif (clk'event and clk = '1') then
            address <= next_address;
        end if;
    end process;
    
end;
    