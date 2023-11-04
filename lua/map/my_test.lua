local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'dstein64/vim-startuptime'

----------------------------

B.map_set_lua(M.config)

-------

B.map('<c-s-f4>1', 'execute_output', { 'mes', })
B.map('<c-s-f4>2', 'execute_output', { 'scriptnames', })
B.map('<c-s-f4>3', 'execute_output', { '!dir', })
B.map('<c-s-f4>4', 'execute_output', { 'set rtp', })

-------

B.map('<c-s-f4><del>', 'delete_whichkeys_txt', {})
B.map('<c-s-f4><f4>', 'startuptime', {})
B.map('<c-s-f4><s-f4>', 'startuptime', { '--no-sort', })
B.map('<c-s-f4>s', 'start_new_nvim_qt', {})
B.map('<c-s-f4>r', 'restart_nvim_qt', {})
B.map('<c-s-f4>q', 'quit_nvim_qt', {})

-------

B.map('<c-s-f4><c-f1>', 'terminal_cmd', {})
B.map('<c-s-f4><c-f2>', 'terminal_ipython', {})
B.map('<c-s-f4><c-f3>', 'terminal_bash', {})
B.map('<c-s-f4><c-f4>', 'terminal_powershell', {})

-------

B.map('<c-s-f4>;', 'asyncrun', {})

-------

B.map('<c-s-f4>l', 'lazy', {})
B.map('<c-s-f4>m', 'mason', {})

-------

B.map('<c-s-f4><f3>', 'source_lua', {})

B.map_set_opts { silent = false, }

B.map('<c-s-f4>t', 'type_execute_output', {})

--------

B.map('<c-s-f4>gc', 'git_clone', {})

--------

B.map('<c-s-f4>ot', 'open_stdpath_temp', {})

B.map_reset_opts()

B.register_whichkey('<c-s-f4>o', 'open')

B.merge_whichkeys()

return M
