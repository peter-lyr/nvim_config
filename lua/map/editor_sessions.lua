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

vim.keymap.set({ 'n', 'v', }, '<leader>s-', function() require 'config.editor_sessions'.load() end, M.opt 'load')
vim.keymap.set({ 'n', 'v', }, '<leader>s+', function() require 'config.editor_sessions'.save() end, M.opt 'save')

return M
