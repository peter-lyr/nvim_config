local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

require 'sessions'.setup {
  events = { 'VimLeavePre', },
  session_filepath = vim.fn.stdpath 'data' .. '\\sessions',
  absolute = true,
}

function M.load()
  vim.cmd 'SessionsLoad'
end

return M
