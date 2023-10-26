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

function M.source_lua()
  B.call_sub(M.loaded, 'useful', 'source_lua')
end

------------------------------

return M
