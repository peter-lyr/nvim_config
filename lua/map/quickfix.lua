local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map('d<leader>', 'toggle', {})

------------

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require(M.config).au_height()
    require(M.config).map(ev)
  end,
})

B.aucmd(M.source, 'ColorScheme', { 'ColorScheme', }, {
  callback = function()
    require(M.config).hi()
  end,
})

return M
