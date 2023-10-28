local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.height_more()
  vim.cmd '10wincmd >'
end

function M.height_less()
  vim.cmd '10wincmd <'
end

function M.width_more()
  vim.cmd '5wincmd +'
end

function M.width_less()
  vim.cmd '5wincmd -'
end

function M.copy_tab()
  vim.cmd 'wincmd s'
  vim.cmd 'wincmd T'
end

function M.copy_up()
  vim.cmd 'leftabove split'
end

function M.copy_down()
  vim.cmd 'split'
end

function M.copy_right()
  vim.cmd 'vsplit'
end

function M.copy_left()
  vim.cmd 'leftabove vsplit'
end

function M.new_tab()
  vim.cmd 'tabnew'
end

function M.new_up()
  vim.cmd 'leftabove new'
end

function M.new_down()
  vim.cmd 'new'
end

function M.new_right()
  vim.cmd 'vnew'
end

function M.new_left()
  vim.cmd 'leftabove vnew'
end

local winid1, bufnr1, winid2, bufnr2
local changed = 1

function M.change_around(dir)
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

function M.change_around_last()
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

function M.close_win_up()
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

function M.close_win_down()
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

function M.close_win_right()
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

function M.close_win_left()
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

function M.close_cur()
  vim.cmd [[
    try
      close!
    catch
    endtry
  ]]
end

function M.bdelete_cur()
  vim.cmd [[
    try
      bdelete!
      e!
    catch
    endtry
  ]]
end

function M.bwipeout_cur()
  vim.cmd [[
    try
      bw!
    catch
    endtry
  ]]
end

function M.close_cur_tab()
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

function M.bwipeout_cur_proj()
  local curroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bw! ' .. tostring(bufnr))
    end
  end
end

function M.bdelete_cur_proj()
  local curroot = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'bdelete! ' .. tostring(bufnr))
    end
  end
end

function M.get_deleted_bufnrs()
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

function M.bwipeout_deleted()
  for _, bufnr in ipairs(M.get_deleted_bufnrs()) do
    pcall(vim.cmd, 'bwipeout! ' .. tostring(bufnr))
    print('bwipeout! -> ' .. vim.fn.bufname(bufnr))
  end
end

require 'telescope'.load_extension 'ui-select'

function M.reopen_deleted()
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

function M.stack_cur()
  local fname = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(fname) == 1 then
    M.stack_full_fname_txt_p:write(fname .. '\n', 'a')
  end
end

function M.stack_open_sel()
  local temp = M.stack_full_fname_txt_p:readlines()
  local fnames = {}
  for _, fname in ipairs(temp) do
    fname = vim.fn.trim(rep(fname))
    if #fname > 0 and vim.tbl_contains(fnames, fname) == false then
      fnames[#fnames + 1] = fname
    end
  end
  M.stack_full_fname_txt_p:write(vim.fn.join(fnames, '\n'), 'w')
  if #fnames > 0 then
    vim.ui.select(fnames, { prompt = 'stack full fname open', }, function(choice, idx)
      if not choice then
        return
      end
      vim.cmd('e ' .. choice)
    end)
  end
end

function M.stack_open_txt()
  vim.cmd 'wincmd s'
  vim.cmd('e ' .. M.stack_full_fname_txt_p.filename)
  B.map_buf_c_q_close()
end

function M.start_new_nvim_qt()
  local start_nvim_qt_exe = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\nvim_config\\start-nvim-qt.exe'
  vim.cmd(string.format([[silent !start /b /min cmd /c "%s"]], start_nvim_qt_exe))
end

function M.restart_nvim_qt()
  M.start_new_nvim_qt()
  vim.cmd 'qa!'
end

return M
