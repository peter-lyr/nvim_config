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

return M
