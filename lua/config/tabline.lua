local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.proj_bufs = {}
M.proj_buf = {}
M.cur_proj = ''
M.cur_buf = 0

M.b_next_buf = function()
  B.call_sub(M.loaded, 'funcs', 'b_next_buf')
end

M.b_prev_buf = function()
  B.call_sub(M.loaded, 'funcs', 'b_prev_buf')
end

M.bd_next_buf = function()
  B.call_sub(M.loaded, 'funcs', 'bd_next_buf')
end

M.bd_prev_buf = function()
  B.call_sub(M.loaded, 'funcs', 'bd_prev_buf')
end

M.update_bufs = function(ev)
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  local proj_bufs, proj_buf, cur_proj = B.call_sub(M.loaded, 'event', 'update_bufs', M.cur_buf)
  if B.is(proj_bufs) and B.is(proj_buf) then
    M.proj_bufs = proj_bufs
    M.proj_buf = proj_buf
  end
  M.cur_proj = cur_proj
end

M.refresh_tabline = function(ev)
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  B.call_sub(M.loaded, 'event', 'refresh_tabline', M.proj_bufs, M.cur_proj, M.cur_buf)
end

function M.update_bufs_and_refresh_tabline(ev)
  M.update_bufs(ev)
    M.refresh_tabline(ev)
  -- B.set_timeout(20, function()
  -- end)
end

return M
