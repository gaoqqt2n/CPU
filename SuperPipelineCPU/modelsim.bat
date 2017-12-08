@echo off 
for /f %%a in (module.txt) do (
    echo ˆø”‚Íu%%av‚Å‚·
    vcom %%a.vhd    
    vcom %%a_tb.vhd    
)
REM vsim spcpu_tb -do "add wave -HEX spcpu_tb/dut/* ; add wave -HEX spcpu_tb/dut/m1/* ; add wave -HEX spcpu_tb/dut/m1/m4/* ; add wave -HEX spcpu_tb/dut/m3/* ; add wave -HEX spcpu_tb/dut/m6/* ; run -all"
vsim spcpu_tb -do "add wave -HEX spcpu_tb/dut/clk ; add wave -HEX spcpu_tb/dut/rst ; add wave -HEX spcpu_tb/dut/outdata ; add wave -HEX spcpu_tb/dut/regwe ; add wave -HEX spcpu_tb/dut/regwad ; add wave -HEX spcpu_tb/dut/regwdata ; add wave -HEX spcpu_tb/dut/m1/m4/* ; add wave -HEX spcpu_tb/dut/m3/inst ; add wave -HEX spcpu_tb/dut/R_inst ; add wave -HEX spcpu_tb/dut/m6/inst ; add wave -HEX spcpu_tb/dut/m6/instout ; run -all"