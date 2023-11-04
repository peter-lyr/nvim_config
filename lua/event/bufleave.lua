local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
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
