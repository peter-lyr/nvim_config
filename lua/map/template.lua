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

vim.keymap.set({ 'n', 'v', }, '<leader>xx', function() require 'config.telescope'.lsp_document_symbols() end, M.opt 'lsp_document_symbols')

B.register_whichkey('config.telescope', '<leader>x', 'xxx more')
B.merge_whichkeys()

------------------

B.aucmd(M.lua, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require('config.xxx').map(ev)
  end,
})

return M
