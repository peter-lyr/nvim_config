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

local fts = {
  'neo-tree',
  'minimap',
  'aerial',
  'edgy',
  'notify',
}

M.hide = function()
  local buffers = {}
  for winnr=1, vim.fn.winnr('$') do
    local bufnr = vim.fn.winbufnr(winnr)
    if vim.tbl_contains(fts, vim.api.nvim_buf_get_option(bufnr, 'filetype')) == false then
      table.insert(buffers, bufnr)
      -- print(bufnr, vim.fn.bufname(bufnr), vim.api.nvim_buf_get_option(bufnr, 'filetype'))
    end
  end
  -- print(#buffers)
  if #buffers > 1 and vim.tbl_contains(buffers, vim.fn.bufnr()) then
    M.stack_cur_bufname()
    vim.cmd([[
      try
        hide
      catch
      endtry
    ]])
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
