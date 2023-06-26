@echo off

set repo=%~dp0

REM  cd repo

cd %repo%

REM  try kill exe

taskkill /f /im start-nvim.exe

REM  build nvim.exe

windres -i "neovim.ico.rc" -o "neovim.ico.o"
gcc start-nvim.c neovim.ico.o -Wall -s -ffunction-sections -fdata-sections -Wl,--gc-sections -O3 -o start-nvim


REM  compress exe

strip -s %repo%start-nvim.exe
upx --best %repo%start-nvim.exe

REM  run exe

REM  %repo%start-nvim.exe
