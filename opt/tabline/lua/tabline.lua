local M = {}

package.loaded['tabline'] = nil

local cur_projectroot = ''
local projects = {}
local projects_active = {}
local timer = 0

vim.cmd [[
  function! SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchBuffer(a:bufnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchTab(a:tabnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
  function! SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchWindow(a:win_number, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
]]

function SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' then     -- and mouseclicks == 1 then
  elseif mousebutton == 'l' then -- and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) ~= 0 then
      vim.cmd('b' .. bufnr)
      M.refresh_tabline(1)
    end
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

function SwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
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
    M.refresh_tabline(1)
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

function SwitchWindow(win_number, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' and mouseclicks == 1 then
  elseif mousebutton == 'l' and mouseclicks == 1 then
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

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

M.b_prev_buf = function()
  if projects[cur_projectroot] then
    local index = indexof(projects[cur_projectroot], vim.fn.bufnr()) - 1
    if index < 1 then
      index = 1
    end
    vim.cmd(string.format('b%d', projects[cur_projectroot][index]))
  end
end

M.b_next_buf = function()
  if projects[cur_projectroot] then
    local index = indexof(projects[cur_projectroot], vim.fn.bufnr()) + 1
    if index > #projects[cur_projectroot] then
      index = #projects[cur_projectroot]
    end
    vim.cmd(string.format('b%d', projects[cur_projectroot][index]))
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

M.refresh_tabline = function(hl)
  if projects[cur_projectroot] then
    local items = {}
    local buf_to_show = M.get_buf_to_show(projects[cur_projectroot], vim.fn.bufnr())
    if #buf_to_show == 0 then
      buf_to_show = projects[cur_projectroot]
    end
    local yy = indexof(projects[cur_projectroot], buf_to_show[1])
    for i, bufnr in ipairs(buf_to_show) do
      local xx = yy + i - 1
      local only_name = get_only_name(vim.fn.bufname(bufnr))
      local temp = ''
      if hl then
        if vim.fn.bufnr() == bufnr then
          temp = '%#tblsel#'
        else
          temp = '%#tblfil#'
        end
      end
      items[#items + 1] = temp .. '%' .. tostring(bufnr) .. '@SwitchBuffer@ ' .. tostring(xx) .. ' ' .. only_name
    end
    local temp = vim.fn.join(items, ' ') .. ' '
    if hl then
      temp = temp .. '%#tblfil#%=%<%#tblfil#'
    else
      temp = temp .. '%=%<'
    end
    local ii = ''
    if vim.fn.tabpagenr '$' > 1 then
      ii = string.format(' [%d/%d]', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
    end
    if hl then
      temp = temp .. '%#tbltab#'
    end
    temp = temp .. '%' .. tostring(vim.fn.tabpagenr()) .. '@SwitchTab@' .. ii .. ' ' .. vim.loop.cwd() .. ' '
    vim.opt.tabline = temp
  end
end

vim.cmd [[
  hi tblsel guifg=#e6646e guibg=#5a5a5a gui=bold
  hi tbltab guifg=#64e66e guibg=#5a5a5a gui=bold
  hi tblfil guifg=none
]]

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_bufenter_1)

vim.g.tabline_au_bufenter_1 = vim.api.nvim_create_autocmd({ 'BufEnter', 'WinResized', }, {
  callback = function(ev)
    local cur_bufnr = ev.buf
    local temp_fname = rep(vim.api.nvim_buf_get_name(cur_bufnr))
    if #temp_fname == 0 then
      return
    end
    if not require 'plenary.path'.new(temp_fname):exists() then
      return
    end
    if vim.fn.buflisted(cur_bufnr) == 0 or vim.api.nvim_buf_get_option(cur_bufnr, 'buftype') == 'quickfix' then
      return
    end
    local temp_projectroot = rep(vim.fn['ProjectRootGet'](temp_fname))
    local ok = nil
    if temp_projectroot ~= cur_projectroot then
      ok = 1
      cur_projectroot = temp_projectroot
    end
    if vim.tbl_contains(vim.tbl_keys(projects), temp_projectroot) == false then
      ok = 1
      projects[temp_projectroot] = {}
    end
    if vim.tbl_contains(projects[temp_projectroot], cur_bufnr) == false then
      ok = 1
      projects[temp_projectroot][#projects[temp_projectroot] + 1] = cur_bufnr
    end
    projects_active[temp_projectroot] = cur_bufnr
    if ok then
      M.refresh_tabline()
    end
    if timer ~= 0 then
      timer:stop()
    end
    timer = vim.loop.new_timer()
    timer:start(200, 0, function()
      vim.schedule(function()
        M.refresh_tabline(1)
        timer = 0
      end)
    end)
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_dirchanged)

vim.g.tabline_au_dirchanged = vim.api.nvim_create_autocmd({ 'DirChanged', 'TabEnter', }, {
  callback = function()
    M.refresh_tabline(1)
  end,
})

M.restore_hidden_tabs = function()
  vim.cmd 'tabo'
  vim.cmd 'wincmd o'
  if #vim.tbl_keys(projects) > 1 then
    local temp = rep(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0)))
    for _, project in ipairs(vim.tbl_keys(projects_active)) do
      if project ~= temp and vim.fn.buflisted(projects_active[project]) == 1 then
        vim.cmd 'wincmd v'
        vim.cmd 'wincmd T'
        vim.cmd('b' .. projects_active[project])
      end
    end
    vim.cmd '1tabnext'
  end
end

return M
