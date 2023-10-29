local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.map_set_lua(M.config)

B.map('<leader>m<leader>', 'start', {})
B.map('<leader>mm', 'restart', {})
B.map('<leader>mq', 'stop', {})

------

vim.g.mkdp_theme              = 'light'
vim.g.mkdp_auto_close         = 0
vim.g.mkdp_auto_start         = 0
vim.g.mkdp_combine_preview    = 1
vim.g.mkdp_command_for_global = 1

return M
