@echo off 
for /f %%a in (module.txt) do (
    echo 引数は「%%a」です
    vcom %%a.vhd    
    vcom %%a_tb.vhd    
)
vsim spcpu_tb -do "add wave spcpu_tb/dut/*"