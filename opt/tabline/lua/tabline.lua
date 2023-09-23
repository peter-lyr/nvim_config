local M = {}

package.loaded['tabline'] = nil

M.cur_projectroot = ''
M.projects = {}
M.projects_active = {}
M.buf_deleting = nil
M.bufenter_timer = 0
M.bufdelete_timer = 0

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

local function indexof(tbl, item)
  return vim.fn.indexof(tbl, string.format('v:val == %s', item)) + 1
end

local function get_only_name(bufname)
  local only_name = string.gsub(bufname, '/', '\\')
  if string.match(only_name, '\\') then
    only_name = string.match(only_name, '.+%\\(.+)$')
  end
  return only_name
end

M.is_buf_to_show = function(bufnr)
  local temp_fname = rep(vim.api.nvim_buf_get_name(bufnr))
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
  if mousebutton == 'm' then     -- and mouseclicks == 1 then
    pcall(vim.cmd, tabnr .. 'tabclose')
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
    local index = indexof(M.projects[M.cur_projectroot], vim.fn.bufnr()) - 1
    if index < 1 then
      index = 1
    end
    vim.cmd(string.format('b%d', M.projects[M.cur_projectroot][index]))
  end
end

M.b_next_buf = function()
  if M.projects[M.cur_projectroot] then
    local index = indexof(M.projects[M.cur_projectroot], vim.fn.bufnr()) + 1
    if index > #M.projects[M.cur_projectroot] then
      index = #M.projects[M.cur_projectroot]
    end
    vim.cmd(string.format('b%d', M.projects[M.cur_projectroot][index]))
  end
end

