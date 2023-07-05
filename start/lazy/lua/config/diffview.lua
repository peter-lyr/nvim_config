require("diffview").setup()

local M = {}

M.diffviewfilehistory = function()
  vim.cmd('DiffviewFileHistory')
end

M.diffviewopen = function()
  vim.cmd('DiffviewOpen -u')
end

M.diffviewclose = function()
  if vim.fn.bufnr('-MINIMAP-') ~= -1 then
    vim.cmd('MinimapClose')
  end
  vim.cmd('DiffviewClose')
end

return M
