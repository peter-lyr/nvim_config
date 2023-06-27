$ps1 = $MyInvocation.MyCommand.Path
$config = Split-Path -Parent $ps1
$pack = Split-Path -Parent $config
$runtime = Split-Path -Parent $pack
$nvim = Split-Path -Parent $runtime
$share = Split-Path -Parent $nvim
$nvimwin64 = Split-Path -Parent $share

# get and set localappdata

$localappdata = $pack + "\localappdata"
$env:LOCALAPPDATA=$localappdata

# set alias and run nvim.exe

$nvimexe = $nvimwin64 + "\bin\nvim.exe"

New-Alias -Name nvim -Value $nvimexe

. $nvimexe
