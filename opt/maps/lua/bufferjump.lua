local M = {}

M.k = function()
  vim.cmd('wincmd k')
end

M.j = function()
  vim.cmd('wincmd j')
end

return M
