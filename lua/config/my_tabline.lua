local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

M.proj_bufs = {}
M.proj_buf = {}
M.cur_proj = ''
M.cur_buf = 0

M.simple_statusline = nil

----------

function M.b_next_buf()
  require 'config.my_tabline_funcs'.b_next_buf()
end

function M.b_prev_buf()
  require 'config.my_tabline_funcs'.b_prev_buf()
end

function M.bd_next_buf()
  require 'config.my_tabline_funcs'.bd_next_buf()
end

function M.bd_prev_buf()
  require 'config.my_tabline_funcs'.bd_prev_buf()
end

-------

function M.bd_all_next_buf()
  require 'config.my_tabline_funcs'.bd_all_next_buf()
end

function M.bd_all_prev_buf()
  require 'config.my_tabline_funcs'.bd_all_prev_buf()
end

----------

function M.update_bufs(ev)
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  require 'config.my_tabline_event'.update_bufs()
end

function M.refresh_tabline(ev)
  M.cur_buf = ev and ev.buf or vim.fn.bufnr()
  require 'config.my_tabline_event'.refresh_tabline()
end

function M.update_bufs_and_refresh_tabline(ev)
  M.update_bufs(ev)
  M.refresh_tabline(ev)
end

------------------

function M.only_cur_buffer()
  require 'config.my_tabline_funcs'.only_cur_buffer()
end

function M.restore_hidden_tabs()
  require 'config.my_tabline_funcs'.restore_hidden_tabs()
end

function M.append_one_proj_right_down()
  require 'config.my_tabline_funcs'.append_one_proj_right_down()
end

function M.append_one_proj_new_tab()
  require 'config.my_tabline_funcs'.o()
end

function M.append_one_proj_new_tab_no_dupl()
  require 'config.my_tabline_funcs'.append_one_proj_new_tab_no_dupl()
end

function M.append_unload_right_down()
  require 'config.my_tabline_funcs'.append_unload_right_down()
end

function M.simple_statusline_toggle()
  require 'config.my_tabline_funcs'.simple_statusline_toggle()
end

--------------------
-- dbakker/vim-projectroot
--------------------

function M.projectroot_titlestring(ev)
  pcall(vim.call, 'ProjectRootCD')
  local project = B.rep_backslash(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(ev.buf)))
  local head = vim.fn.fnamemodify(project, ':h')
  head = B.get_only_name(head)
  vim.opt.titlestring = string.format('%s %s', B.get_only_name(project), head)
end

function M.toggle_tabs_way()
  return require 'config.my_tabline_event'.toggle_tabs_way()
end

return M
