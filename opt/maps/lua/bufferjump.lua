local M = {}

M.max_en = 1

M.check = function()
  if M.max_en then
    if vim.opt.winfixheight:get() == false then
      vim.cmd('wincmd _')
    end
  end
end

M.k = function()
  vim.cmd('wincmd k')
  M.check()
end

M.j = function()
  vim.cmd('wincmd j')
  M.check()
end

M.oo = function()
  M.max_en = 1
  print('win height auto max enabled')
end

M.ii = function()
  M.max_en = nil
  print('win height auto max disabled')
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
