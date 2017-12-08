@echo off 
for /f %%a in (module.txt) do (
    echo à¯êîÇÕÅu%%aÅvÇ≈Ç∑
    ghdl -a --ieee=synopsys -fexplicit %%a.vhd
    ghdl -a --ieee=synopsys %%a_tb.vhd
    ghdl -e --ieee=synopsys -fexplicit %%a_tb
    ghdl -r --ieee=synopsys -fexplicit %%a_tb --vcd=%%a.vcd
    move /y %%a.vcd vcdfile
)
if "%1"=="1" (
    start gtkwave vcdfile/pcpu.vcd
)
if "%1"=="2" (
    start modelsim.bat
)
if "%1"=="12" (
    start gtkwave vcdfile/pcpu.vcd
    start modelsim.bat
)
