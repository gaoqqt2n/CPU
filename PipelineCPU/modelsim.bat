@echo off 
for /f %%a in (module.txt) do (
    echo ˆø”‚Íu%%av‚Å‚·
    vcom %%a.vhd    
    vcom %%a_tb.vhd    
)
vsim pcpu_tb -do "add wave pcpu_tb/dut/* ; run -all"