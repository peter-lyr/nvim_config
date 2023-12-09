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

vim.keymap.set({ 'n', 'v', }, '<leader>td', function() require 'config.my_toggle'.diff() end, M.opt 'diff')
vim.keymap.set({ 'n', 'v', }, '<leader>tw', function() require 'config.my_toggle'.wrap() end, M.opt 'wrap')
vim.keymap.set({ 'n', 'v', }, '<leader>tr', function() require 'config.my_toggle'.renu() end, M.opt 'renu')
vim.keymap.set({ 'n', 'v', }, '<leader>ts', function() require 'config.my_toggle'.signcolumn() end, M.opt 'signcolumn')
vim.keymap.set({ 'n', 'v', }, '<leader>tc', function() require 'config.my_toggle'.conceallevel() end, M.opt 'conceallevel')
vim.keymap.set({ 'n', 'v', }, '<leader>tk', function() require 'config.my_toggle'.iskeyword() end, M.opt 'iskeyword')

return M
