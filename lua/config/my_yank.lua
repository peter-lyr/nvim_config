local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.set(content)
  vim.fn.setreg('+', content)
  B.notify_info(content)
end

function M.name()
  return B.rep_slash(vim.api.nvim_buf_get_name(0))
end

function M.bname()
  return B.rep_slash(vim.fn.bufname())
end

function M.file()
  M.set(M.name())
end

function M.file_head()
  M.set(vim.fn.fnamemodify(M.name(), ':h'))
end

function M.file_tail()
  M.set(vim.fn.fnamemodify(M.name(), ':t'))
end

function M.cwd()
  M.set(vim.loop.cwd())
end

function M.bufname()
  M.set(M.bname())
end

function M.bufname_head()
  M.set(vim.fn.fnamemodify(M.bname(), ':h'))
end

return M
