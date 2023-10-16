local M = {}

package.loaded['window'] = nil

M.height_more = function()
  vim.cmd '10wincmd >'
end

M.height_less = function()
  vim.cmd '10wincmd <'
end

M.width_more = function()
  vim.cmd '5wincmd +'
end

M.width_less = function()
  vim.cmd '5wincmd -'
end

M.copy_tab = function()
  vim.cmd 'wincmd s'
  vim.cmd 'wincmd T'
end

M.copy_up = function()
  vim.cmd 'leftabove split'
end

M.copy_down = function()
  vim.cmd 'split'
end

M.copy_right = function()
  vim.cmd 'vsplit'
end

M.copy_left = function()
  vim.cmd 'leftabove vsplit'
end

M.new_tab = function()
  vim.cmd 'tabnew'
end

M.new_up = function()
  vim.cmd 'leftabove new'
end

M.new_down = function()
  vim.cmd 'new'
end

M.new_right = function()
  vim.cmd 'vnew'
end

M.new_left = function()
  vim.cmd 'leftabove vnew'
end

local winid1, bufnr1, winid2, bufnr2
local changed = 1

M.change_around = function(dir)
  changed = 0
  winid1 = vim.fn.win_getid()
  bufnr1 = vim.fn.bufnr()
  vim.cmd('wincmd ' .. dir)
  winid2 = vim.fn.win_getid()
  if winid1 ~= winid2 then
    bufnr2 = vim.fn.bufnr()
    vim.cmd('b' .. tostring(bufnr1))
    vim.fn.win_gotoid(winid1)
    vim.cmd 'set nowinfixheight'
    vim.cmd 'set nowinfixwidth'
    vim.cmd('b' .. tostring(bufnr2))
    vim.fn.win_gotoid(winid2)
    vim.cmd 'set nowinfixheight'
    vim.cmd 'set nowinfixwidth'
  end
end

M.change_around_last = function()
  if vim.fn.win_gotoid(winid1) == 1 then
    vim.cmd 'set nowinfixheight'
    vim.cmd 'set nowinfixwidth'
    vim.cmd('b' .. tostring(bufnr1))
    vim.fn.win_gotoid(winid2)
    vim.cmd 'set nowinfixheight'
    vim.cmd 'set nowinfixwidth'
    vim.cmd('b' .. tostring(bufnr2))
    bufnr1, bufnr2 = bufnr2, bufnr1
    changed = 1 - changed
    if changed == 1 then
      vim.fn.win_gotoid(vim.fn.win_getid(vim.fn.bufwinnr(bufnr2)))
      vim.cmd 'set nowinfixheight'
      vim.cmd 'set nowinfixwidth'
    end
  end
end

M.close_win_up = function()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd k'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_win_down = function()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd j'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_win_right = function()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd l'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_win_left = function()
  local winid = vim.fn.win_getid()
  vim.cmd 'wincmd h'
  if winid ~= vim.fn.win_getid() then
    vim.cmd [[
      try
        close
      catch
      endtry
    ]]
    vim.fn.win_gotoid(winid)
  end
end

M.close_cur = function()
  vim.cmd [[
    try
      close!
    catch
    endtry
  ]]
end

M.bdelete_cur = function()
  vim.cmd [[
    try
      bdelete!
      e!
    catch
    endtry
  ]]
end

M.bwipeout_cur = function()
  vim.cmd [[
    try
      bw!
    catch
    endtry
  ]]
end

M.close_cur_tab = function()
  vim.cmd [[
    try
      tabclose!
    catch
    endtry
  ]]
end

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '\\', '/')
  return content
end

M.bwipeout_cur_proj = function()
  local curroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bw! ' .. tostring(bufnr))
    end
  end
end

M.bdelete_cur_proj = function()
  local curroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bdelete! ' .. tostring(bufnr))
    end
  end
end

M.get_deleted_bufnrs = function()
  return vim.tbl_filter(function(bufnr)
    if 1 ~= vim.fn.buflisted(bufnr) then
      local pfname = require 'plenary.path':new(vim.api.nvim_buf_get_name(bufnr))
      if (string.match(pfname.filename, 'diffview://') or pfname:exists()) and not pfname:is_dir() then
        return true
      end
      return false
    end
    return false
  end, vim.api.nvim_list_bufs())
end

M.bwipeout_deleted = function()
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    pcall(vim.cmd, 'bwipeout! ' .. tostring(bufnr))
    print('bwipeout! -> ' .. vim.fn.bufname(bufnr))
  end
end

require 'telescope'.load_extension 'ui-select'

M.reopen_deleted = function()
  local deleted_bufnames = {}
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    deleted_bufnames[#deleted_bufnames + 1] = vim.api.nvim_buf_get_name(bufnr)
  end
  if #deleted_bufnames == 0 then
    return
  end
  vim.ui.select(deleted_bufnames, { prompt = 'reopen deleted buffers', }, function(choice, _)
    if not choice then
      return
    end
    vim.cmd('e ' .. choice)
  end)
end

M.stack_full_fname_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'stack_full_fname'
M.stack_full_fname_txt_p = M.stack_full_fname_dir_p:joinpath 'stack_full_fname.txt'

if not M.stack_full_fname_dir_p:exists() then
  vim.fn.mkdir(M.stack_full_fname_dir_p.filename)
end

if not M.stack_full_fname_txt_p:exists() then
  M.stack_full_fname_txt_p:write('', 'w')
end

M.stack_cur = function()
  local fname = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(fname) == 1 then
    M.stack_full_fname_txt_p:write(fname .. '\n', 'a')
  end
end

M.stack_open_sel = function()
  local temp = M.stack_full_fname_txt_p:readlines()
  local fnames = {}
  for _, fname in ipairs(temp) do
    fname = rep(fname)
    if vim.tbl_contains(fnames, fname) == false then
      fnames[#fnames + 1] = fname
    end
  end
  M.stack_full_fname_txt_p:write(vim.fn.join(fnames, '\n'), 'w')
  if #fname > 0 then
    vim.ui.select(fnames, { prompt = 'stack full fname open', }, function(choice, idx)
      if not choice then
        return
      end
      vim.cmd('e ' .. choice)
    end)
  end
end

M.stack_open_txt = function()
  vim.cmd 'wincmd s'
  vim.cmd('e ' .. M.stack_full_fname_txt_p.filename)
end

M.start_new_nvim_qt = function()
  local start_nvim_qt_exe = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\start-nvim-qt.exe'
  vim.cmd(string.format([[silent !start /b /min cmd /c "%s"]], start_nvim_qt_exe))
end

M.restart_nvim_qt = function()
  M.start_new_nvim_qt()
  vim.cmd 'qa!'
end

return M
