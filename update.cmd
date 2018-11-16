@echo off
cd /d Far > nul
if exist "plugins\intchecker\scripts\InChecker.GetFileHash.lua" (del /f/q "plugins\intchecker\scripts\InChecker.GetFileHash.lua" > nul)
if exist "plugins\intchecker\scripts\intchecker_run.lua" (del /f/q "plugins\intchecker\scripts\intchecker_run.lua" > nul)
if exist "plugins\farhints\Plugins\Folders" (rd /s/q "plugins\farhints\Plugins\Folders" > nul)
if exist "plugins\sqlitedb" (rd /s/q "plugins\sqlitedb" > nul)
if exist "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" (del /s/q "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" > nul)
if exist "Profile\colors.db" (del /s/q "Profile\colors.db" > nul)
if exist "Profile\highlight.db" (del /s/q "Profile\highlight.db" > nul)
if exist "Profile\Macros\scripts\Shell_DelTmp.lua" (del /s/q "Profile\Macros\scripts\Shell_DelTmp.lua" > nul)
if exist "Profile\Macros\scripts\Dialog_ToEditor.lua" (del /s/q "Profile\Macros\scripts\Dialog_ToEditor.lua" > nul)
if exist "Profile\Macros\scripts\Editor_IntegrateMacro.lua" (del /s/q "Profile\Macros\scripts\Editor_IntegrateMacro.lua" > nul)
far /import default.farconfig
cd ../ > nul
del /f/q update.cmd > nul
exit /b 0 > nul