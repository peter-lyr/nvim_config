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
      Bdelete!
      e!
    catch
    endtry
  ]]
end

function M.bwipeout_cur()
  vim.cmd [[
    try
      Bwipeout!
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

function M.bwipeout_cur_proj()
  local curroot = B.rep_baskslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == B.rep_baskslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    end
  end
  vim.cmd 'e!'
end

function M.bdelete_cur_proj()
  local curroot = B.rep_baskslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if curroot == B.rep_baskslash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(bufnr))) then
      pcall(vim.cmd, 'Bdelete! ' .. tostring(bufnr))
    end
  end
  vim.cmd 'e!'
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
    pcall(vim.cmd, 'Bwipeout! ' .. tostring(bufnr))
    print('Bwipeout! -> ' .. vim.fn.bufname(bufnr))
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
    fname = vim.fn.trim(B.rep_baskslash_lower(fname))
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

------------------

function M.getfontnamesize()
  local fontname
  local fontsize
  for k, v in string.gmatch(vim.g.GuiFont, '(.*:h)(%d+)') do
    fontname, fontsize = k, v
  end
  return fontname, fontsize
end

M.last_font_size_dir_p = require 'plenary.path':new(vim.fn.stdpath 'data'):joinpath 'last-font-size'
M.last_font_size_txt_p = M.last_font_size_dir_p:joinpath 'last-font-size.txt'

if not M.last_font_size_dir_p:exists() then
  vim.fn.mkdir(M.last_font_size_dir_p.filename)
end

if not M.last_font_size_txt_p:exists() then
  M.last_font_size_txt_p:write('9', 'w')
end

M.fontsizenormal = 9
local _, temp = M.getfontnamesize()
M.lastfontsize = temp
if (tonumber(temp) == M.fontsizenormal) == true then
  M.lastfontsize = M.last_font_size_txt_p:read()
end

B.aucmd(M.source, 'VimLeavePre', { 'VimLeavePre', }, {
  callback = function()
    if M.lastfontsize ~= M.fontsizenormal then
      M.last_font_size_txt_p:write(M.lastfontsize, 'w')
    end
  end,
})

function M.fontsize_up()
  local fontname, fontsize = M.getfontnamesize()
  fontsize = fontsize + 1
  M.lastfontsize = fontsize
  if fontsize <= 72 then
    local cmd = 'GuiFont! ' .. fontname .. fontsize
    vim.cmd(cmd)
    B.notify_info(cmd)
  end
end

function M.fontsize_down()
  local fontname, fontsize = M.getfontnamesize()
  fontsize = fontsize - 1
  M.lastfontsize = fontsize
  if fontsize >= 1 then
    local cmd = 'GuiFont! ' .. fontname .. fontsize
    vim.cmd(cmd)
    B.notify_info(cmd)
  end
end

function M.fontsize_normal()
  local fontname, fontsize = M.getfontnamesize()
  if (tonumber(fontsize) == M.fontsizenormal) == true then
    local cmd = 'GuiFont! ' .. fontname .. M.lastfontsize
    vim.cmd(cmd)
    B.notify_info(cmd)
  else
    local cmd = 'GuiFont! ' .. fontname .. M.fontsizenormal
    vim.cmd(cmd)
    B.notify_info(cmd)
  end
end

function M.fontsize_min()
  local fontname, _ = M.getfontnamesize()
  M.lastfontsize = 1
  local cmd = 'GuiFont! ' .. fontname .. 1
  vim.cmd(cmd)
  B.notify_info(cmd)
end

function M.fontsize_frameless()
  if vim.g.GuiWindowFrameless == 0 then
    vim.fn['GuiWindowFrameless'](1)
  else
    vim.fn['GuiWindowFrameless'](0)
  end
end

function M.fontsize_fullscreen()
  if vim.g.GuiWindowFullScreen == 0 then
    vim.fn['GuiWindowFullScreen'](1)
  else
    vim.fn['GuiWindowFullScreen'](0)
  end
end

M.gui_window_frameless_txt = require 'startup'.gui_window_frameless_txt

function M.fontsize_frameless_toggle()
  local f = io.open(M.gui_window_frameless_txt)
  if f then
    if vim.fn.trim(f:read '*a') == '1' then
      vim.fn.writefile({ '0', }, M.gui_window_frameless_txt)
      B.notify_info 'nvim-qt will startup with frame'
    else
      vim.fn.writefile({ '1', }, M.gui_window_frameless_txt)
      B.notify_info 'nvim-qt will startup framelessly'
    end
    f:close()
  else
    vim.fn.writefile({ '0', }, M.gui_window_frameless_txt)
  end
end

function M.leave()
  if vim.fn.trim(vim.fn.join(vim.fn.readfile(require 'startup'.gui_window_frameless_txt), '')) == '1' then
    if vim.fn.exists 'g:GuiLoaded' and vim.g.GuiLoaded == 1 then
      if vim.g.GuiWindowMaximized == 1 then
        vim.fn['GuiWindowMaximized'](0)
      end
      if vim.g.GuiWindowFrameless == 1 then
        vim.fn['GuiWindowFrameless'](0)
        B.set_timeout(10, function()
          vim.fn['GuiWindowFrameless'](0)
        end)
      end
    end
  end
end

return M
