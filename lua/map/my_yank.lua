local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map('<leader>yf', 'file', {})
B.map('<leader>yt', 'file_tail', {})
B.map('<leader>yh', 'file_head', {})

B.map('<leader>yw', 'cwd', {})

B.map('<leader>yb', 'bufname', {})
B.map('<leader>yB', 'bufname_head', {})

return M
