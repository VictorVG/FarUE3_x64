@echo off
cd /d Far > nul
if exist "plugins\intchecker\scripts\InChecker.GetFileHash.lua" (del /f/q "plugins\intchecker\scripts\InChecker.GetFileHash.lua" > nul)
if exist "plugins\intchecker\scripts\intchecker_run.lua" (del /f/q "plugins\intchecker\scripts\intchecker_run.lua" > nul)
if exist "plugins\farhints\Plugins \Folders" (rd /s/q "plugins\farhints\Plugins \Folders")
far /import default.farconfig
cd ../ > nul
del /f/q update.cmd > nul
exit /b 0 > nul