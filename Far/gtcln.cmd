@echo off
setlocal enableextensions
if "%1" == "-r" (if "%3"=="" (goto usg
 ) else (
 if "%2" == "" (goto usg)
 )
set br=%4 && git clone -c core.symlinks=true %2 %3 && cd /d %3 && goto brnch)
if not "%1" == "-b" (goto usg)
if not "%3" == "" (set br=%3 && cd %2) else (if not "%2"=="" (if not exist %2 (set br=%2) else ((set br=) && cd %2)) else (set br=))
:brnch
git branch -r > "%temp%\fargtbch.txt"
for /f %%A in ('findstr /v master "%temp%\fargtbch.txt"') do (git checkout -t %%A)
del /f/q %temp%\fargtbch.txt > nul
if not "%br%" == "" (git checkout %br%%)
exit
:usg
echo.
echo Synopsis:
echo.
echo Clone Git repository include all branches or clone branches only for
echo existing Git repository.
echo.
echo Required:
echo.
echo Git v1.9 or never, Windows XP or never console and device "straight arms".
echo.
echo Usage:
echo.
echo gtcln -r URL DIR [BRANCH] or gtcln -b DIR [BRANCH] or gtcln -b [BRANCH]
echo.
echo Parameters:
echo.
echo URL - remout repository URL (required for -r switch)
echo DIR - local repository dir (required for -r switch)
echo BRANCH - switch local repository to BRANCH if defined
echo.
pause
exit