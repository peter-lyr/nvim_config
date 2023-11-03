local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.is_cuf_buf_readable()
  if vim.fn.filewritable(vim.api.nvim_buf_get_name(0)) == 1 then
    return 1
  end
  return nil
end

function M.b_prev_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  local C = require 'config.my_tabline'
  if C.proj_bufs[C.cur_proj] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf) - 1
    end
    if index < 1 then
      index = #C.proj_bufs[C.cur_proj]
    end
    local buf = C.proj_bufs[C.cur_proj][index]
    if buf then
      B.cmd('b%d', buf)
    end
    C.update_bufs_and_refresh_tabline()
  end
end

function M.b_next_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  local C = require 'config.my_tabline'
  if C.proj_bufs[C.cur_proj] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf) + 1
    end
    if index > #C.proj_bufs[C.cur_proj] then
      index = 1
    end
    local buf = C.proj_bufs[C.cur_proj][index]
    if buf then
      B.cmd('b%d', buf)
    end
    C.update_bufs_and_refresh_tabline()
  end
end

function M.bd_prev_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  local C = require 'config.my_tabline'
  if #C.proj_bufs[C.cur_proj] > 0 then
    local index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf)
    if index <= 1 then
      return
    end
    index = index - 1
    local buf = C.proj_bufs[C.cur_proj][index]
    if buf then
      B.cmd('Bdelete! %d', buf)
    end
    C.update_bufs_and_refresh_tabline()
  end
end

function M.bd_next_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  local C = require 'config.my_tabline'
  if #C.proj_bufs[C.cur_proj] > 0 then
    local index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf)
    if index >= #C.proj_bufs[C.cur_proj] then
      return
    end
    index = index + 1
    local buf = C.proj_bufs[C.cur_proj][index]
    if buf then
      B.cmd('Bdelete! %d', buf)
    end
    C.update_bufs_and_refresh_tabline()
  end
end

-----------

function M.bd_all_next_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  local C = require 'config.my_tabline'
  if #C.proj_bufs[C.cur_proj] > 0 then
    local index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf)
    if index >= #C.proj_bufs[C.cur_proj] then
      return
    end
    index = index + 1
    local bufs = {}
    for i = index, #C.proj_bufs[C.cur_proj] do
      local buf = C.proj_bufs[C.cur_proj][i]
      if buf then
        bufs[#bufs + 1] = buf
      end
    end
    for _, buf in ipairs(bufs) do
      B.cmd('Bdelete! %d', buf)
    end
    C.update_bufs_and_refresh_tabline()
  end
end

function M.bd_all_prev_buf()
  if not M.is_cuf_buf_readable() then
    return
  end
  local C = require 'config.my_tabline'
  if #C.proj_bufs[C.cur_proj] > 0 then
    local index = B.index_of(C.proj_bufs[C.cur_proj], C.cur_buf)
    if index <= 1 then
      return
    end
    index = index - 1
    local bufs = {}
    for i = 1, index do
      local buf = C.proj_bufs[C.cur_proj][i]
      if buf then
        bufs[#bufs + 1] = buf
      end
    end
    for _, buf in ipairs(bufs) do
      B.cmd('Bdelete! %d', buf)
    end
    C.update_bufs_and_refresh_tabline()
  end
end

------------------

function M.only_cur_buffer()
  pcall(vim.cmd, 'tabo')
  pcall(vim.cmd, 'wincmd o')
  pcall(vim.cmd, 'e!')
end

function M.restore_hidden_tabs()
  local C = require 'config.my_tabline'
  pcall(vim.cmd, 'tabo')
  pcall(vim.cmd, 'wincmd o')
  if #vim.tbl_keys(C.proj_bufs) > 1 then
    local temp = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
    for _, project in ipairs(vim.tbl_keys(C.proj_buf)) do
      if project ~= temp and vim.fn.buflisted(C.proj_buf[project]) == 1 then
        vim.cmd 'wincmd v'
        vim.cmd 'wincmd T'
        vim.cmd('b' .. C.proj_buf[project])
      end
    end
    vim.cmd '1tabnext'
  end
end

require 'telescope'.load_extension 'ui-select'

function M.append_one_proj_right_down()
  local C = require 'config.my_tabline'
  if #vim.tbl_keys(C.proj_bufs) > 1 then
    local projs = {}
    local active_projs = {}
    for winnr = 1, vim.fn.winnr '$' do
      local tt = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(vim.fn.winbufnr(winnr))))
      if vim.tbl_contains(active_projs, tt) == false then
        active_projs[#active_projs + 1] = tt
      end
    end
    for _, project in ipairs(vim.tbl_keys(C.proj_buf)) do
      if vim.tbl_contains(active_projs, project) == false and vim.fn.buflisted(C.proj_buf[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_right_down', }, function(proj, _)
        if not proj then
          return
        end
        vim.cmd 'wincmd b'
        vim.cmd 'wincmd s'
        vim.cmd('b' .. C.proj_buf[proj])
        vim.cmd 'e!'
      end)
    else
      print 'no append_one_proj_right_down'
    end
  end
end

function M.open_proj_in_new_tab(proj)
  if not proj then
    return
  end
  vim.cmd 'wincmd s'
  vim.cmd 'wincmd T'
  vim.cmd('b' .. C.proj_buf[proj])
  vim.cmd 'e!'
end

function M.append_one_proj_new_tab()
  local C = require 'config.my_tabline'
  if #vim.tbl_keys(C.proj_bufs) > 1 then
    local projs = {}
    local temp = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
    for _, project in ipairs(vim.tbl_keys(C.proj_buf)) do
      if project ~= temp and vim.fn.buflisted(C.proj_buf[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_new_tab', }, function(proj, idx)
        M.open_proj_in_new_tab(proj)
      end)
    else
      print 'no append_one_proj_new_tab'
    end
  end
end

function M.append_one_proj_new_tab_no_dupl()
  local C = require 'config.my_tabline'
  if #vim.tbl_keys(C.proj_bufs) > 1 then
    local projs = {}
    local active_projs = {}
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      local tt = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(vim.fn.winbufnr(winid))))
      if vim.tbl_contains(active_projs, tt) == false then
        active_projs[#active_projs + 1] = tt
      end
    end
    for _, project in ipairs(vim.tbl_keys(C.proj_buf)) do
      if vim.tbl_contains(active_projs, project) == false and vim.fn.buflisted(C.proj_buf[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_new_tab_no_dupl', }, function(proj, _)
        M.open_proj_in_new_tab(proj)
      end)
    else
      print 'no append_one_proj_new_tab_no_dupl'
    end
  end
end

function M.simple_statusline_toggle()
  local C = require 'config.my_tabline'
  if C.simple_statusline then
    C.simple_statusline = nil
    vim.opt.showtabline = 2
    vim.opt.laststatus  = 3
    vim.opt.winbar      = ''
    vim.opt.statusline  = [[%f %h%m%r%=%<%-14.(%l,%c%V%) %P]]
  else
    C.simple_statusline = 1
    vim.opt.showtabline = 0
    vim.opt.laststatus  = 2
    vim.opt.winbar      = '%f'
    vim.opt.statusline  = '%{getcwd()}'
  end
end

return M
