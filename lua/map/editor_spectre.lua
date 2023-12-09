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

vim.keymap.set({ 'n', }, '<leader>rw', function() require 'config.editor_spectre'.open_visual_select_word() end, M.opt 'open_visual_select_word')
vim.keymap.set({ 'v', }, '<leader>rw', function() require 'config.editor_spectre'.open_visual() end, M.opt 'open_visual')

vim.keymap.set({ 'n', 'v', }, '<leader>ro', function() require 'config.editor_spectre'.open() end, M.opt 'open')
vim.keymap.set({ 'n', 'v', }, '<leader>rc', function() require 'config.editor_spectre'.open_file_search() end, M.opt 'open_file_search')

return M
