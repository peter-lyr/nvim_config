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

B.map('<a-t>1', 'execute_output', { 'mes', })
B.map('<a-t>2', 'execute_output', { 'scriptnames', })
B.map('<a-t>3', 'execute_output', { '!dir', })
B.map('<a-t>4', 'execute_output', { 'set rtp', })
B.map('<a-t>5', 'execute_output', { 'ls!', })

-------

B.map('<a-t><del>', 'delete_whichkeys_txt', {})
B.map('<a-t><f4>', 'startuptime', {})
B.map('<a-t><s-f4>', 'startuptime', { '--no-sort', })
B.map('<a-t>s', 'start_new_nvim_qt', {})
B.map('<a-t>r', 'restart_nvim_qt', {})
B.map('<a-t>q', 'quit_nvim_qt', {})

-------

B.map('<a-t><c-f1>', 'terminal_cmd', {})
B.map('<a-t><c-f2>', 'terminal_ipython', {})
B.map('<a-t><c-f3>', 'terminal_bash', {})
B.map('<a-t><c-f4>', 'terminal_powershell', {})

B.map('<a-t><s-f1>', 'terminal_outside_cmd', {})
B.map('<a-t><s-f2>', 'terminal_outside_ipython', {})
B.map('<a-t><s-f3>', 'terminal_outside_bash', {})
B.map('<a-t><s-f4>', 'terminal_outside_powershell', {})

-------

B.map('<a-t>;', 'asyncrun', {})
B.map('<a-t><c-del>', 'asyncstop', {})

-------

B.map('<a-t>l', 'lazy', {})
B.map('<a-t>m', 'mason', {})

-------

B.map('<a-t><f3>', 'source_lua', {})

--------

B.map('<a-t>gc', 'git_clone', {})

--------

B.map('<a-t>ot', 'open_stdpath_temp', {})
B.map('<a-t>oc', 'open_stdpath_config', {})

------

B.map_set_opts { silent = false, }

B.map('<a-t>t', 'type_execute_output', {})

B.map_reset_opts()

B.register_whichkey('<a-t>o', 'open')

B.merge_whichkeys()

return M
