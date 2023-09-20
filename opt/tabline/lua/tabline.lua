local M = {}

local cur_projectroot = ''
local projects = {}

vim.cmd [[
  function! SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
    call v:lua.SwitchBuffer(a:bufnr, a:mouseclicks, a:mousebutton, a:modifiers)
  endfunction
]]

function SwitchBuffer(bufnr, mouseclicks, mousebutton, modifiers)
  if mousebutton == 'm' and mouseclicks == 1 then
  elseif mousebutton == 'l' and mouseclicks == 1 then
    if vim.fn.buflisted(vim.fn.bufnr()) ~= 0 then
      vim.cmd('b' .. bufnr)
    end
  elseif mousebutton == 'r' and mouseclicks == 1 then
  end
end

local function rep(content)
  content = vim.fn.tolower(content)
  content = string.gsub(content, '/', '\\')
  return content
end

M.refresh_tabline = function()
  if projects[cur_projectroot] then
    local items = {}
    for i, bufnr in ipairs(projects[cur_projectroot]) do
      local buf_name = vim.fn.bufname(bufnr)
      local only_name = string.gsub(buf_name, '/', '\\')
      if string.match(only_name, '\\') then
        only_name = string.match(only_name, '.+%\\(.+)$')
      end
      items[#items + 1] = '%' .. tostring(bufnr) .. '@SwitchBuffer@ ' .. tostring(i) .. ' ' .. only_name
    end
    local temp = vim.fn.join(items, ' ')
    temp = temp .. '%=' .. vim.loop.cwd() .. ' '
    vim.opt.tabline = temp
  end
end

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_bufenter_1)

vim.g.tabline_au_bufenter_1 = vim.api.nvim_create_autocmd('BufEnter', {
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
    if temp_projectroot ~= cur_projectroot then
      cur_projectroot = temp_projectroot
    end
    if vim.tbl_contains(vim.tbl_keys(projects), temp_projectroot) == false then
      projects[temp_projectroot] = {}
    end
    if vim.tbl_contains(projects[temp_projectroot], cur_bufnr) == false then
      projects[temp_projectroot][#projects[temp_projectroot] + 1] = cur_bufnr
      M.refresh_tabline()
    end
  end,
})

pcall(vim.api.nvim_del_autocmd, vim.g.tabline_au_dirchanged)

vim.g.tabline_au_dirchanged = vim.api.nvim_create_autocmd('DirChanged', {
  callback = function()
    M.refresh_tabline()
  end,
})

return M
