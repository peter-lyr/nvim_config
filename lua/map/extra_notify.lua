local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require('config.extra_notify')

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<leader>w<cr>', function() require 'config.extra_notify'.sel_go_win() end, M.opt 'sel go win')
vim.keymap.set({ 'n', 'v', }, '<leader>w<c-cr>', function() require 'config.extra_notify'.sel_go_win('last') end, M.opt 'go last win')

return M
