@echo off

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

timeout /t 3
exit
