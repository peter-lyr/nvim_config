@echo off
 
set cli=%~dp0
set nvim_config=
set pack=
set runtime=
set nvim=
set share=
set nvimwin64=
:begin
for /f "tokens=1,* delims=\" %%i in ("%cli%") do (set content=%%i&&set cli=%%j)
if "%pack%%content%\" == "%~dp0" goto end
set nvimwin64=%share%
set share=%nvim%
set nvim=%runtime%
set runtime=%pack%
set pack=%nvim_config%
set nvim_config=%nvim_config%%content%\
goto begin
:end

set LOCALAPPDATA=%pack%localappdata

set nvimexe=%nvimwin64%bin\nvim.exe"

start %nvimexe%
