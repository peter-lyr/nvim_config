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

vim.keymap.set({ 'n', 'v', }, '<leader>m<leader>', function() require 'config.markdown_preview'.start() end, M.opt 'start')
vim.keymap.set({ 'n', 'v', }, '<leader>mm', function() require 'config.markdown_preview'.restart() end, M.opt 'restart')
vim.keymap.set({ 'n', 'v', }, '<leader>mq', function() require 'config.markdown_preview'.stop() end, M.opt 'stop')

return M
