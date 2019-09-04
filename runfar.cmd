@echo off
rem Usage: runfar [<apanel_patch> [<ppamel_patch> | [<startup_key> <arg>]]]
cd /d %~dps0
setlocal enableextensions
set prm=%1 %2 %3 %4
if exist update.cmd (call update.cmd > nul)
cd Far
hidcon-x64.exe /detach "rfar.cmd %prm%"
exit