require("diffview").setup()

local M = {}

M.diffviewfilehistory = function()
  vim.cmd('DiffviewFileHistory')
end

M.diffviewopen = function()
  vim.cmd('DiffviewOpen -u')
end

M.diffviewclose = function()
  vim.cmd('DiffviewClose')
end

return M
