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

vim.keymap.set({ 'n', 'v', }, '<leader>bpr', function() require 'config.my_py'.run() end, M.opt 'py run')
vim.keymap.set({ 'n', 'v', }, '<leader>bp<c-r>', function() require 'config.my_py'.run('start') end, M.opt 'py run start')

vim.keymap.set({ 'n', 'v', }, '<leader>bpe', function() require 'config.my_py'.toexe() end, M.opt 'py to exe')
vim.keymap.set({ 'n', 'v', }, '<leader>bp<c-e>', function() require 'config.my_py'.toexe('start') end, M.opt 'py to exe start')

B.register_whichkey('config.my_make', '<leader>bp', 'python run')
B.merge_whichkeys()

return M
