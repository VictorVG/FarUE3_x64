rem For Far3 only! If on you system exists Far 1.x/Far.2.x and you use Far3 please, use runfar2.cmd
@echo off
setlocal enableextensions
if "%2"=="" (set pp="C:\") else (set pp=%2)
if "%1"=="" (set ap="C:\") else (set ap=%1)
if defined PROCESSOR_ARCHITEW6432 (set reg="%systemroot%\sysnative\reg.exe"
     ) else (
     set reg=reg)
echo REGEDIT4>"%TEMP%\def.reg"
echo ; >>"%TEMP%\def.reg"
echo [HKEY_CURRENT_USER\Software\Far Manager\Plugins\MultiArc]>>"%TEMP%\def.reg"
echo "DefaultFormat"="RAR">>"%TEMP%\def.reg"
%reg% import "%TEMP%\def.reg" > nul
del /f/q "%TEMP%\def.reg" > nul
del /s/f/q .\Profile\*.db-* > nul
start /i .\Far.exe %ap% %pp% %3
exit
