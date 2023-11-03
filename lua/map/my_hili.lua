local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

vim.o.updatetime = 10

B.aucmd(M.source, 'CursorHold', { 'CursorHold', 'CursorHoldI', }, {
  callback = function(ev)
    require(M.config).on_cursorhold(ev)
  end,
})

B.aucmd(M.source, 'ColorScheme', { 'ColorScheme', }, {
  callback = function()
    require(M.config).on_colorscheme()
  end,
})

return M
