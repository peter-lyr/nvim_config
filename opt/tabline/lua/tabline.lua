local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

M.cur_projectroot = ''
M.projects = {}
M.projects_active = {}
M.buf_deleting = nil
M.bufenter_timer = 0
M.bufdelete_timer = 0
M.simple_statusline = nil
M.only_tabs = nil

M.is_buf_to_show = function(bufnr)
  local temp_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(bufnr))
  if #temp_fname == 0 then
    return nil
  end
  if not require 'plenary.path'.new(temp_fname):exists() then
    return nil
  end
  if vim.fn.buflisted(bufnr) == 0 or vim.api.nvim_buf_get_option(bufnr, 'buftype') == 'quickfix' then
    return nil
  end
  return true
end

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
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    vim.cmd('Bdelete! ' .. bufnr)
    M.update_show_bufs()
    M.refresh_tabline()
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) ~= 0 then
      vim.cmd('b' .. bufnr)
      M.refresh_tabline()
    end
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

function SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' then -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
    M.refresh_tabline(1)
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    vim.cmd(tabnr .. 'tabnext')
    pcall(vim.call, 'ProjectRootCD')
    M.refresh_tabline()
  elseif mousebutton == 'r' and mouseclicks == 1 then
    M.refresh_tabline(1)
  end
end

