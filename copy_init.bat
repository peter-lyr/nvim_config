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

if not exist %pack%localappdata (
  md %pack%localappdata
)

if not exist %pack%localappdata\nvim (
  md %pack%localappdata\nvim
)

copy /y %nvim_config%init.lua %pack%localappdata\nvim\init.lua
