local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

------------------------------
-- useful
------------------------------

function M.map_buf_close(lhs, buf, cmd)
  B.call_sub(M.loaded, 'useful', 'map_buf_close', lhs, buf, cmd)
end

function M.map_buf_c_q_close(buf, cmd)
  B.call_sub(M.loaded, 'useful', 'map_buf_c_q_close', buf, cmd)
end

function M.execute_output(cmd)
  B.call_sub(M.loaded, 'useful', 'execute_output', cmd)
end

function M.type_execute_output()
  B.call_sub(M.loaded, 'useful', 'type_execute_output')
end

function M.delete_whichkeys_txt()
  B.call_sub(M.loaded, 'useful', 'delete_whichkeys_txt')
end

function M.startuptime(...)
  B.call_sub(M.loaded, 'useful', 'startuptime', ...)
end

function M.start_new_nvim_qt()
  B.call_sub(M.loaded, 'useful', 'start_new_nvim_qt')
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
  B.call_sub(M.loaded, 'useful', 'source_lua')
end

------------------------------

function M.open_stdpath_temp()
  B.call_sub(M.loaded, 'useful', 'open_stdpath_temp')
end

------

function M.git_clone()
  B.call_sub(M.loaded, 'useful', 'git_clone')
end

return M
