local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.fn.filereadable(ev.file) == 1 and vim.o.modifiable == true then
      vim.opt.cursorcolumn = true
      vim.opt.signcolumn   = 'auto:1'
    end
  end,
})

return M
