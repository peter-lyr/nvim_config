local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.aucmd(M.source, 'BufLeave', 'BufLeave', {
  callback = function()
    vim.opt.cursorcolumn = false
  end,
})

B.aucmd(M.source, 'BufLeave-last_buf', { 'BufLeave', }, {
  callback = function(ev)
    vim.g.last_buf = ev.buf
  end,
})

return M
