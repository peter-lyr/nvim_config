local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

vim.cmd [[
  hi tblsel guifg=#e6646e guibg=#555555 gui=bold
  hi tbltab guifg=#64e66e guibg=#666666 gui=bold
  hi tblfil guifg=none
]]

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
  local C = require 'config.tabline'
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
  local C = require 'config.tabline'
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
  local C = require 'config.tabline'
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

M.is_buf_to_show = function(buf)
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

function M.update_bufs(cur_buf)
  local cur_proj = B.rep_slash_lower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(cur_buf)))
  if not B.is(M.is_buf_to_show(cur_buf)) then
    return {}, {}, cur_proj
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
  return proj_bufs, proj_buf, cur_proj
end

--------------

function M.get_buf_to_show(bufs, cur_buf)
  local index = B.index_of(bufs, cur_buf)
  if index == -1 then
    return {}
  end
  local columns = vim.opt.columns:get()
  local buf_len = columns - #vim.loop.cwd() - 2
  local newbufnrs = { bufs[index], }
  buf_len = buf_len - #B.get_only_name(vim.fn.bufname(cur_buf)) - 4
  if buf_len < 0 then
    if index >= 2 then
      table.insert(newbufnrs, 1, bufs[index - 1])
    end
    if index < #bufs then
      table.insert(newbufnrs, bufs[index + 1])
    end
    return newbufnrs
  end
  if vim.fn.tabpagenr '$' > 1 then
    buf_len = buf_len - #string.format('%d/%d ', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
  end
  buf_len = buf_len - #tostring(#bufs) - 1
  local cnt1 = 1
  local cnt2 = 1
  for i = 2, #bufs do
    if i % 2 == 0 then
      local ii = index + cnt1
      if ii > #bufs then
        ii = index - cnt2
        local only_name = B.get_only_name(vim.fn.bufname(bufs[ii]))
        buf_len = buf_len - #only_name - 4
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
        buf_len = buf_len - #only_name - 4
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
        buf_len = buf_len - #only_name - 4
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
        buf_len = buf_len - #only_name - 4
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

function M.refresh_tabline(proj_bufs, cur_proj, cur_buf)
  local items = {}
  local buf_to_show = {}
  local yy = 1
  local temp = ''
  if proj_bufs[cur_proj] then
    buf_to_show = M.get_buf_to_show(proj_bufs[cur_proj], cur_buf)
    if #buf_to_show == 0 then
      buf_to_show = proj_bufs[cur_proj]
    end
    yy = B.index_of(proj_bufs[cur_proj], buf_to_show[1])
  end
  for i, bufnr in ipairs(buf_to_show) do
    local xx = tostring(yy + i - 1)
    local only_name = B.get_only_name(vim.fn.bufname(bufnr))
    local temp_ = ''
    if cur_buf == bufnr then
      temp_ = '%#tblsel#'
      xx = xx .. '/' .. #proj_bufs[cur_proj]
    else
      temp_ = '%#tblfil#'
    end
    items[#items + 1] = temp_ .. '%' .. tostring(bufnr) .. '@SwitchBuffer@ ' .. xx .. ' ' .. only_name
  end
  temp = temp .. vim.fn.join(items, ' ') .. ' '
  temp = temp .. '%#tblfil#%1@SwitchNone@%=%<%#tblfil#'
  local ii = ''
  if vim.fn.tabpagenr '$' > 1 then
    ii = string.format('%d/%d ', vim.fn.tabpagenr(), vim.fn.tabpagenr '$')
  end
  temp = temp .. '%#tbltab#'
  temp = temp .. '%' .. tostring(vim.fn.tabpagenr()) .. '@SwitchTabNext@ ' .. vim.loop.cwd() .. ' ' .. ii
  vim.opt.tabline = temp
end

return M
