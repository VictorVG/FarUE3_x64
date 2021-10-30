@echo off
rem Update script for FarUE3 x64 only!
setlocal enableextensions
for /f "tokens=4" %%a in ('ver') do (set prm=%%a)
set prm=%prm:~0,3% && set M=%prm:~0,1% && set N=%prm:~2,1%
if %M% geq 6 (
  if %N% geq 1 (
  if exist "%~dp0Far\wget.ex7" (move /y "%~dp0Far\wget.ex7" "%~dp0Far\wget.exe" > nul)
  if exist "%~dp0Far\wget.tx7" (move /y "%~dp0Far\wget.tx7" "%~dp0Far\wget.txt" > nul)
  if exist "%~dp0Far\wget.*7" (del /f/q Far\wget.*7 > nul)
 )
)
cd /d "%~dp0Far" > nul
if exist "Profile\plugincache.*" (del /f/q "Profile\plugincache.*" > nul)
if exist "Profile*.db.-*" (del /f/q "Profile\*.db.-*" > nul)
if exist wget.ini (del /f/q wget.ini > nul)
if exist wgetrc (ren wgetrc wgetrc.sam > nul)
if exist changelog_eng (del /f/q changelog_eng > nul)
if exist "plugins\advcmpexw" (move /y "plugins\advcmpexw" "plugins\advcmpex" > nul)
if exist "plugins\arclite\Codecs\WinCryptHashers.ini" (
if exist "plugins\arclite\Formats\WinCryptHashers.ini" (del /s/f/q "plugins\arclite\Codecs\WinCryptHashers.ini" > nul
        ) else (
        move /y "plugins\arclite\Codecs\WinCryptHashers.ini" "plugins\arclite\Formats\WinCryptHashers.ini" > nul
        )
        )
if exist "plugins\arclite\Codecs\WinCryptHashers.64.codec" (del /s/f/q "plugins\arclite\Codecs\WinCryptHashers.64.codec" > nul)
if exist "plugins\audioplayer\AudioPlayerHelp.lua" (del /f/q "plugins\audioplayer\AudioPlayerHelp.lua" > nul)
if exist "plugins\audioplayer\bass_cdg.dll" (del /f/q "plugins\audioplayer\bass_cdg.dll" > nul)
if exist "plugins\calcpl" (rd /s/q "plugins\calcpl" > nul)
if exist "plugins\dnd\drgndrop_x86*.hook" (del /f/q "plugins\dnd\drgndrop_x86*.hook" > nul)
if exist "plugins\dnd\holder_x86*.dnd" (del /f/q "plugins\dnd\holder_x86*.dnd" > nul)
if exist "plugins\editor\colorer\macros.md" (del /f/q "plugins\editor\colorer\macros.md" > nul)
if exist "plugins\editor\colorer\base\hrc\CHANGELOG" (del /f/q "plugins\editor\colorer\base\hrc\CHANGELOG" > nul)
if exist "plugins\editor\colorer\base\hrc\common.jar" (del /f/q "plugins\editor\colorer\base\hrc\common.jar" > nul)
if exist "plugins\editor\colorer\base\hrc\*.hrc" (del /f/q "plugins\editor\colorer\base\hrc\*.hrc" > nul)
if exist "plugins\editor\colorer\base\hrc\*auto" (
          move /y "plugins\editor\colorer\base\hrc\auto" "plugins\editor\colorer\base\auto"> nul
          rd /s/q "plugins\editor\colorer\base\hrc" > nul)
