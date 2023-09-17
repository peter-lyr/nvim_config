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

return M
