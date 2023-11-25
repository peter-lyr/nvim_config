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

vim.keymap.set({ 'n', 'v', }, 'c<cr>b', function() require 'config.my_cal'.count_bin('<cword>') end, M.opt 'count_bin')
vim.keymap.set({ 'n', 'v', }, 'c<cr><c-b>', function() require 'config.my_cal'.count_bin('<cWORD>') end, M.opt 'count_bin')

return M
