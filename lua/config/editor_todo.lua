local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

require 'todo-comments'.setup {}
require 'map.sidepanel_quickfix'

function M.TodoQuickFix()
  vim.cmd 'TodoQuickFix'
end

function M.TodoTelescope()
  vim.cmd 'TodoTelescope'
end

function M.TodoLocList()
  vim.cmd 'TodoLocList'
end

return M
