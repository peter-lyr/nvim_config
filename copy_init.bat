@echo off

set tt=%~dp0
set nvim_config=
set pack=
:begin
for /f "tokens=1,* delims=\" %%i in ("%tt%") do (set content=%%i&&set tt=%%j)
if "%pack%%content%\" == "%~dp0" goto end
set pack=%nvim_config%
set nvim_config=%nvim_config%%content%\
goto begin
:end

copy /y %nvim_config%copy_init.bat %pack%localappdata\nvim\init.lua

timeout /t 3
exit
