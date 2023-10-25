local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require_common()

B.load_require 'dstein64/vim-startuptime'

B.map('<c-s-f4>1', M.config, 'execute_output', { 'mes', })
B.map('<c-s-f4>2', M.config, 'execute_output', { 'scriptnames', })
B.map('<c-s-f4>3', M.config, 'execute_output', { '!dir', })

B.map('<c-s-f4><del>', M.config, 'delete_whichkeys_txt', {})
B.map('<c-s-f4><f4>', M.config, 'startuptime', {})

return M
