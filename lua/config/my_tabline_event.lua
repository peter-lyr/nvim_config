local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

vim.cmd [[
  hi tblsel guifg=#e6646e guibg=NONE gui=bold
  hi tbltab guifg=#64e66e guibg=NONE gui=bold
  hi tblfil guifg=gray
]]

M.light = require 'nvim-web-devicons.icons-default'.icons_by_file_extension

M.color_table = {
  ['0'] = 'f',
  ['1'] = 'e',
  ['2'] = 'd',
  ['3'] = 'c',
  ['4'] = 'b',
  ['5'] = 'a',
  ['6'] = '9',
  ['7'] = '8',
  ['8'] = '7',
  ['9'] = '6',
  ['a'] = '5',
  ['b'] = '4',
  ['c'] = '3',
  ['d'] = '2',
  ['e'] = '1',
  ['f'] = '0',
}

function M.reverse_color(color)
  local new = '#'
  for i in string.gmatch(color, '%w') do
    new = new .. M.color_table[i]
  end
  return new
end


function M.hi()
  for _, v in pairs(M.light) do
    if '' ~= v['icon'] then
      B.cmd('hi tbl%s guifg=%s guibg=%s gui=bold', v['name'], M.reverse_color(vim.fn.tolower(v['color'])), v['color'])
    end
  end
end

M.hi()

---------------------

vim.cmd [[
  function! SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchBuffer(a:bufnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchTab(a:tabnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchTabNext(tabnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchTabNext(a:tabnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchWindow(a:win_number, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchNone(win_number, mouseclicks, mousebutton, modifiers)
  endfunction
]]

function SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
  local C = require 'config.my_tabline'
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    vim.cmd('Bdelete! ' .. bufnr)
    C.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) ~= 0 then
      vim.cmd('b' .. bufnr)
      C.update_bufs_and_refresh_tabline()
    end
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

function SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
  local C = require 'config.my_tabline'
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
    C.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    vim.cmd(tabnr .. 'tabnext')
    pcall(vim.call, 'ProjectRootCD')
    C.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

function SwitchTabNext(tabnr, mouseclicks, mousebutton, modifiers)
  local C = require 'config.my_tabline'
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
    C.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    local max_tabnr = vim.fn.tabpagenr '$'
    if tabnr < max_tabnr then
      tabnr = tabnr + 1
    else
      tabnr = 1
    end
    vim.cmd(tabnr .. 'tabnext')
    pcall(vim.call, 'ProjectRootCD')
    C.update_bufs_and_refresh_tabline()
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

-- function SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
--   if mousebutton == 'm' and mouseclicks == 1 then
--   elseif mousebutton == 'l' and mouseclicks == 1 then
--   elseif mousebutton == 'r' and mouseclicks == 1 then
--   end
-- end

---------------------

function M.is_buf_to_show(buf)
  local file = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
  if #file == 0 then
    return false
  end
  if not require 'plenary.path'.new(file):exists() then
    return false
  end
  if vim.fn.buflisted(buf) == 0 then
    return false
  end
  if vim.api.nvim_buf_get_option(buf, 'buftype') == 'quickfix' then
    return false
  end
  return true
end

function M.update_bufs()
  local C = require 'config.my_tabline'
  local cur_proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(C.cur_buf)))
  if not B.is(M.is_buf_to_show(C.cur_buf)) then
    C.cur_proj = cur_proj
    return
  end
  local proj_bufs = {}
  local proj_buf = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local file = B.rep_slash_lower(vim.api.nvim_buf_get_name(buf))
    if B.is(M.is_buf_to_show(buf)) then
      local proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](file))
      if vim.tbl_contains(vim.tbl_keys(proj_bufs), proj) == false then
        proj_bufs[proj] = {}
      end
      proj_bufs[proj][#proj_bufs[proj] + 1] = buf
      proj_buf[proj] = buf
    end
  end
  if B.is(proj_bufs) and B.is(proj_buf) then
    C.proj_bufs = proj_bufs
    C.proj_buf = proj_buf
    C.cur_proj = cur_proj
  end
end

--------------

function M.get_buf_to_show(bufs, cur_buf, tab_len)
  local index = B.index_of(bufs, cur_buf)
  if index == -1 then
    return {}
  end
  local columns = vim.opt.columns:get()
  local buf_len = columns - tab_len
  local newbufnrs = { bufs[index], }
  local ll = #tostring(cur_buf)
  local ss = vim.fn.strdisplaywidth(tostring(#bufs))
  buf_len = buf_len - vim.fn.strdisplaywidth(B.get_only_name(vim.fn.bufname(cur_buf))) - 4 - ll - ss
  if buf_len < 0 then
    return newbufnrs
  end
  local cnt1 = 1
  local cnt2 = 1
  for i = 2, #bufs do
    if i % 2 == 0 then
      local ii = index + cnt1
      if ii > #bufs then
        ii = index - cnt2
        local only_name = B.get_only_name(vim.fn.bufname(bufs[ii]))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 3
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, 1, bufs[ii])
        cnt2 = cnt2 + 1
      else
        local only_name = B.get_only_name(vim.fn.bufname(bufs[ii]))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 3
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, bufs[ii])
        cnt1 = cnt1 + 1
      end
    else
      local ii = index - cnt2
      if ii < 1 then
        ii = index + cnt1
        local only_name = B.get_only_name(vim.fn.bufname(bufs[ii]))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 3
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, bufs[ii])
        cnt1 = cnt1 + 1
      else
        local only_name = B.get_only_name(vim.fn.bufname(bufs[ii]))
        buf_len = buf_len - vim.fn.strdisplaywidth(only_name) - 3
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, 1, bufs[ii])
        cnt2 = cnt2 + 1
      end
    end
  end
  if #newbufnrs == 2 then
    if newbufnrs[1] == cur_buf and B.index_of(bufs, cur_buf) ~= 1 then
      table.insert(newbufnrs, 1, bufs[index - 1])
    end
  end
  return newbufnrs
