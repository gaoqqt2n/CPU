@echo off 
for /f %%a in (module.txt) do (
    echo 引数は「%%a」です
    vcom %%a.vhd    
    vcom %%a_tb.vhd    
)
vsim pcpu_tb -do "add wave -HEX pcpu_tb/dut/* ; run -all"