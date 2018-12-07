@echo off
if exist "%~dp0update.cmd" (call "%~dp0update.cmd" > nul)
cd Far && hidcon-x64.exe /detach rfar.cmd %1 && exit