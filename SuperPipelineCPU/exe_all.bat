@echo off 
for /f %%a in (module.txt) do (
    echo à¯êîÇÕÅu%%aÅvÇ≈Ç∑ÅB
    ghdl -a --ieee=synopsys -fexplicit %%a.vhd
    ghdl -a --ieee=synopsys %%a_tb.vhd
    ghdl -e --ieee=synopsys -fexplicit %%a_tb
    ghdl -r --ieee=synopsys -fexplicit %%a_tb --vcd=%%a.vcd
    move /y %%a.vcd vcdfile
)
if "%1"=="1" (
    start gtkwave vcdfile/pcpu.vcd
)