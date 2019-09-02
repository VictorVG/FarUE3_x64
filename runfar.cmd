@echo off
rem Usage: runfar [<apanel_patch> [<ppamel_patch> [<startup_key>]]]
setlocal enableextensions
set  rf="%~dp0Far\rfar.cmd"
if exist "%~dp0update.cmd" (call "%~dp0update.cmd" > nul)
cd /d "%~dp0Far" && "%~dp0Far\hidcon-x64.exe" /detach "%rf% %1 %2 %3" && exit