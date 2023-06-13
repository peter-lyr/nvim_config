local M = {}

M.k = function()
  vim.cmd('wincmd k')
end

M.j = function()
  vim.cmd('wincmd j')
end

M.i = function()
  vim.cmd('wincmd =')
  if vim.opt.winfixheight:get() == true then
    vim.cmd([[
      set nowinfixheight
      wincmd =
      set winfixheight
    ]])
  end
end

return M
