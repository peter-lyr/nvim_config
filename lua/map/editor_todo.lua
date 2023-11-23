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

vim.keymap.set({ 'n', 'v', }, '<leader>tq', function() require 'config.editor_todo'.TodoQuickFix() end, M.opt 'TodoQuickFix')
vim.keymap.set({ 'n', 'v', }, '<leader>tt', function() require 'config.editor_todo'.TodoTelescope() end, M.opt 'TodoTelescope')
vim.keymap.set({ 'n', 'v', }, '<leader>tl', function() require 'config.editor_todo'.TodoLocList() end, M.opt 'TodoLocList')
vim.keymap.set({ 'n', 'v', }, '<leader>te', function() require 'config.editor_todo'.open_todo_exclude_dirs_txt() end, M.opt 'open_todo_exclude_dirs_txt')

return M
