@echo off
setlocal

if xx%1==xx goto error
echo �����́u%*�v�ł��B

move /y %1.vcd vcdfile

if "%2"=="1" (
    start gtkwave vcdfile/%1.vcd
)
goto :eof  

:error
echo ���������ċN�����Ă�������