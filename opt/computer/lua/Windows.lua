local M = {}

M.monitor_1min = function()
  vim.fn.system 'powercfg -x -monitor-timeout-ac 1'
  print 'monitor_1min'
end

M.monitor_30min = function()
  vim.fn.system 'powercfg -x -monitor-timeout-ac 30'
  print 'monitor_30min'
end

M.proxy_on = function()
  vim.fn.system [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f]]
  print 'proxy_on'
end

M.proxy_off = function()
  vim.fn.system [[reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f]]
  print 'proxy_off'
end

M.path = function()
  vim.fn.system [[rundll32 sysdm.cpl,EditEnvironmentVariables]]
end

M.sound = function()
  -- ::control.exe /name  Microsoft.AudioDevicesAndSoundThemes
  vim.fn.system [[mmsys.cpl]]
end

return M
