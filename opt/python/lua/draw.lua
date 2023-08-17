local M = {}

local draw_py = require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'python', 'autoload',
  'draw.py').filename

M.draw = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local cmd = 'python ' .. draw_py .. ' "' .. fname .. '" "' .. fname .. '.temp' .. '" y'
  require 'terminal'.send('cmd', cmd, 'show')
end

return M
