local M = {}

local stack_fpath = ''
local split

M.pop_last_bufname = function(mode)
  split = mode
  if split == 'up' then
    vim.cmd('leftabove split')
  elseif split == 'right' then
    vim.cmd('rightbelow vsplit')
  elseif split == 'down' then
    vim.cmd('rightbelow split')
  elseif split == 'left' then
    vim.cmd('leftabove vsplit')
  elseif split == 'tab' then
    vim.cmd('leftabove vsplit')
    vim.cmd('wincmd T')
  end
  if #stack_fpath > 0 then
    vim.cmd('e ' .. stack_fpath)
  end
end

M.stack_cur_bufname = function()
  local fname = vim.api.nvim_buf_get_name(0)
  if #fname > 0 and vim.bo.modifiable == true and vim.bo.readonly == false then
    stack_fpath = fname
    print('stack file: ' .. vim.fn.expand('%:~:.'))
  end
end

-- donot close buf type

local close_fts = {
  'NvimTree',
  'fugitive',
  'minimap',
  'aerial',
  'edgy',
  'notify',
}

M.close = function()
  local buffers = {}
  for winnr = 1, vim.fn.winnr('$') do
    local bufnr = vim.fn.winbufnr(winnr)
    if vim.tbl_contains(close_fts, vim.api.nvim_buf_get_option(bufnr, 'filetype')) == false then
      table.insert(buffers, bufnr)
      -- print(bufnr, vim.fn.bufname(bufnr), vim.api.nvim_buf_get_option(bufnr, 'filetype'))
    end
  end
  -- print(#buffers)
  if #buffers > 1 and vim.tbl_contains(buffers, vim.fn.bufnr()) then
    M.stack_cur_bufname()
    vim.cmd([[
      try
        close
      catch
      endtry
    ]])
  end
end

M.delete = function()
  if vim.tbl_contains(close_fts, vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype')) == false then
    M.stack_cur_bufname()
    vim.cmd([[
      try
        Bdelete!
      catch
      endtry
    ]])
  end
end

M.wipeout = function()
  if vim.tbl_contains(close_fts, vim.api.nvim_buf_get_option(vim.fn.bufnr(), 'filetype')) == false then
    M.stack_cur_bufname()
    vim.cmd([[
      try
        bw!
      catch
      endtry
    ]])
  end
end

M.tabclose = function()
  if vim.fn.bufnr('-MINIMAP-') ~= -1 then
    vim.cmd('MinimapClose')
  end
  vim.cmd([[
    try
      tabclose!
    catch
    endtry
  ]])
end

M.tabbwipeout = function()
  if vim.fn.bufnr('-MINIMAP-') ~= -1 then
    vim.cmd('MinimapClose')
  end
  local curroot = string.gsub(vim.fn.tolower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(0))), '\\', '/')
  vim.cmd([[
    try
      tabclose!
    catch
    endtry
  ]])
  local roots = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local fname = vim.api.nvim_buf_get_name(b)
    if require('plenary.path').new(fname):exists() then
      if vim.fn.buflisted(b) ~= 0 and vim.api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix' or vim.api.nvim_buf_get_option(b, 'buftype') == 'help' then
        local root = string.gsub(vim.fn.tolower(vim.fn['ProjectRootGet'](vim.api.nvim_buf_get_name(b))), '\\', '/')
        table.insert(roots, root)
      end
    end
  end
  if #roots <= 1 then
    return
  end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    local fname = vim.api.nvim_buf_get_name(b)
    if curroot == string.gsub(vim.fn.tolower(vim.fn['ProjectRootGet'](fname)), '\\', '/') then
      pcall(vim.cmd, 'bw! ' .. tostring(b))
    end
  end
end

M.bw_unlisted_buffers = function()
  local path = require('plenary.path')
  local bufnrs = vim.tbl_filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      local pfname = path:new(vim.api.nvim_buf_get_name(b))
      if pfname:exists() and not pfname:is_dir() then
        return true
      end
      return false
    end
    return false
  end, vim.api.nvim_list_bufs())
  for _, v in ipairs(bufnrs) do
    vim.cmd('bw!' .. v)
  end
end

return M
