local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

-------

vim.keymap.set({ 'n', 'v', }, '<a-t>1', function() require 'config.my_test'.execute_output 'mes' end, M.opt 'execute_output mes')
vim.keymap.set({ 'n', 'v', }, '<a-t>2', function() require 'config.my_test'.execute_output 'scriptnames' end, M.opt 'execute_output scriptnames')
vim.keymap.set({ 'n', 'v', }, '<a-t>3', function() require 'config.my_test'.execute_output '!dir' end, M.opt 'execute_output !dir')
vim.keymap.set({ 'n', 'v', }, '<a-t>4', function() require 'config.my_test'.execute_output 'set rtp' end, M.opt 'execute_output set rtp')
vim.keymap.set({ 'n', 'v', }, '<a-t>5', function() require 'config.my_test'.execute_output 'ls!' end, M.opt 'execute_output ls!')

-------

vim.keymap.set({ 'n', 'v', }, '<a-t><del>', function() require 'config.my_test'.delete_whichkeys_txt() end, M.opt 'delete_whichkeys_txt')
vim.keymap.set({ 'n', 'v', }, '<a-t><f5>', function() require 'config.my_test'.startuptime() end, M.opt 'startuptime')
vim.keymap.set({ 'n', 'v', }, '<a-t><s-f5>', function() require 'config.my_test'.startuptime '--no-sort' end, M.opt 'startuptime --no-sort')
vim.keymap.set({ 'n', 'v', }, '<a-t>s', function() require 'config.my_test'.start_new_nvim_qt() end, M.opt 'start_new_nvim_qt')
vim.keymap.set({ 'n', 'v', }, '<a-t>r', function() require 'config.my_test'.restart_nvim_qt() end, M.opt 'restart_nvim_qt')
vim.keymap.set({ 'n', 'v', }, '<a-t>q', function() require 'config.my_test'.quit_nvim_qt() end, M.opt 'quit_nvim_qt')

-------

vim.keymap.set({ 'n', 'v', }, '<a-t><c-f1>', function() require 'config.my_test'.terminal_cmd() end, M.opt 'terminal_cmd')
vim.keymap.set({ 'n', 'v', }, '<a-t><c-f2>', function() require 'config.my_test'.terminal_ipython() end, M.opt 'terminal_ipython')
vim.keymap.set({ 'n', 'v', }, '<a-t><c-f3>', function() require 'config.my_test'.terminal_bash() end, M.opt 'terminal_bash')
vim.keymap.set({ 'n', 'v', }, '<a-t><c-f4>', function() require 'config.my_test'.terminal_powershell() end, M.opt 'terminal_powershell')

vim.keymap.set({ 'n', 'v', }, '<a-t><s-f1>', function() require 'config.my_test'.terminal_outside_cmd() end, M.opt 'terminal_outside_cmd')
vim.keymap.set({ 'n', 'v', }, '<a-t><s-f2>', function() require 'config.my_test'.terminal_outside_ipython() end, M.opt 'terminal_outside_ipython')
vim.keymap.set({ 'n', 'v', }, '<a-t><s-f3>', function() require 'config.my_test'.terminal_outside_bash() end, M.opt 'terminal_outside_bash')
vim.keymap.set({ 'n', 'v', }, '<a-t><s-f4>', function() require 'config.my_test'.terminal_outside_powershell() end, M.opt 'terminal_outside_powershell')

-------

vim.keymap.set({ 'n', 'v', }, '<a-t>;', function() require 'config.my_test'.asyncrun() end, M.opt 'asyncrun')
vim.keymap.set({ 'n', 'v', }, '<a-t><c-del>', function() require 'config.my_test'.asyncstop() end, M.opt 'asyncstop')

-------

vim.keymap.set({ 'n', 'v', }, '<a-t>l', function() require 'config.my_test'.lazy() end, M.opt 'lazy')
vim.keymap.set({ 'n', 'v', }, '<a-t>m', function() require 'config.my_test'.mason() end, M.opt 'mason')

-------

vim.keymap.set({ 'n', 'v', }, '<a-t><f3>', function() require 'config.my_test'.source_lua() end, M.opt 'source_lua')

--------

vim.keymap.set({ 'n', 'v', }, '<a-t>gc', function() require 'config.my_test'.git_clone() end, M.opt 'git_clone')

--------

vim.keymap.set({ 'n', 'v', }, '<a-t>ot', function() require 'config.my_test'.open_stdpath_temp() end, M.opt 'open_stdpath_temp')
vim.keymap.set({ 'n', 'v', }, '<a-t>oc', function() require 'config.my_test'.open_stdpath_config() end, M.opt 'open_stdpath_config')

------

vim.keymap.set({ 'n', 'v', }, '<a-t>t', function() require 'config.my_test'.type_execute_output() end, M.opt 'type_execute_output')

B.register_whichkey('config.my_test', '<a-t>o', 'open')
B.register_whichkey('config.my_test', '<a-t>g', 'git')
B.merge_whichkeys()

----------------------------

B.load_require 'dstein64/vim-startuptime'

return M
