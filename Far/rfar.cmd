@echo off
setlocal enableextensions
if defined PROCESSOR_ARCHITEW6432 (set reg="%systemroot%\sysnative\reg.exe"
     ) else (
     set reg=reg)
set prm=%1 %2 %3 %4
if not "%4"=="" (goto nxt)
if not "%3"=="" (goto nxt)
if not "%2"=="" (goto nxt)
if not "%1"=="" (goto nxt)
set prm=C:\ C:\
:nxt
echo REGEDIT4>"%TEMP%\def.reg"
echo ; >>"%TEMP%\def.reg"
echo [HKEY_CURRENT_USER\Software\Far Manager\Plugins\MultiArc]>>"%TEMP%\def.reg"
echo "DefaultFormat"="RAR">>"%TEMP%\def.reg"
%reg% import "%TEMP%\def.reg" > nul
del /f/q "%TEMP%\def.reg" > nul
del /s/f/q .\Profile\*.db-* > nul
start /i .\Far.exe %prm%
exit