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

vim.keymap.set({ 'n', 'v', }, '<leader>bcmm', function() require 'config.my_make'.make() end, M.opt 'make')
vim.keymap.set({ 'n', 'v', }, '<leader>bcmM', function() require 'config.my_make'.make 'start' end, M.opt 'make start')
vim.keymap.set({ 'n', 'v', }, '<leader>bcmr', function() require 'config.my_make'.make_run() end, M.opt 'make run')
vim.keymap.set({ 'n', 'v', }, '<leader>bcmR', function() require 'config.my_make'.make_run 'start' end, M.opt 'make run start')

vim.keymap.set({ 'n', 'v', }, '<leader>bcrmm', function() require 'config.my_make'.remake() end, M.opt 'remake')
vim.keymap.set({ 'n', 'v', }, '<leader>bcrmM', function() require 'config.my_make'.remake 'start' end, M.opt 'remake start')
vim.keymap.set({ 'n', 'v', }, '<leader>bcrmr', function() require 'config.my_make'.remake_run() end, M.opt 'remake run')
vim.keymap.set({ 'n', 'v', }, '<leader>bcrmR', function() require 'config.my_make'.remake_run 'start' end, M.opt 'remake run start')

vim.keymap.set({ 'n', 'v', }, '<leader>bcrr', function() require 'config.my_make'.run() end, M.opt 'run')
vim.keymap.set({ 'n', 'v', }, '<leader>bcrR', function() require 'config.my_make'.run 'start' end, M.opt 'run start')

vim.keymap.set({ 'n', 'v', }, '<leader>bcc', function() require 'config.my_make'.clean() end, M.opt 'clean')

vim.keymap.set({ 'n', 'v', }, '<leader>bcg', function() require 'config.my_make'.gcc() end, M.opt 'gcc')

B.register_whichkey('config.my_make', '<leader>bc', 'c/c++ build')
B.register_whichkey('config.my_make', '<leader>bcm', 'make')
B.register_whichkey('config.my_make', '<leader>bcr', 'remake/run')
B.register_whichkey('config.my_make', '<leader>bcrm', 'remake')
B.merge_whichkeys()

return M