function SwitchTabNext(tabnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' then     -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    local max_tabnr = vim.fn.tabpagenr '$'
    if tabnr < max_tabnr then
      tabnr = tabnr + 1
    else
      tabnr = 1
    end
    vim.cmd(tabnr .. 'tabnext')
    pcall(vim.call, 'ProjectRootCD')
    M.refresh_tabline()
  elseif mousebutton == 'r' and mouseclicks == 1 then
    M.refresh_tabline(1)
  end
end

function SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' and mouseclicks == 1 then
  elseif mousebutton == 'l' and mouseclicks == 1 then
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

M.b_prev_buf = function()
  if M.projects[M.cur_projectroot] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(M.projects[M.cur_projectroot], vim.fn.bufnr()) - 1
    end
    if index < 1 then
      index = #M.projects[M.cur_projectroot]
    end
    vim.cmd(string.format('b%d', M.projects[M.cur_projectroot][index]))
    M.refresh_tabline()
  end
end

M.b_next_buf = function()
  if M.projects[M.cur_projectroot] then
    local index
    if vim.v.count ~= 0 then
      index = vim.v.count
    else
      index = B.index_of(M.projects[M.cur_projectroot], vim.fn.bufnr()) + 1
    end
    if index > #M.projects[M.cur_projectroot] then
      index = 1
    end
    vim.cmd(string.format('b%d', M.projects[M.cur_projectroot][index]))
    M.refresh_tabline()
  end
end

M.bd_prev_buf = function()
  if #M.projects[M.cur_projectroot] > 0 then
    local index = B.index_of(M.projects[M.cur_projectroot], vim.fn.bufnr())
    if index <= 1 then
      return
    end
    index = index - 1
    vim.cmd(string.format('Bdelete! %d', M.projects[M.cur_projectroot][index]))
    M.update_show_bufs()
    M.refresh_tabline()
  end
end

M.bd_next_buf = function()
  if #M.projects[M.cur_projectroot] > 0 then
    local index = B.index_of(M.projects[M.cur_projectroot], vim.fn.bufnr())
    if index >= #M.projects[M.cur_projectroot] then
      return
    end
    index = index + 1
    vim.cmd(string.format('Bdelete! %d', M.projects[M.cur_projectroot][index]))
    M.update_show_bufs()
    M.refresh_tabline()
  end
end

M.get_buf_to_show = function(bufnrs, cur_bufnr)
  local index = B.index_of(bufnrs, cur_bufnr)
  local columns = vim.opt.columns:get()
  local buf_len = columns - #vim.loop.cwd() - 2
  local newbufnrs = { bufnrs[index], }
  buf_len = buf_len - #B.get_only_name(vim.fn.bufname(cur_bufnr)) - 4
  if buf_len < 0 then
    if index >= 2 then
      table.insert(newbufnrs, 1, bufnrs[index - 1])
    end
    if index < #bufnrs then
      table.insert(newbufnrs, bufnrs[index + 1])
    end
    return newbufnrs
  end
  if vim.fn.tabpagenr '$' > 1 then
    buf_len = buf_len - #string.format('%d/%d ', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
  end
  buf_len = buf_len - #tostring(#bufnrs) - 1
  local cnt1 = 1
  local cnt2 = 1
  for i = 2, #bufnrs do
    if i % 2 == 0 then
      local ii = index + cnt1
      if ii > #bufnrs then
        ii = index - cnt2
        local only_name = B.get_only_name(vim.fn.bufname(bufnrs[ii]))
        buf_len = buf_len - #only_name - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, 1, bufnrs[ii])
        cnt2 = cnt2 + 1
      else
        local only_name = B.get_only_name(vim.fn.bufname(bufnrs[ii]))
        buf_len = buf_len - #only_name - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, bufnrs[ii])
        cnt1 = cnt1 + 1
      end
    else
      local ii = index - cnt2
      if ii < 1 then
        ii = index + cnt1
        local only_name = B.get_only_name(vim.fn.bufname(bufnrs[ii]))
        buf_len = buf_len - #only_name - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, bufnrs[ii])
        cnt1 = cnt1 + 1
      else
        local only_name = B.get_only_name(vim.fn.bufname(bufnrs[ii]))
        buf_len = buf_len - #only_name - 4
        if #newbufnrs > 9 then
          buf_len = buf_len - 1
        end
        if buf_len < 0 then
          break
        end
        table.insert(newbufnrs, 1, bufnrs[ii])
        cnt2 = cnt2 + 1
      end
    end
  end
  if #newbufnrs == 2 then
    if newbufnrs[1] == cur_bufnr and B.index_of(bufnrs, cur_bufnr) ~= 1 then
      table.insert(newbufnrs, 1, bufnrs[index - 1])
    end
  end
  return newbufnrs
end

M.get_projectroot = function(projectroot)
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

M.refresh_tabline = function(only_tabs)
  if M.simple_statusline then
    vim.opt.tabline = ''
    return
  end
  local items = {}
  local buf_to_show = {}
  local yy = 1
  local temp = ''
  M.only_tabs = only_tabs
  if not only_tabs then
    if M.projects[M.cur_projectroot] then
      buf_to_show = M.get_buf_to_show(M.projects[M.cur_projectroot], vim.fn.bufnr())
      if #buf_to_show == 0 then
        buf_to_show = M.projects[M.cur_projectroot]
      end
      yy = B.index_of(M.projects[M.cur_projectroot], buf_to_show[1])
    end
    for i, bufnr in ipairs(buf_to_show) do
      local xx = tostring(yy + i - 1)
      local only_name = B.get_only_name(vim.fn.bufname(bufnr))
      local temp_ = ''
      if vim.fn.bufnr() == bufnr then
        temp_ = '%#tblsel#'
        xx = xx .. '/' .. #M.projects[M.cur_projectroot]
      else
        temp_ = '%#tblfil#'
      end
      items[#items + 1] = temp_ .. '%' .. tostring(bufnr) .. '@SwitchBuffer@ ' .. xx .. ' ' .. only_name
    end
    temp = temp .. vim.fn.join(items, ' ') .. ' '
  end
  if only_tabs and vim.fn.tabpagenr '$' > 1 then
    temp = temp .. '%=%#tblfil#'
    local temp_projs = {}
    local curtabpagenr = vim.fn.tabpagenr()
    local tabpagemax = vim.fn.tabpagenr '$'
    for tabpagenr = 1, tabpagemax do
      local name = ''
      local temp_fname = ''
      for _, bufnr in ipairs(vim.fn.tabpagebuflist(tabpagenr)) do
        temp_fname = vim.api.nvim_buf_get_name(bufnr)
        local temp_proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](temp_fname))
        if temp_proj ~= '.' and vim.fn.isdirectory(temp_proj) == 1 and vim.tbl_contains(temp_projs, temp_proj) == false then
          temp_projs[#temp_projs + 1] = temp_proj
          name = temp_proj
          break
        end
      end
      if #name == 0 then
        name = temp_fname
      end
      if curtabpagenr == tabpagenr then
        temp = temp .. '%#tbltab#%'
      else
        temp = temp .. '%#tblfil#%'
      end
      temp = temp .. tostring(tabpagenr) .. '@SwitchTab@ '
      if curtabpagenr == tabpagenr then
        temp = temp .. tostring(tabpagenr) .. '/' .. tostring(tabpagemax) .. ' ' .. M.get_projectroot(name) .. ' '
      else
        temp = temp .. tostring(tabpagenr) .. ' ' .. M.get_projectroot(name) .. ' '
      end
    end
  else
    temp = temp .. '%#tblfil#%1@SwitchNone@%=%<%#tblfil#'
    local ii = ''
    if vim.fn.tabpagenr '$' > 1 then
      ii = string.format('%d/%d ', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
    end
    temp = temp .. '%#tbltab#'
    temp = temp .. '%' .. tostring(vim.fn.tabpagenr()) .. '@SwitchTabNext@ ' .. vim.loop.cwd() .. ' ' .. ii
  end
  vim.opt.tabline = temp
end

M.only_tabs_toggle = function()
  if M.only_tabs then
    M.refresh_tabline(nil)
  else
    M.refresh_tabline(1)
  end
end

vim.cmd [[
  hi tblsel guifg=#e6646e guibg=#555555 gui=bold
  hi tbltab guifg=#64e66e guibg=#666666 gui=bold
  hi tblfil guifg=none
]]

M.update_show_bufs = function()
  M.projects = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local temp_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(bufnr))
    if M.is_buf_to_show(bufnr) then
      local temp_projectroot = B.rep_slash_lower(vim.fn['ProjectRootGet'](temp_fname))
      if vim.tbl_contains(vim.tbl_keys(M.projects), temp_projectroot) == false then
        M.projects[temp_projectroot] = {}
      end
      M.projects[temp_projectroot][#M.projects[temp_projectroot] + 1] = bufnr
      M.projects_active[temp_projectroot] = bufnr
    end
  end
end

B.aucmd(M.source, 'WinEnter', { 'WinEnter', }, {
  callback = function()
    M.update_show_bufs()
    M.refresh_tabline()
  end,
})

B.aucmd(M.source, 'BufEnter', { 'BufEnter', }, {
  callback = function(ev)
    if M.buf_deleting then
      return
    end
    if M.bufenter_timer ~= 0 then
      B.clear_interval(M.bufenter_timer)
    end
    if not M.is_buf_to_show(ev.buf) then
      return
    end
    local temp_fname = B.rep_slash_lower(vim.api.nvim_buf_get_name(ev.buf))
    local temp_projectroot = B.rep_slash_lower(vim.fn['ProjectRootGet'](temp_fname))
    if temp_projectroot ~= M.cur_projectroot then
      M.cur_projectroot = temp_projectroot
    end
    M.bufenter_timer = B.set_timeout(200, function()
      M.update_show_bufs()
      M.refresh_tabline()
      M.bufenter_timer = 0
    end)
  end,
})

B.aucmd(M.source, 'BufDelete', { 'BufDelete', }, {
  callback = function()
    M.buf_deleting = 1
    if M.bufdelete_timer ~= 0 then
      B.clear_interval(M.bufdelete_timer)
    end
    M.bufdelete_timer = B.set_timeout(200, function()
      M.buf_deleting = nil
      M.bufdelete_timer = 0
    end)
  end,
})

B.aucmd(M.source, 'WinResized', { 'WinResized', }, {
  callback = function()
    if M.bufenter_timer ~= 0 then
      B.clear_interval(M.bufenter_timer)
    end
    M.bufenter_timer = B.set_timeout(200, function()
      M.refresh_tabline()
      M.bufenter_timer = 0
    end)
  end,
})

B.aucmd(M.source, 'DirChanged', { 'DirChanged', }, {
  callback = function()
    M.refresh_tabline()
    pcall(vim.cmd, 'ProjectRootCD')
  end,
})

M.only_cur_buffer = function()
  vim.cmd 'tabo'
  vim.cmd 'wincmd o'
  pcall(vim.cmd, 'e!')
end

M.restore_hidden_tabs = function()
  vim.cmd 'tabo'
  vim.cmd 'wincmd o'
  if #vim.tbl_keys(M.projects) > 1 then
    local temp = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
    for _, project in ipairs(vim.tbl_keys(M.projects_active)) do
      if project ~= temp and vim.fn.buflisted(M.projects_active[project]) == 1 then
        vim.cmd 'wincmd v'
        vim.cmd 'wincmd T'
        vim.cmd('b' .. M.projects_active[project])
      end
    end
    vim.cmd '1tabnext'
  end
end

require 'telescope'.load_extension 'ui-select'

M.append_one_proj_right_down = function()
  if #vim.tbl_keys(M.projects) > 1 then
    local projs = {}
    local active_projs = {}
    for winnr = 1, vim.fn.winnr '$' do
      local tt = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(vim.fn.winbufnr(winnr))))
      if vim.tbl_contains(active_projs, tt) == false then
        active_projs[#active_projs + 1] = tt
      end
    end
    for _, project in ipairs(vim.tbl_keys(M.projects_active)) do
      if vim.tbl_contains(active_projs, project) == false and vim.fn.buflisted(M.projects_active[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_right_down', }, function(choice, idx)
        if not choice then
          return
        end
        vim.cmd 'wincmd b'
        vim.cmd 'wincmd s'
        vim.cmd('b' .. M.projects_active[choice])
      end)
    else
      print 'no append_one_proj_right_down'
    end
  end
end

M.append_one_proj_new_tab = function()
  if #vim.tbl_keys(M.projects) > 1 then
    local projs = {}
    local temp = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
    for _, project in ipairs(vim.tbl_keys(M.projects_active)) do
      if project ~= temp and vim.fn.buflisted(M.projects_active[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_new_tab', }, function(choice, idx)
        if not choice then
          return
        end
        vim.cmd 'wincmd s'
        vim.cmd 'wincmd T'
        vim.cmd('b' .. M.projects_active[choice])
      end)
    else
      print 'no append_one_proj_new_tab'
    end
  end
end

M.append_one_proj_new_tab_no_dupl = function()
  if #vim.tbl_keys(M.projects) > 1 then
    local projs = {}
    local active_projs = {}
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      local tt = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(vim.fn.winbufnr(winid))))
      if vim.tbl_contains(active_projs, tt) == false then
        active_projs[#active_projs + 1] = tt
      end
    end
    for _, project in ipairs(vim.tbl_keys(M.projects_active)) do
      if vim.tbl_contains(active_projs, project) == false and vim.fn.buflisted(M.projects_active[project]) == 1 then
        projs[#projs + 1] = project
      end
    end
    if #projs > 0 then
      vim.ui.select(projs, { prompt = 'append_one_proj_new_tab_no_dupl', }, function(choice, idx)
        if not choice then
          return
        end
        vim.cmd 'wincmd s'
        vim.cmd 'wincmd T'
        vim.cmd('b' .. M.projects_active[choice])
      end)
    else
      print 'no append_one_proj_new_tab_no_dupl'
    end
  end
end

M.simple_statusline_toggle = function()
  if M.simple_statusline then
    M.simple_statusline = nil
    vim.opt.showtabline = 2
    vim.opt.laststatus = 3
  else
    M.simple_statusline = 1
    vim.opt.showtabline = 0
    vim.opt.laststatus = 2
  end
end

return M
