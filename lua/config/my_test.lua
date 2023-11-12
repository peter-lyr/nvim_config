local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

------------------------------
-- useful
------------------------------

function M.map_buf_close(lhs, buf, cmd)
  require 'config.my_test_useful'.map_buf_close(lhs, buf, cmd)
end

function M.map_buf_c_q_close(buf, cmd)
  require 'config.my_test_useful'.map_buf_c_q_close(buf, cmd)
end

function M.execute_output(cmd)
  require 'config.my_test_useful'.execute_output(cmd)
end

function M.type_execute_output()
  require 'config.my_test_useful'.type_execute_output()
end

function M.delete_whichkeys_txt()
  require 'config.my_test_useful'.delete_whichkeys_txt()
end

function M.startuptime(...)
  require 'config.my_test_useful'.startuptime(...)
end

function M.start_new_nvim_qt()
  require 'config.my_test_useful'.start_new_nvim_qt()
end

function M.restart_nvim_qt()
  require 'config.editor_sessions'.save()
  M.start_new_nvim_qt()
  vim.cmd 'qa!'
end

function M.quit_nvim_qt()
  vim.cmd 'qa!'
end

------------------------------

function M.lazy()
  vim.cmd 'Lazy'
end

function M.mason()
  vim.cmd 'Mason'
end

------------------------------

function M.terminal_cmd()
  vim.cmd 'split'
  vim.cmd 'terminal'
end

function M.terminal_ipython()
  vim.cmd 'split'
  vim.cmd 'terminal ipython'
end

function M.terminal_bash()
  vim.cmd 'split'
  vim.cmd 'terminal bash'
end

function M.terminal_powershell()
  vim.cmd 'split'
  vim.cmd 'terminal powershell'
end

function M.terminal_outside_cmd()
  vim.fn.system 'start cmd'
end

function M.terminal_outside_ipython()
  vim.fn.system 'start ipython'
end

function M.terminal_outside_bash()
  vim.fn.system 'start bash'
end

function M.terminal_outside_powershell()
  vim.fn.system 'start powershell'
end

-----

function M.asyncrun()
  B.load_require 'skywind3000/asyncrun.vim'
  vim.cmd [[call feedkeys(":\<c-u>AsyncRun ")]]
end

function M.asyncstop()
  B.load_require 'skywind3000/asyncrun.vim'
  vim.cmd 'AsyncStop'
end

------------------------------

function M.source_lua()
  require 'config.my_test_useful'.source_lua()
end

------------------------------

function M.open_stdpath_temp()
  B.system_run('start', 'explorer %s', vim.fn.stdpath 'cache')
end

function M.open_stdpath_config()
  B.system_run('start', 'explorer %s', vim.fn.stdpath 'config')
end

------

function M.git_clone()
  require 'config.my_test_useful'.git_clone()
end

return M