M.bd_prev_buf = function()
  if #M.projects[M.cur_projectroot] > 0 then
    local index = indexof(M.projects[M.cur_projectroot], vim.fn.bufnr())
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
    local index = indexof(M.projects[M.cur_projectroot], vim.fn.bufnr())
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
  local index = indexof(bufnrs, cur_bufnr)
  local columns = vim.opt.columns:get()
  local buf_len = columns - #vim.loop.cwd() - 2
  local newbufnrs = { bufnrs[index], }
  buf_len = buf_len - #get_only_name(vim.fn.bufname(cur_bufnr)) - 4
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
    buf_len = buf_len - #string.format('[%d/%d] ', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
  end
  buf_len = buf_len - #tostring(#bufnrs) - 1
  local cnt1 = 1
  local cnt2 = 1
  for i = 2, #bufnrs do
    if i % 2 == 0 then
      local ii = index + cnt1
      if ii > #bufnrs then
        ii = index - cnt2
        local only_name = get_only_name(vim.fn.bufname(bufnrs[ii]))
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
        local only_name = get_only_name(vim.fn.bufname(bufnrs[ii]))
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
        local only_name = get_only_name(vim.fn.bufname(bufnrs[ii]))
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
        local only_name = get_only_name(vim.fn.bufname(bufnrs[ii]))
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
    if newbufnrs[1] == cur_bufnr and indexof(bufnrs, cur_bufnr) ~= 1 then
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
  local items = {}
  local buf_to_show = {}
  local yy = 1
  local temp = ''
  if not only_tabs then
    if M.projects[M.cur_projectroot] then
      buf_to_show = M.get_buf_to_show(M.projects[M.cur_projectroot], vim.fn.bufnr())
      if #buf_to_show == 0 then
        buf_to_show = M.projects[M.cur_projectroot]
      end
      yy = indexof(M.projects[M.cur_projectroot], buf_to_show[1])
    end
    for i, bufnr in ipairs(buf_to_show) do
      local xx = tostring(yy + i - 1)
      local only_name = get_only_name(vim.fn.bufname(bufnr))
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
    temp = temp .. '%=%<%#tblfil#'
    local temp_projs = {}
    local curtabpagenr = vim.fn.tabpagenr()
    local tabpagemax = vim.fn.tabpagenr '$'
    for tabpagenr= 1, tabpagemax do
      local name = ''
      local temp_fname = ''
      for _, bufnr in ipairs(vim.fn.tabpagebuflist(tabpagenr)) do
        temp_fname = vim.api.nvim_buf_get_name(bufnr)
        local temp_proj = rep(vim.fn['ProjectRootGet'](temp_fname))
        if temp_proj ~= '.' and vim.fn.isdirectory(temp_proj) == 1 and vim.tbl_contains(temp_projs, temp_proj) == false then
          temp_projs[#temp_projs+1] = temp_proj
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
    temp = temp .. '%#tblfil#%=%<%#tblfil#'
    local ii = ''
    if vim.fn.tabpagenr '$' > 1 then
      ii = string.format('[%d/%d] ', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
    end
    temp = temp .. '%#tbltab#'
    temp = temp .. '%' .. tostring(vim.fn.tabpagenr()) .. '@SwitchTabNext@ ' .. vim.loop.cwd() .. ' ' .. ii
  end
  vim.opt.tabline = temp
end

vim.cmd [[
  hi tblsel guifg=#e6646e guibg=#555555 gui=bold
  hi tbltab guifg=#64e66e guibg=#666666 gui=bold
  hi tblfil guifg=none
]]

M.update_show_bufs = function()
  M.projects = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local temp_fname = rep(vim.api.nvim_buf_get_name(bufnr))
    if M.is_buf_to_show(bufnr) then
      local temp_projectroot = rep(vim.fn['ProjectRootGet'](temp_fname))
      if vim.tbl_contains(vim.tbl_keys(M.projects), temp_projectroot) == false then
        M.projects[temp_projectroot] = {}
      end
      M.projects[temp_projectroot][#M.projects[temp_projectroot] + 1] = bufnr
      M.projects_active[temp_projectroot] = bufnr
    end
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_bufenter_1)

vim.g.tabline_au_bufenter_1 = vim.api.nvim_create_autocmd({ 'BufEnter', }, {
  callback = function(ev)
    if M.buf_deleting then
      return
    end
    if M.bufenter_timer ~= 0 then
      M.bufenter_timer:stop()
    end
    if not M.is_buf_to_show(ev.buf) then
      return
    end
    local temp_fname = rep(vim.api.nvim_buf_get_name(ev.buf))
    local temp_projectroot = rep(vim.fn['ProjectRootGet'](temp_fname))
    if temp_projectroot ~= M.cur_projectroot then
      M.cur_projectroot = temp_projectroot
    end
    M.bufenter_timer = vim.loop.new_timer()
    M.bufenter_timer:start(200, 0, function()
      vim.schedule(function()
        M.update_show_bufs()
        M.refresh_tabline()
        M.bufenter_timer = 0
      end)
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_bufdelete_1)

vim.g.tabline_au_bufdelete_1 = vim.api.nvim_create_autocmd({ 'BufDelete', }, {
  callback = function()
    M.buf_deleting = 1
    if M.bufdelete_timer ~= 0 then
      M.bufdelete_timer:stop()
    end
    M.bufdelete_timer = vim.loop.new_timer()
    M.bufdelete_timer:start(200, 0, function()
      vim.schedule(function()
        M.buf_deleting = nil
        M.bufdelete_timer = 0
      end)
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_winresized_1)

vim.g.tabline_au_winresized_1 = vim.api.nvim_create_autocmd({ 'WinResized', }, {
  callback = function()
    if M.bufenter_timer ~= 0 then
      M.bufenter_timer:stop()
    end
    M.bufenter_timer = vim.loop.new_timer()
    M.bufenter_timer:start(200, 0, function()
      vim.schedule(function()
        M.refresh_tabline()
        M.bufenter_timer = 0
      end)
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_dirchanged)

vim.g.tabline_au_dirchanged = vim.api.nvim_create_autocmd({ 'DirChanged', 'TabEnter', }, {
  callback = function()
    M.refresh_tabline()
  end,
})

M.restore_hidden_tabs = function()
  vim.cmd 'tabo'
  vim.cmd 'wincmd o'
  if #vim.tbl_keys(M.projects) > 1 then
    local temp = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
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

return M
