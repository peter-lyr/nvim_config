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

vim.keymap.set({ 'n', 'v', }, '<leader>yf', function() require 'config.my_yank'.file() end, M.opt 'file')
vim.keymap.set({ 'n', 'v', }, '<leader>yt', function() require 'config.my_yank'.file_tail() end, M.opt 'file_tail')
vim.keymap.set({ 'n', 'v', }, '<leader>yh', function() require 'config.my_yank'.file_head() end, M.opt 'file_head')

vim.keymap.set({ 'n', 'v', }, '<leader>yw', function() require 'config.my_yank'.cwd() end, M.opt 'cwd')

vim.keymap.set({ 'n', 'v', }, '<leader>yb', function() require 'config.my_yank'.bufname() end, M.opt 'bufname')
vim.keymap.set({ 'n', 'v', }, '<leader>yB', function() require 'config.my_yank'.bufname_head() end, M.opt 'bufname_head')

return M
