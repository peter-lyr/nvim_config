local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<leader>an', function() require 'config.sidepanel_minimap'.toggle_focus() end, M.opt 'toggle_focus')
vim.keymap.set({ 'n', 'v', }, '<leader>am', function() require 'config.sidepanel_minimap'.open() end, M.opt 'open')
vim.keymap.set({ 'n', 'v', }, '<leader>a,', function() require 'config.sidepanel_minimap'.close() end, M.opt 'close')

return M
