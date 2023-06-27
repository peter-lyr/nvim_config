local M = {}

local p = require('plenary.path')

M.boot_lua_path = p:new(vim.g.boot_lua)
M.nvim_config_path = M.boot_lua_path:parent():parent():parent():parent()

M.nvim_config = function()
  vim.cmd('e ' .. M.nvim_config_path:joinpath('README.md').filename)
end

return M
