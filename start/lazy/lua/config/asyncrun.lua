local M = {}

M.stop = function()
  pcall(vim.cmd, 'AsyncStop')
end

M.input = function()
  vim.cmd [[
    call feedkeys("\<esc>:AsyncRun ")
  ]]
end

return M
