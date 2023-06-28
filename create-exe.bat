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

REM  build nvim-qt.exe

windres -i "qt\neovim.ico.rc" -o "qt\neovim.ico.o"
gcc qt\start-nvim-qt.c qt\neovim.ico.o -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o start-nvim-qt

REM  compress exe

strip -s %pack%nvim_config\start-nvim-qt.exe
upx --best %pack%nvim_config\start-nvim-qt.exe

REM  del obj

del /f /s /q %pack%nvim_config\qt\neovim.ico.o

REM  run exe

REM  %pack%nvim_config\start-nvim-qt

REM  exit bat

timeout /t 3
exit
