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

B.map('<leader><f4>1', 'execute_output', { 'mes', })
B.map('<leader><f4>2', 'execute_output', { 'scriptnames', })
B.map('<leader><f4>3', 'execute_output', { '!dir', })
B.map('<leader><f4>4', 'execute_output', { 'set rtp', })
B.map('<leader><f4>5', 'execute_output', { 'ls!', })

-------

B.map('<leader><f4><del>', 'delete_whichkeys_txt', {})
B.map('<leader><f4><f4>', 'startuptime', {})
B.map('<leader><f4><s-f4>', 'startuptime', { '--no-sort', })
B.map('<leader><f4>s', 'start_new_nvim_qt', {})
B.map('<leader><f4>r', 'restart_nvim_qt', {})
B.map('<leader><f4>q', 'quit_nvim_qt', {})

-------

B.map('<leader><f4><c-f1>', 'terminal_cmd', {})
B.map('<leader><f4><c-f2>', 'terminal_ipython', {})
B.map('<leader><f4><c-f3>', 'terminal_bash', {})
B.map('<leader><f4><c-f4>', 'terminal_powershell', {})

B.map('<leader><f4><s-f1>', 'terminal_outside_cmd', {})
B.map('<leader><f4><s-f2>', 'terminal_outside_ipython', {})
B.map('<leader><f4><s-f3>', 'terminal_outside_bash', {})
B.map('<leader><f4><s-f4>', 'terminal_outside_powershell', {})

-------

B.map('<leader><f4>;', 'asyncrun', {})
B.map('<leader><f4><c-del>', 'asyncstop', {})

-------

B.map('<leader><f4>l', 'lazy', {})
B.map('<leader><f4>m', 'mason', {})

-------

B.map('<leader><f4><f3>', 'source_lua', {})

--------

B.map('<leader><f4>gc', 'git_clone', {})

--------

B.map('<leader><f4>ot', 'open_stdpath_temp', {})

------

B.map_set_opts { silent = false, }

B.map('<leader><f4>t', 'type_execute_output', {})

B.map_reset_opts()

B.register_whichkey('<leader><f4>o', 'open')

B.merge_whichkeys()

return M
