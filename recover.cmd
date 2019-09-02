@echo off
setlocal enableextensions
rem Please, use this batch file only if have error on start'ing Far!
echo ************************************************************************
echo *                                                                      *
echo *       WARNING! Far Manager run on recovery settings mode.            *
echo *                                                                      *
echo * Your filters and history will be deleted and all settings are reset! *
echo *                                                                      *
echo ************************************************************************
echo Press any key for continue or Ctrl+C for cancel
echo.
pause
copy /b "%~dp0Far\Profile\PluginsData\4EBBEFC8-2084-4B7F-94C0-692CE136894D.db" /b "%TEMP%"
del /f/q "%~dp0Far\Profile\*.db*"
del /f/q "%~dp0Far\Profile\PluginsData\*.db*"
if defined PROCESSOR_ARCHITEW6432 (set reg="%systemroot%\sysnative\reg.exe"
     ) else (
     set reg=reg)
echo REGEDIT4>"%TEMP%\def.reg"
echo ; >>"%TEMP%\def.reg"
echo [HKEY_CURRENT_USER\Software\Far Manager\Plugins\FarTray]>>"%TEMP%\def.reg"
echo "Disable"=dword:00000000>>"%TEMP%\def.reg"
echo ; >>"%TEMP%\def.reg"
echo [HKEY_CURRENT_USER\Software\Far Manager\Plugins\MultiArc]>>"%TEMP%\def.reg"
echo "DefaultFormat"="RAR">>"%TEMP%\def.reg"
%reg% import "%TEMP%\def.reg"
del /f/q "%TEMP%\def.reg"
copy /b "%TEMP%\4EBBEFC8-2084-4B7F-94C0-692CE136894D.db" /b "%~dp0Far\Profile\PluginsData"
del /f/q "%TEMP%\4EBBEFC8-2084-4B7F-94C0-692CE136894D.db"
cd /d "%~dp0Far"
start /wait far "lua:mf.print('far -import default.farconfig') Keys('Enter F10 Enter')"
start /i Far C:\ C:\ -ro-
exit /b
