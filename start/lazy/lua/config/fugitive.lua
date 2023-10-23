local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

M.toggle = function()
  if B.is_buf_ft(vim.fn.bufnr(), 'fugitive') then
    vim.cmd 'close'
  else
    vim.cmd 'Git'
  end
end

B.map('<leader>ag', M, 'toggle', {})

print(M.source)

return M
