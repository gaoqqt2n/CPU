@echo off 
for /f %%a in (module.txt) do (
    echo �����́u%%a�v�ł�
    vcom %%a.vhd    
    vcom %%a_tb.vhd    
)
vsim pcpu_tb -do "add wave pcpu_tb/dut/* ; run -all"