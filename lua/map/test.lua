local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require_common()

B.load_require 'dstein64/vim-startuptime'

----------------------------

B.map('<c-s-f4>1', M.config, 'execute_output', { 'mes', })
B.map('<c-s-f4>2', M.config, 'execute_output', { 'scriptnames', })
B.map('<c-s-f4>3', M.config, 'execute_output', { '!dir', })
B.map('<c-s-f4>4', M.config, 'execute_output', { 'set rtp', })

B.map('<c-s-f4><del>', M.config, 'delete_whichkeys_txt', {})
B.map('<c-s-f4><f4>', M.config, 'startuptime', {})
B.map('<c-s-f4>s', M.config, 'start_new_nvim_qt', {})
B.map('<c-s-f4>r', M.config, 'restart_nvim_qt', {})
B.map('<c-s-f4>q', M.config, 'quit_nvim_qt', {})

B.map('<c-s-f4><f3>', M.config, 'ttt', { 1, 332, 45, })

B.map_set_opts { silent = false, }

B.map('<c-s-f4>t', M.config, 'type_execute_output', {})

B.map_reset_opts()

return M
