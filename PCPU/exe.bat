@echo off
setlocal

if xx%1==xx goto error
echo �����́u%*�v�ł��B
ghdl -a --ieee=synopsys -fexplicit %1.vhd
ghdl -a --ieee=synopsys %1_tb.vhd
ghdl -e --ieee=synopsys -fexplicit %1_tb
ghdl -r --ieee=synopsys -fexplicit %1_tb --vcd=%1.vcd
move /y %1.vcd vcdfile

if "%2"=="1" (
    start gtkwave vcdfile/%1.vcd
)
goto :eof  

:error
echo ���������ċN�����Ă�������