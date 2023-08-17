local M = {}

M.toggle = function()
  if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1 or #vim.api.nvim_buf_get_name(0) == 0 then
    require 'zen-mode'.toggle { window = { width = 1, }, }
  end
end

return M
