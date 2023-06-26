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

REM  cd repo

cd %pack%nvim_config

REM  try kill exe

taskkill /f /im start-nvim-qt.exe

REM  build exe

windres -i "neovim.ico.rc" -o "neovim.ico.o"
gcc start-nvim-qt.c neovim.ico.o -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o start-nvim-qt

REM  compress exe

strip -s %pack%nvim_config\start-nvim-qt.exe
upx --best %pack%nvim_config\start-nvim-qt.exe

REM  run exe

REM  %pack%nvim_config\start-nvim-qt