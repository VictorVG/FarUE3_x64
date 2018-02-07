@echo off&if exist update.cmd (far\hidcon-x64.exe update.cmd)
@cd Far&hidcon-x64.exe /detach rfar.cmd %1&exit