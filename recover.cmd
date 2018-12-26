@echo off
rem Please, use this batch file only if have error on start'ing Far!
echo ************************************************************************
echo *                                                                      *
echo *       WARNING! Far Manager run on recovery settings mode.            *
echo *                                                                      *
echo * Your filters and history will be deleted and all settings are reset! *
echo *                                                                      *
echo ************************************************************************
echo Press any key for continue or Ctrl+C for cancel
pause
copy /b .\Far\Profile\PluginsData\4EBBEFC8-2084-4B7F-94C0-692CE136894D.db /b %TEMP%
cd /d .\Far\Profile
del /f/q *.db*
cd /d .\PluginsData
del /f/q *.db*
cd ../../
setlocal
set k=/ro-
:for use Far on "Read Only" device just remove ":" on string :@set k=/ro
:@set k=/ro
if defined PROCESSOR_ARCHITEW6432 (set reg="%systemroot%\sysnative\reg.exe"
     ) else (
     set reg=reg)
echo REGEDIT4>%TEMP%\def.reg
echo ; >>%TEMP%\def.reg
echo [HKEY_CURRENT_USER\Software\Far Manager\Plugins\FarTray]>>%TEMP%\def.reg
echo "Disable"=dword:00000000>>%TEMP%\def.reg"
echo ; >>%TEMP%\def.reg"
echo [HKEY_CURRENT_USER\Software\Far Manager\Plugins\MultiArc]>>%TEMP%\def.reg
echo "DefaultFormat"="RAR">>%TEMP%\def.reg
reg import %TEMP%\def.reg
del /f/q %TEMP%\def.reg
copy /b %TEMP%\4EBBEFC8-2084-4B7F-94C0-692CE136894D.db /b .\Far\Profile\PluginsData
del /f/q %TEMP%\4EBBEFC8-2084-4B7F-94C0-692CE136894D.db
cd ./Far
far /import default.farconfig
cd ../
start /i .\Far\Far.exe %k
