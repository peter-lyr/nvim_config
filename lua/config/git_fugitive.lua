local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.toggle()
  if B.is_buf_ft('fugitive') then
    vim.cmd 'close'
  else
    vim.cmd 'Git'
  end
end

return M
