library ieee;
use ieee.STD_LOGIC_1164.all;
library ieee;
use ieee.STD_LOGIC_ARITH.all;
library ieee;
use ieee.STD_LOGIC_UNSIGNED.all;

entity datamem is
    port(
        clk, rst, we : in std_logic;
        address : in std_logic_vector(5 downto 0);
        indata : in std_logic_vector(31 downto 0);
        outdata : out std_logic_vector(31 downto 0)
    );
end datamem;

architecture rtl of datamem is
   subtype memword is std_logic_vector(31 downto 0);
   type memarray is array (0 to 64) of memword;
   signal memdata : memarray;
   begin
    
    process (clk, rst) begin
        if (rst = '0') then
            -- memdata(0) <= x"00000000";
            -- memdata(1) <= x"00000001";
            -- memdata(2) <= x"00000002";
            -- memdata(3) <= x"00000003";
            -- memdata(4) <= x"00000004";
            -- memdata(5) <= x"00000005";
            -- memdata(6) <= x"00000006";
            -- memdata(7) <= x"00000007";
            -- memdata(8) <= x"00000008";
            memdata(0)	<= X"00000000";
            memdata(1)	<= X"00000001";
            memdata(2)	<= X"00000002";
            memdata(3)	<= X"00000003";
            memdata(4)	<= X"00000004";
            memdata(5)	<= X"00000005";
            memdata(6)	<= X"00000006";
            memdata(7)	<= X"00000007";
            memdata(8)	<= X"00000008";
            memdata(9)	<= X"00000009";
            memdata(10)	<= X"0000000a";
            memdata(11)	<= X"0000000b";
            memdata(12)	<= X"0000000c";
            memdata(13)	<= X"0000000d";
            memdata(14)	<= X"0000000e";
            memdata(15)	<= X"0000000f";
            memdata(16)	<= X"00000010";
            memdata(17)	<= X"00000011";
            memdata(18)	<= X"00000012";
            memdata(19)	<= X"00000013";
            memdata(20)	<= X"00000014";
            memdata(21)	<= X"00000015";
            memdata(22)	<= X"00000016";
            memdata(23)	<= X"00000017";
            memdata(24)	<= X"00000018";
            memdata(25)	<= X"00000019";
            memdata(26)	<= X"0000001a";
            memdata(27)	<= X"0000001b";
            memdata(28)	<= X"0000001c";
            memdata(29)	<= X"0000001d";
            memdata(30)	<= X"0000001e";
            memdata(31)	<= X"0000001f";
            memdata(32)	<= X"00000020";
            memdata(33)	<= X"00000021";
            memdata(34)	<= X"00000022";
            memdata(35)	<= X"00000023";
            memdata(36)	<= X"00000024";
            memdata(37)	<= X"00000025";
            memdata(38)	<= X"00000026";
            memdata(39)	<= X"00000027";
            memdata(40)	<= X"00000028";
            memdata(41)	<= X"00000029";
            memdata(42)	<= X"0000002a";
            memdata(43)	<= X"0000002b";
            memdata(44)	<= X"0000002c";
            memdata(45)	<= X"0000002d";
            memdata(46)	<= X"0000002e";
            memdata(47)	<= X"0000002f";
            memdata(48)	<= X"00000030";
            memdata(49)	<= X"00000031";
            memdata(50)	<= X"00000032";
            memdata(51)	<= X"00000000";
            memdata(52)	<= X"00000000";
            memdata(53)	<= X"00000035";
            
            for i in 54 to 63 loop
                memdata(i) <= (others => '0');
            end loop;
            outdata <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (we = '1') then
                memdata(conv_integer(address)) <= indata;
            end if;
            outdata <= memdata(conv_integer(address));
        end if;
    end process;
    
end;