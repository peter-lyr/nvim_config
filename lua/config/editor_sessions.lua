local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require 'sessions'.setup {
  events = { 'VimLeavePre', },
  session_filepath = vim.fn.stdpath 'data' .. '\\sessions',
  absolute = true,
}

function M.load()
  vim.cmd 'SessionsLoad'
end

function M.save()
  vim.cmd 'SessionsSave'
end

return M
