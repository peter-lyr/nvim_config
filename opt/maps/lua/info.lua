local M = {}
local B = require 'my_base'
M.source = debug.getinfo(1)['source']
package.loaded[B.get_loaded(M.source)] = nil
--------------------------------------------

vim.cmd 'Lazy load nvim-treesitter'
vim.cmd 'Lazy load vim-gitbranch'

local function filesize()
  local file = vim.fn.expand '%:p'
  if file == nil or #file == 0 then
    return ''
  end
  local size = vim.fn.getfsize(file)
  if size <= 0 then
    return ''
  end
  local suffixes = { 'B', 'K', 'M', 'G', }
  local i = 1
  while size > 1024 and i < #suffixes do
    size = size / 1024
    i = i + 1
  end
  local format = i == 1 and '%d%s' or '%.1f%s'
  return string.format(format, size, suffixes[i])
end

M.statusline = function()
  local temp = {
    { 'cwd',          vim.loop.cwd(), },
    { 'fname',        vim.fn.bufname(), },
    { 'mem',          string.format('%dM', vim.loop.resident_set_memory() / 1024 / 1024), },
    { 'fsize',        filesize(), },
    { 'datetime',     vim.fn.strftime '%Y-%m-%d %H:%M:%S %A', },
    { 'fileencoding', vim.opt.fileencoding:get(), },
    { 'fileformat',   vim.bo.fileformat, },
    { 'gitbranch',    vim.fn['gitbranch#name'](), },
  }
  local items = {}
  local width = 0
  for _, v in ipairs(temp) do
    if width < #v[1] then
      width = #v[1]
    end
  end
  local str = '# %d. [%' .. width .. 's]: %s'
  for k, v in ipairs(temp) do
    items[#items + 1] = string.format(str, k, unpack(v))
  end
  vim.notify(vim.fn.join(items, '\n'), 'info', {
    animate = false,
    on_open = function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(win, 'concealcursor', 'nvic')
    end,
    timeout = 1000 * 8,
  })
end

M.new_buf_execute = function(cmd)
  local result = vim.fn.execute(cmd)
  local lines = vim.fn.split(result, '\\n')
  if #lines > 0 then
    vim.cmd 'wincmd n'
    vim.fn.append(vim.fn.line '.', lines)
    local buf = vim.fn.bufnr()
    B.buf_map_close('q', buf)
    B.buf_map_close('<esc>', buf)
  end
end

M.message = function()
  M.new_buf_execute 'mes'
end

vim.api.nvim_create_user_command('X', function(params)
  M.new_buf_execute(vim.fn.join(params['fargs'], ' '))
end, { nargs = '*', complete = 'command', })

return M
