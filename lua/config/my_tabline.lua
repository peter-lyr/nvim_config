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

M.simple_statusline = nil

----------

function M.b_next_buf()
  B.call_sub(M.loaded, 'funcs', 'b_next_buf')
end

function M.b_prev_buf()
  B.call_sub(M.loaded, 'funcs', 'b_prev_buf')
end

function M.bd_next_buf()
  B.call_sub(M.loaded, 'funcs', 'bd_next_buf')
end

function M.bd_prev_buf()
  B.call_sub(M.loaded, 'funcs', 'bd_prev_buf')
end

-------

function M.bd_all_next_buf()
  B.call_sub(M.loaded, 'funcs', 'bd_all_next_buf')
end

function M.bd_all_prev_buf()
  B.call_sub(M.loaded, 'funcs', 'bd_all_prev_buf')
end

----------

function M.update_bufs(ev)
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  B.call_sub(M.loaded, 'event', 'update_bufs')
end

function M.refresh_tabline(ev)
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  B.call_sub(M.loaded, 'event', 'refresh_tabline')
end

function M.update_bufs_and_refresh_tabline(ev)
  M.update_bufs(ev)
  M.refresh_tabline(ev)
end

------------------

function M.only_cur_buffer()
  B.call_sub(M.loaded, 'funcs', 'only_cur_buffer')
end

function M.restore_hidden_tabs()
  B.call_sub(M.loaded, 'funcs', 'restore_hidden_tabs')
end

function M.append_one_proj_right_down()
  B.call_sub(M.loaded, 'funcs', 'append_one_proj_right_down')
end

function M.append_one_proj_new_tab()
  B.call_sub(M.loaded, 'funcs', 'o')
end

function M.append_one_proj_new_tab_no_dupl()
  B.call_sub(M.loaded, 'funcs', 'append_one_proj_new_tab_no_dupl')
end

function M.append_unload_right_down()
  B.call_sub(M.loaded, 'funcs', 'append_unload_right_down')
end

function M.simple_statusline_toggle()
  B.call_sub(M.loaded, 'funcs', 'simple_statusline_toggle')
end

--------------------
-- dbakker/vim-projectroot
--------------------

function M.projectroot_titlestring(ev)
  pcall(vim.call, 'ProjectRootCD')
  local project = B.rep_baskslash(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(ev.buf)))
  local ver = vim.version()
  local head = vim.fn.fnamemodify(project, ':h')
  head = B.get_only_name(head)
  vim.opt.titlestring = string.format('%d %s %s', ver['patch'], B.get_only_name(project), head)
end

function M.toggle_tabs_way()
  return B.call_sub(M.loaded, 'event', 'toggle_tabs_way')
end

return M
