local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

require(M.config)

B.map_set_lua(M.config)

B.map('<c-f5>', 'init', {})

B.aucmd(M.config, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    if vim.o.statuscolumn ~= '%!v:lua.StatusCol()' then
      if #ev.file > 0 and B.file_exists(ev.file) then
        require(M.config).init()
      end
    end
  end,
})

return M
