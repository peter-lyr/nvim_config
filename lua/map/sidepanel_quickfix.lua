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

vim.keymap.set({ 'n', 'v', }, '<leader>d<leader>', function() require 'config.sidepanel_quickfix'.toggle() end, M.opt 'toggle')

------------

B.aucmd(M.lua, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require('config.sidepanel_quickfix').au_height()
    require('config.sidepanel_quickfix').map(ev)
  end,
})

B.aucmd(M.lua, 'ColorScheme', { 'ColorScheme', }, {
  callback = function()
    require('config.sidepanel_quickfix').hi()
  end,
})

return M
