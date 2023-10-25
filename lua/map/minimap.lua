local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require_common()

B.map('<leader>am', M.config, 'open', {})
B.map('<leader>aM', M.config, 'close', {})
B.map('<leader>an', M.config, 'toggle_focus', {})
B.map('<leader>aN', M.config, 'auto_open', {})

return M
