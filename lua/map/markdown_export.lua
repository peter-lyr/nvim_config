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

vim.keymap.set({ 'n', 'v', }, '<leader>mc', function() require 'config.markdown_export'.create() end, M.opt 'create')
vim.keymap.set({ 'n', 'v', }, '<leader>md', function() require 'config.markdown_export'.delete() end, M.opt 'delete')

return M