if exist "plugins\editor\colorer\base\hrd" (rd /s/q "plugins\editor\colorer\base\hrd" > nul)
if exist "plugins\farhints" (rd /s/q "plugins\farhints" > nul)
if exist "plugins\multiarc\Formats\targz.fmt" (del /f/q "plugins\multiarc\Formats\targz.fmt" > nul)
if exist "plugins\observer\modules\msvcp100.dll" (del /f/q "plugins\observer\modules\msvcp100.dll" > nul)
if exist "plugins\observer\modules\msvcr100.dll" (del /f/q "plugins\observer\modules\msvcr100.dll" > nul)
if exist "plugins\polygon\lsqlite3.dl" (del /f/q "plugins\polygon\lsqlite3.dl" > nul)
if exist "plugins\sqlitedb" (rd /s/q "plugins\sqlitedb" > nul)
if exist "plugins\svcmgr\svcmgr-x32.dll" (del /f/q "plugins\svcmgr\svcmgr-x32.dll" > nul)
if exist "Profile\Macros\modules\c0BOM.lua" (del /f/q "Profile\Macros\modules\c0BOM.lua" > nul)
if exist "Profile\Macros\modules\luacheck\analyze.lua" (del /f/q "Profile\Macros\modules\luacheck\analyze.lua" > nul)
if exist "Profile\Macros\modules\luacheck\argparse.lua" (del /f/q "Profile\Macros\modules\luacheck\argparse.lua" > nul)
if exist "Profile\Macros\modules\luacheck\builtin_standards.lua" (del /f/q "Profile\Macros\modules\luacheck\builtin_standards.lua" > nul)
if exist "Profile\Macros\modules\luacheck\detect_globals.lua" (del /f/q "Profile\Macros\modules\luacheck\detect_globals.lua" > nul)
if exist "Profile\Macros\modules\luacheck\inline_options.lua" (del /f/q "Profile\Macros\modules\luacheck\inline_options.lua" > nul)
if exist "Profile\Macros\modules\luacheck\lfs_fs.lua" (del /f/q "Profile\Macros\modules\luacheck\lfs_fs.lua" > nul)
if exist "Profile\Macros\modules\luacheck\linearize.lua" (del /f/q "Profile\Macros\modules\luacheck\linearize.lua" > nul)
if exist "Profile\Macros\modules\luacheck\love_standard.lua" (del /f/q "Profile\Macros\modules\luacheck\love_standard.lua" > nul)
if exist "Profile\Macros\modules\luacheck\lua_fs.lua" (del /f/q "Profile\Macros\modules\luacheck\lua_fs.lua" > nul)
if exist "Profile\Macros\modules\luacheck\ngx_standard.lua" (del /f/q "Profile\Macros\modules\luacheck\ngx_standard.lua" > nul)
if exist "Profile\Macros\modules\luacheck\reachability.lua" (del /f/q "Profile\Macros\modules\luacheck\reachability.lua" > nul)
if exist "Profile\Macros\modules\luacheck\whitespace.lua" (del /f/q "Profile\Macros\modules\luacheck\whitespace.lua" > nul)
if exist "Profile\Macros\modules\LuaManager.lua" (del /f/q "Profile\Macros\modules\LuaManager.lua" > nul)
if exist "Profile\Macros\modules\rebind.lua" (del /f/q "Profile\Macros\modules\rebind.lua" > nul)
if exist "Profile\Macros\scripts\bindings" (del /f/q "Profile\Macros\scripts\bindings" > nul)
if exist "Profile\Macros\scripts\Dialog_ToEditor.lua" (del /f/q "Profile\Macros\scripts\Dialog_ToEditor.lua" > nul)
if exist "Profile\Macros\scripts\Editor_ColorerRefresh.lua" (del /f/q "Profile\Macros\scripts\Editor_ColorerRefresh.lua" > nul)
if exist "Profile\Macros\scripts\Editor_ColorerTypeList.lua" (del /f/q "Profile\Macros\scripts\Editor_ColorerTypeList.lua" > nul)
if exist "Profile\Macros\scripts\Editor_IntegrateMacro.lua" (del /f/q "Profile\Macros\scripts\Editor_IntegrateMacro.lua" > nul)
if exist "Profile\Macros\scripts\Editor_LuaMacroComplit.lua" (del /f/q "Profile\Macros\scripts\Editor_LuaMacroComplit.lua" > nul)
if exist "Profile\Macros\scripts\Editor_Print.moon" (del /f/q "Profile\Macros\scripts\Editor_Print.moon" > nul)
if exist "Profile\Macros\scripts\Plugin_AudioPlayer.lua" (del /f/q "Profile\Macros\scripts\Plugin_AudioPlayer.lua" > nul)
if exist "Profile\Macros\scripts\Plugin_FarHint.lua" (del /f/q "Profile\Macros\Plugin_FarHint.lua" > nul)
if exist "Profile\Macros\scripts\Shell_DeepTarball.lua" (del /f/q "Profile\Macros\scripts\Shell_DeepTarball.lua" > nul)
if exist "Profile\Macros\scripts\Shell_DelTmp.lua" (del /f/q "Profile\Macros\scripts\Shell_DelTmp.lua" > nul)
if exist "Profile\Macros\scripts\Shell_SomDir.lua" (del /f/q "Profile\Macros\scripts\Shell_SomDir.lua" > nul)
if exist "Profile\Macros\scripts\View_ShiftInsSearch.lua" (move /y "Profile\Macros\scripts\View_ShiftInsSearch.lua" "Profile\Macros\scripts\Viewer_ShiftInsSearch.lua" > nul)
if exist "Profile\Macros\scripts\View_XDOC.lua" (move /y "Profile\Macros\scripts\View_XDOC.lua" "Profile\Macros\scripts\Viewer_XDOC.lua" > nul)
if exist "Profile\Macros\scripts\Shell_SortDir.lua" (del /f/q "Profile\Macros\scripts\Shell_SortDir.lua" > nul)
if exist "Profile\PluginsData\CDF48DA0-0334-4169-8453-69048DD3B51C.db" (del /f/q "Profile\PluginsData\CDF48DA0-0334-4169-8453-69048DD3B51C.db" > nul)
if exist "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" (del /f/q "Profile\PluginsData\FC97A376-00D9-4DE4-B2E1-BFDC3A8D8B0B.db" > nul)
far -import default.farconfig
rem The next string used only if needed fix some Far or plug-in's settings, is another not used and always mast be comment!
if exist farfix.cnf (start /wait /b far -import farfix.cnf && del /f/q farfix.cnf > nul)
if exist wg.cmd (del/f/q wg.cmd > nul)
cd /d "%~dp0" > nul
del /f/q "%~dp0update.cmd" > nul
exit /b 0 > nul