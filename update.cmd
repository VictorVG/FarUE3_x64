@echo off
setlocal enableextensions
for /f "tokens=4" %%a in ('ver') do (set prm=%%a)
set prm=%prm:~0,3% && set M=%prm:~0,1% && set N=%prm:~2,1%
if %M% geq 6 (if %N% geq 1 (move /y Far\wget.ex7 Far\wget.exe > nul & move /y Far\wget.tx7 Far\wget.txt > nul))
if exist Far\wget.*7 (del /f/q Far\wget.*7 > nul)
cd /d Far > nul
if exist "plugins\dnd\drgndrop_x86*.hook" (del /s/q "plugins\dnd\drgndrop_x86*.hook" > nul)
if exist "plugins\dnd\holder_x86*.dnd"  (del /s/q "plugins\dnd\holder_x86*.dnd" > nul)
if exist "plugins\farhints\Plugins\Folders" (rd /s/q "plugins\farhints\Plugins\Folders" > nul)
if exist "plugins\intchecker\scripts\InChecker.GetFileHash.lua" (del /f/q "plugins\intchecker\scripts\InChecker.GetFileHash.lua" > nul)
if exist "plugins\multiarc\Formats\targz.fmt" (del /s/q "plugins\multiarc\Formats\targz.fmt" > nul)
if exist "plugins\sqlitedb" (rd /s/q "plugins\sqlitedb" > nul)
if exist "Profile\Macros\modules\LuaManager.lua" (del /s/q "Profile\Macros\modules\LuaManager.lua" > nul)
if exist "Profile\Macros\scripts\Dialog_ToEditor.lua" (del /s/q "Profile\Macros\scripts\Dialog_ToEditor.lua" > nul)
if exist "Profile\Macros\scripts\Editor_IntegrateMacro.lua" (del /s/q "Profile\Macros\scripts\Editor_IntegrateMacro.lua" > nul)
if exist "Profile\Macros\scripts\Shell_DeepTarball.lua" (del /s/q "Profile\Macros\scripts\Shell_DeepTarball.lua" > nul)
if exist "Profile\Macros\scripts\Shell_DelTmp.lua" (del /s/q "Profile\Macros\scripts\Shell_DelTmp.lua" > nul)
if exist "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" (del /s/q "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" > nul)
rem far /import default.farconfig
rem The next string used only if needed fix some Far or plug-in's settings, is another not used and always mast be comment!
if exist farfix.cnf (start /wait far "lua:mf.print('far -import farfix.cnf') Keys('Enter F10 Enter')" && del /f/q farfix.cnf > nul)
if exist wg.cmd (del/f/q wg.cmd > nul)
cd ../ > nul
del /f/q update.cmd > nul
exit /b 0 > nul