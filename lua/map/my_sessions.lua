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

vim.keymap.set({ 'n', 'v', }, '<leader>s<cr>', function() require 'config.my_sessions'.sel() end, M.opt 'sel')
vim.keymap.set({ 'n', 'v', }, '<leader>s<s-cr>', function() require 'config.my_sessions'.sel_recent() end, M.opt 'sel_recent')

B.aucmd(M.source, 'VimLeavePre', { 'VimLeavePre', }, {
  callback = function()
    require('config.my_sessions').save()
  end,
})

require('config.my_sessions').save()

----------------

B.aucmd(M.source, 'DirChanged', 'DirChanged', {
  callback = function()
    require('config.my_sessions').add_opened_projs()
  end,
})

return M
