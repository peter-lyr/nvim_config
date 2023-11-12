local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require('config.editor_statuscol')

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<c-f5>', function() require 'config.editor_statuscol'.init() end, M.opt 'init')

B.aucmd('config.editor_statuscol', 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.o.statuscolumn ~= '%!v:lua.StatusCol()' then
      if #ev.file > 0 and B.file_exists(ev.file) then
        require('config.editor_statuscol').init()
      end
    end
  end,
})

return M
