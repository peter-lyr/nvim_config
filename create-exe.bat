@echo off

REM  get pack

set CurrentPath=%~dp0
set P1Path=
:begin
for /f "tokens=1,* delims=\" %%i in ("%CurrentPath%") do (set content=%%i&&set CurrentPath=%%j)
if "%P1Path%%content%\" == "%~dp0" goto end
set P1Path=%P1Path%%content%\
goto begin
:end
set pack=%P1Path%

cd %pack%nvim_config

REM  try kill exe

taskkill /f /im start-nvim-qt.exe

REM  build nvim-qt.exe

windres -i "qt\neovim.ico.rc" -o "qt\neovim.ico.o"
gcc qt\start-nvim-qt.c qt\neovim.ico.o -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o start-nvim-qt

REM  compress exe

strip -s %pack%nvim_config\start-nvim-qt.exe
upx --best %pack%nvim_config\start-nvim-qt.exe

REM  del obj

del /f /s /q %pack%nvim_config\qt\neovim.ico.o

set repo=%~dp0

REM  cd repo

cd %repo%

REM  try kill exe

taskkill /f /im open-with-cmd.exe
taskkill /f /im open-with-ps1.exe

REM  build nvim.exe

windres -i "cli/neovim.ico.rc" -o "cli/neovim.ico.o"
gcc cli/open-with-cmd.c cli/neovim.ico.o -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o open-with-cmd
gcc cli/open-with-ps1.c cli/neovim.ico.o -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o open-with-ps1

REM  del ico.o

del /f /s /q %repo%cli/neovim.ico.o

REM  compress exe

strip -s %repo%open-with-cmd.exe
upx --best %repo%open-with-cmd.exe

strip -s %repo%open-with-ps1.exe
upx --best %repo%open-with-ps1.exe

REM  run exe

REM  %repo%open-with-cmd.exe
REM  %repo%open-with-ps1.exe

exit
