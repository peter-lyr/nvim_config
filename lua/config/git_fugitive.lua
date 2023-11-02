local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.toggle()
  if B.is_buf_ft('fugitive') then
    vim.cmd 'close'
  else
    vim.cmd 'Git'
  end
end

return M
