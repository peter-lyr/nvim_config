local M = {}

M.monitor_1min = function()
  local cmd = '!powercfg -x -monitor-timeout-ac 1'
  vim.cmd(cmd)
  print(cmd)
end

M.monitor_30min = function()
  local cmd = '!powercfg -x -monitor-timeout-ac 30'
  vim.cmd(cmd)
  print(cmd)
end

M.proxy_on = function()
  local cmd = [[!reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f]]
  vim.cmd(cmd)
  print('proxy on')
end

M.proxy_off = function()
  local cmd = [[!reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f]]
  vim.cmd(cmd)
  print('proxy off')
end

return M
