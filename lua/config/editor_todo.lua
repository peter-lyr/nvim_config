local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

require 'todo-comments'.setup {
  -- keywords = {
  --   FIX = {
  --     icon = ' ', -- icon used for the sign, and in search results
  --     color = 'error', -- can be a hex color, or a named color (see below)
  --     alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE', }, -- a set of other keywords that all map to this FIX keywords
  --     -- signs = false, -- configure signs for some keywords individually
  --   },
  --   TODO = { icon = ' ', color = 'info', },
  --   HACK = { icon = ' ', color = 'warning', },
  --   WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX', }, },
  --   PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', }, },
  --   NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', }, },
  --   TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED', }, },
  -- },
}
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
