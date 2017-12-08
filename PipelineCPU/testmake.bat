@echo off
setlocal

if xx%1==xx goto error
echo 引数は「%*」です。

echo library IEEE; > %1_tb.vhd
echo use IEEE.std_logic_1164.all;  >> %1_tb.vhd
echo. >> %1_tb.vhd

echo entity %1_tb is  >> %1_tb.vhd
echo end %1_tb;  >> %1_tb.vhd
echo. >> %1_tb.vhd

echo architecture stimulus of %1_tb is >> %1_tb.vhd
echo component %1  >> %1_tb.vhd
echo     port( >> %1_tb.vhd
echo         clk, rst : in std_logic; >> %1_tb.vhd
echo         next_address : in std_logic_vector(31 downto 0); >> %1_tb.vhd
echo         address : out std_logic_vector(31 downto 0) >> %1_tb.vhd
echo     ); >> %1_tb.vhd
echo end component; >> %1_tb.vhd
echo. >> %1_tb.vhd

echo constant cycle  : time := 200 ns; >> %1_tb.vhd
echo constant half_cycle  : time := 100 ns; >> %1_tb.vhd
echo constant delay  : time := 20 ns; >> %1_tb.vhd
echo. >> %1_tb.vhd


echo signal clk, rst : std_logic;  >> %1_tb.vhd
echo signal next_address, address : std_logic_vector(31 downto 0);  >> %1_tb.vhd
echo. >> %1_tb.vhd

echo begin  >> %1_tb.vhd
echo     dut : %1 port map(clk, rst, next_address, address); >> %1_tb.vhd
echo. >> %1_tb.vhd

echo     process begin    >> %1_tb.vhd
echo. >> %1_tb.vhd

echo     clock : for I in 0 to 9 loop >> %1_tb.vhd
echo             CLK ^<= transport '0'; >> %1_tb.vhd
echo             wait for half_cycle; >> %1_tb.vhd
echo             CLK ^<= transport '1'; >> %1_tb.vhd
echo             wait for half_cycle; >> %1_tb.vhd
echo         end loop;  >> %1_tb.vhd
echo         wait; >> %1_tb.vhd
echo     end process; >> %1_tb.vhd
echo. >> %1_tb.vhd
    
echo      process begin  >> %1_tb.vhd
echo         next_address ^<= x"00000004"; rst ^<= '0'; we ^<= '0'; >> %1_tb.vhd
echo         wait for delay; >> %1_tb.vhd
echo         wait for cycle; >> %1_tb.vhd
echo         next_address <= x"00000008"; rst <= '1'; we <= '0'; >> %1_tb.vhd
echo         wait for cycle; >> %1_tb.vhd
REM echo         wait for 100 ns;   next_address <= x"00000010"; we <= '1'; >> %1_tb.vhd
REM echo         wait for 100 ns;   next_address <= x"00000018";  >> %1_tb.vhd
REM echo         wait for 100 ns;   next_address <= x"00000004";  >> %1_tb.vhd
REM echo         wait for 100 ns;   next_address <= x"00000008";  >> %1_tb.vhd
REM echo         wait for 100 ns;   next_address <= x"0000000c";  >> %1_tb.vhd
REM echo         wait for 100 ns; >> %1_tb.vhd
echo         wait; >> %1_tb.vhd
echo      end process;     >> %1_tb.vhd
echo. >> %1_tb.vhd
    
echo end stimulus; >> %1_tb.vhd
echo. >> %1_tb.vhd

echo configuration cfg_%1_tb of %1_tb is  >> %1_tb.vhd
echo     for stimulus  >> %1_tb.vhd
echo     end for; >> %1_tb.vhd
echo end cfg_%1_tb; >> %1_tb.vhd
echo. >> %1_tb.vhd

code %1_tb.vhd

goto :eof  

:error
echo 引数をつけて起動してください