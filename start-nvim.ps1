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

# get nvim.exe and run

$nvimexe = $nvimwin64 + "\bin\nvim.exe"
. $nvimexe
