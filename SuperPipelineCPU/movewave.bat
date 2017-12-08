@echo off
setlocal

if xx%1==xx goto error
echo 引数は「%*」です。

move /y %1.vcd vcdfile

if "%2"=="1" (
    start gtkwave vcdfile/%1.vcd
)
goto :eof  

:error
echo 引数をつけて起動してください