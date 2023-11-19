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

vim.keymap.set({ 'n', 'v', }, '<leader><c-b>cm', function() require 'config.my_make'.make() end, M.opt 'make')
vim.keymap.set({ 'n', 'v', }, '<leader><c-b>cM', function() require 'config.my_make'.make 'start' end, M.opt 'make start')
vim.keymap.set({ 'n', 'v', }, '<leader><c-b>cc', function() require 'config.my_make'.clean() end, M.opt 'clean')
vim.keymap.set({ 'n', 'v', }, '<leader><c-b>cr', function() require 'config.my_make'.run() end, M.opt 'run')
vim.keymap.set({ 'n', 'v', }, '<leader><c-b>cR', function() require 'config.my_make'.run 'start' end, M.opt 'run start')
vim.keymap.set({ 'n', 'v', }, '<leader><c-b>cg', function() require 'config.my_make'.gcc() end, M.opt 'gcc')

B.register_whichkey('config.my_make', '<leader><c-b>c', 'c/c++ build')
B.merge_whichkeys()

return M
