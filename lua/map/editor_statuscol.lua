local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

require(M.config)

B.aucmd(M.config, 'BufEnter', 'BufEnter', {
  callback = function()
    if vim.o.statuscolumn ~= '%!v:lua.StatusCol()' then
      require(M.config).init()
    end
  end,
})

return M
