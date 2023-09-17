require 'maps'.add('<F5>', 'n', function()
  pcall(vim.call, 'fugitive#ReloadStatus')
end, 'futigive status fresh')

local M = {}

M.toggle = function()
  if vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype') == 'fugitive' then
    vim.cmd 'close'
  else
    vim.cmd 'Git'
  end
end

return M
