@echo off
cd /d Far > nul
if exist "plugins\intchecker\scripts\InChecker.GetFileHash.lua" (del /f/q "plugins\intchecker\scripts\InChecker.GetFileHash.lua" > nul)
if exist "plugins\intchecker\scripts\intchecker_run.lua" (del /f/q "plugins\intchecker\scripts\intchecker_run.lua" > nul)
if exist "plugins\farhints\Plugins\Folders" (rd /s/q "plugins\farhints\Plugins\Folders")
if exist "plugins\sqlitedb" (rd /s/q "plugins\sqlitedb")
if exist "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" (del /s/q "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db")
if exist "Profile\colors.db" (del /s/q "Profile\colors.db")
if exist "Profile\highlight.db" (del /s/q "Profile\highlight.db")
far /import default.farconfig
cd ../ > nul
del /f/q update.cmd > nul
exit /b 0 > nul