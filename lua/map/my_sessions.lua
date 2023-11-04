local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map('<leader>s<cr>', 'sel', {})
B.map('<leader>s<s-cr>', 'sel_recent', {})

B.aucmd(M.source, 'VimLeavePre', { 'VimLeavePre', }, {
  callback = function()
    require(M.config).save()
  end,
})

require(M.config).save()

return M
