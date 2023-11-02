local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.fname = function()
  vim.cmd 'let @+ = expand("%:t")'
  B.notify_info(vim.fn.expand '%:t')
end

M.absfname = function()
  vim.cmd 'let @+ = substitute(nvim_buf_get_name(0), "/", "\\\\", "g")'
  B.notify_info(vim.fn.substitute(vim.api.nvim_buf_get_name(0), '/', '\\\\', 'g'))
end

M.cwd = function()
  vim.cmd 'let @+ = substitute(getcwd(), "/", "\\\\", "g")'
  B.notify_info(vim.fn.substitute(vim.loop.cwd(), '/', '\\\\', 'g'))
end

return M
