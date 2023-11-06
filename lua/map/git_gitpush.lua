local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

-------

B.map('ga', 'addcommitpush', {})
B.map('<leader>gc', 'commit_push', {})
B.map('<leader>ggc', 'commit', {})
B.map('<leader>ggs', 'push', {})
B.map('<leader>ggg', 'graph', {})
B.map('<leader>ggv', 'init', {})
B.map('<leader>ggf', 'pull', {})
B.map('<leader>gga', 'addall', {})
B.map('<leader>ggr', 'reset_hard', {})
B.map('<leader>ggd', 'reset_hard_clean', {})
B.map('<leader>ggC', 'clone', {})

return M
