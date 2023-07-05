local M = {}

local p = require('plenary.path')

M.nvim_config_path = p:new(vim.g.pack_path):joinpath('nvim_config')

M.nvim_config = function()
  vim.cmd('e ' .. M.nvim_config_path:joinpath('README.md').filename)
end

return M
