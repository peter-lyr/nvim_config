local M = {}

M.height_more = function()
  vim.cmd '10wincmd >'
end

M.height_less = function()
  vim.cmd '10wincmd <'
end

M.width_more = function()
  vim.cmd '5wincmd +'
end

M.width_less = function()
  vim.cmd '5wincmd -'
end

M.copy_tab = function()
  vim.cmd 'wincmd s'
  vim.cmd 'wincmd T'
end

M.copy_up = function()
  vim.cmd 'leftabove split'
end

M.copy_down = function()
  vim.cmd 'split'
end

M.copy_right = function()
  vim.cmd 'vsplit'
end

M.copy_left = function()
  vim.cmd 'leftabove vsplit'
end

M.new_tab = function()
  vim.cmd 'tabnew'
end

M.new_up = function()
  vim.cmd 'leftabove new'
end

M.new_down = function()
  vim.cmd 'new'
end

M.new_right = function()
  vim.cmd 'vnew'
end

M.new_left = function()
  vim.cmd 'leftabove vnew'
end

return M
