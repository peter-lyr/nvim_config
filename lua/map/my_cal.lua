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

vim.keymap.set({ 'n', 'v', }, 'c<cr>bn', function() require 'config.my_cal'.count_bin '<cword>' end, M.opt 'notify')
vim.keymap.set({ 'n', 'v', }, 'c<cr>b<c-n>', function() require 'config.my_cal'.count_bin('<cword>', 1) end, M.opt 'hex notify')
vim.keymap.set({ 'n', 'v', }, 'c<cr>bp', function() require 'config.my_cal'.count_bin('<cword>', nil, 1) end, M.opt 'append')
vim.keymap.set({ 'n', 'v', }, 'c<cr>b<c-p>', function() require 'config.my_cal'.count_bin('<cword>', 1, 1) end, M.opt 'hex append')

B.register_whichkey('config.my_cal', 'c<cr>b', 'count bin')
B.merge_whichkeys()

return M