end

M.get_root_short = function(projectroot)
  local temp__ = vim.fn.tolower(vim.fn.fnamemodify(projectroot, ':t'))
  if #temp__ >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(temp__, #temp__ - i, #temp__)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(temp__, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  local updir = vim.fn.tolower(vim.fn.fnamemodify(projectroot, ':h:t'))
  if #updir >= 15 then
    local s1 = ''
    local s2 = ''
    for i = 15, 3, -1 do
      s2 = string.sub(updir, #updir - i, #updir)
      if vim.fn.strdisplaywidth(s2) <= 7 then
        break
      end
    end
    for i = 15, 3, -1 do
      s1 = string.sub(updir, 1, i)
      if vim.fn.strdisplaywidth(s1) <= 7 then
        break
      end
    end
    return s1 .. '…' .. s2
  end
  return updir .. '\\' .. temp__
end

function M.one_tab()
  local tabs = ''
  local tab_len = 0
  local curtab = vim.fn.tabpagenr()
  local tabs_prefix = '%#tbltab#%' .. tostring(curtab) .. '@SwitchTabNext@'
  if vim.fn.tabpagenr '$' == 1 then
    tabs = tabs_prefix .. string.format(' %s ', vim.loop.cwd())
  else
    tabs = tabs_prefix .. string.format(' %d/%d %s ', curtab, vim.fn.tabpagenr '$', vim.loop.cwd())
  end
  tab_len = vim.fn.strdisplaywidth(tabs_prefix)
  return tabs, tab_len
end

-- 1. only cur tab
-- 2. multi tabs
M.tabs_way = 2

function M.get_tab_to_show()
  if M.tabs_way == 1 then
    return M.one_tab()
  elseif M.tabs_way == 2 then
    if vim.fn.tabpagenr '$' == 1 then
      return M.one_tab()
    else
      local tabs = ''
      local tab_len = 0
      local projs = {}
      local cur_tabnr = vim.fn.tabpagenr()
      local tab_max = vim.fn.tabpagenr '$'
      for tabnr = 1, tab_max do
        local proj = ''
        local temp_file = ''
        for _, bufnr in ipairs(vim.fn.tabpagebuflist(tabnr)) do
          temp_file = vim.api.nvim_buf_get_name(bufnr)
          local temp_proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](temp_file))
          if temp_proj ~= '.' and vim.fn.isdirectory(temp_proj) == 1 and vim.tbl_contains(projs, temp_proj) == false then
            projs[#projs + 1] = temp_proj
            proj = temp_proj
            break
          end
        end
        if #proj == 0 then
          proj = temp_file
        end
        if cur_tabnr == tabnr then
          tabs = tabs .. '%#tbltab#%'
        else
          tabs = tabs .. '%#tblfil#%'
        end
        tabs = tabs .. tostring(tabnr) .. '@SwitchTab@'
        local temp = ''
        if cur_tabnr == tabnr then
          temp = string.format(' %d/%d %s ', tabnr, tab_max, M.get_root_short(proj))
        else
          temp = string.format(' %d %s ', tabnr, M.get_root_short(proj))
        end
        tab_len = tab_len + vim.fn.strdisplaywidth(temp)
        tabs = tabs .. temp
      end
      return tabs, tab_len
    end
  end
end

function M.get_buf_content(tab_len)
  local C = require 'config.my_tabline'
  local bufs = {}
  local bufs_to_show = {}
  local buf_index_cur = 1
  if C.proj_bufs[C.cur_proj] then
    bufs_to_show = M.get_buf_to_show(C.proj_bufs[C.cur_proj], C.cur_buf, tab_len)
    if #bufs_to_show == 0 then
      bufs_to_show = C.proj_bufs[C.cur_proj]
    end
    buf_index_cur = B.index_of(C.proj_bufs[C.cur_proj], bufs_to_show[1])
  end
  for index, buf in ipairs(bufs_to_show) do
    local only_name = B.get_only_name(vim.fn.bufname(buf))
    local name = only_name
    local hiname = 'tblsel'
    local only_name_no_ext = vim.fn.fnamemodify(only_name, ':r')
    local ext = string.match(only_name, '%.([^.]+)$')
    if vim.tbl_contains(vim.tbl_keys(M.light), ext) == true and M.light[ext]['icon'] ~= '' then
      name = only_name_no_ext .. ' ' .. M.light[ext]['icon']
      hiname = 'tbl' .. M.light[ext]['name']
    end
    if C.cur_buf == buf then
      bufs[#bufs + 1] = string.format('%%#%s#%%%d@SwitchBuffer@ %d/%d %s ', hiname, buf, buf_index_cur + index - 1, #C.proj_bufs[C.cur_proj], name)
    else
      bufs[#bufs + 1] = string.format('%%#tblfil#%%%d@SwitchBuffer@ %d %s ', buf, buf_index_cur + index - 1, name)
    end
  end
  return vim.fn.join(bufs, '')
end

function M.refresh_tabline()
  local tabs_to_show, tab_len = M.get_tab_to_show()
  vim.opt.tabline = M.get_buf_content(tab_len) .. '%#tblfil#%1@SwitchNone@%=%<%#tblfil#' .. tabs_to_show
end

function M.toggle_tabs_way()
  M.tabs_way = M.tabs_way + 1
  if M.tabs_way > 2 then
    M.tabs_way = 1
  end
  if M.tabs_way == 1 then
    B.notify_info 'only cur tab'
  elseif M.tabs_way == 2 then
    B.notify_info 'multi tabs'
  end
  local C = require 'config.my_tabline'
  C.update_bufs_and_refresh_tabline()
end

return M
