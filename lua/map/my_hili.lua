local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.aucmd(M.lua, 'CursorHold', { 'CursorHold', 'CursorHoldI', }, {
  callback = function(ev)
    require('config.my_hili').on_cursorhold(ev)
  end,
})

B.aucmd(M.lua, 'ColorScheme', { 'ColorScheme', }, {
  callback = function()
    require('config.my_hili').on_colorscheme()
  end,
})

return M
