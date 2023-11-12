local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

B.load_require 'itchyny/vim-gitbranch'

function M.filesize()
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

function M.info()
  local temp = {
    { 'cwd',          vim.loop.cwd(), },
    { 'fname',        vim.fn.bufname(), },
    { 'mem',          string.format('%dM', vim.loop.resident_set_memory() / 1024 / 1024), },
    { 'fsize',        M.filesize(), },
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
  B.notify_info(vim.fn.join(items, '\n'))
end

return M
