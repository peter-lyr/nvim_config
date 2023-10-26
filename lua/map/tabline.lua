local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'dbakker/vim-projectroot'
B.load_require 'peter-lyr/vim-bbye'

--------------------

B.map_set_lua(M.config)

B.map('<c-l>', 'b_next_buf', {})
B.map('<c-h>', 'b_prev_buf', {})

B.map('<c-s-l>', 'bd_next_buf', {})
B.map('<c-s-h>', 'bd_prev_buf', {})

B.map_reset_opts()

--------------------

B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    require(M.config).update_bufs_and_refresh_tabline(ev)
  end,
})

--------------------

return M
