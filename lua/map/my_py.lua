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

vim.keymap.set({ 'n', 'v', }, '<leader><c-b>pr', function() require 'config.my_py'.run() end, M.opt 'py run')
vim.keymap.set({ 'n', 'v', }, '<leader><c-b>pR', function() require 'config.my_py'.run('start') end, M.opt 'py run start')

B.register_whichkey('config.my_make', '<leader><c-b>p', 'python run')
B.merge_whichkeys()

return M
