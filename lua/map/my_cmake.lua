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

vim.keymap.set({ 'n', 'v', }, '<leader>bct', function() require 'config.my_cmake'.to_cmake() end, M.opt 'c or cbps to cmake')
vim.keymap.set({ 'n', 'v', }, '<leader>bcT', function() require 'config.my_cmake'.to_cmake('start') end, M.opt 'c or cbps to cmake start')

return M
