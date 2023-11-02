local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map('<leader>td', 'diff', {})
B.map('<leader>tw', 'wrap', {})
B.map('<leader>tr', 'renu', {})
B.map('<leader>ts', 'signcolumn', {})
B.map('<leader>tc', 'conceallevel', {})
B.map('<leader>tk', 'iskeyword', {})

return M
