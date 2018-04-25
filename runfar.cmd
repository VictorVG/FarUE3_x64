@echo off
if exist %~dps0update.cmd (call %~dps0update.cmd > nul)
cd Far && hidcon-x64.exe /detach rfar.cmd %1 && exit