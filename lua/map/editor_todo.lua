local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

M.FIX = { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', }
M.WARN = { 'WARN', 'WARNING', 'XXX', }
M.PERF = { 'PERF', 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', }
M.NOTE = { 'NOTE', 'INFO', }
M.TEST = { 'TEST', 'TESTING', 'PASSED', 'FAILED', }

require 'todo-comments'.setup {
  keywords = {
    FIX = {
      icon = ' ', -- icon used for the sign, and in search results
      color = 'error', -- can be a hex color, or a named color (see below)
      alt = M.FIX, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = ' ', color = 'info', },
    HACK = { icon = ' ', color = 'warning', },
    WARN = { icon = ' ', color = 'warning', alt = M.WARN, },
    PERF = { icon = ' ', alt = M.PERF, },
    NOTE = { icon = ' ', color = 'hint', alt = M.NOTE, },
    TEST = { icon = '⏲ ', color = 'test', alt = M.TEST, },
  },
}

vim.keymap.set({ 'n', 'v', }, '<leader>tqq', function() require 'config.editor_todo'.TodoQuickFix() end, M.opt 'TodoQuickFix ALL')
vim.keymap.set({ 'n', 'v', }, '<leader>tqf', function() require 'config.editor_todo'.TodoQuickFix(M.FIX ) end, M.opt 'TodoQuickFix FIX')
vim.keymap.set({ 'n', 'v', }, '<leader>tqt', function() require 'config.editor_todo'.TodoQuickFix('TODO') end, M.opt 'TodoQuickFix TODO')
vim.keymap.set({ 'n', 'v', }, '<leader>tqh', function() require 'config.editor_todo'.TodoQuickFix('HACK') end, M.opt 'TodoQuickFix HACK')
vim.keymap.set({ 'n', 'v', }, '<leader>tqw', function() require 'config.editor_todo'.TodoQuickFix(M.WARN) end, M.opt 'TodoQuickFix WARN')
vim.keymap.set({ 'n', 'v', }, '<leader>tqp', function() require 'config.editor_todo'.TodoQuickFix(M.PERF) end, M.opt 'TodoQuickFix PERF')
vim.keymap.set({ 'n', 'v', }, '<leader>tqn', function() require 'config.editor_todo'.TodoQuickFix(M.NOTE) end, M.opt 'TodoQuickFix NOTE')
vim.keymap.set({ 'n', 'v', }, '<leader>tqs', function() require 'config.editor_todo'.TodoQuickFix(M.TEST) end, M.opt 'TodoQuickFix TEST')

vim.keymap.set({ 'n', 'v', }, '<leader>ttt', function() require 'config.editor_todo'.TodoTelescope() end, M.opt 'TodoTelescope ALL')
vim.keymap.set({ 'n', 'v', }, '<leader>ttf', function() require 'config.editor_todo'.TodoTelescope(M.FIX ) end, M.opt 'TodoTelescope FIX')
vim.keymap.set({ 'n', 'v', }, '<leader>ttt', function() require 'config.editor_todo'.TodoTelescope('TODO') end, M.opt 'TodoTelescope TODO')
vim.keymap.set({ 'n', 'v', }, '<leader>tth', function() require 'config.editor_todo'.TodoTelescope('HACK') end, M.opt 'TodoTelescope HACK')
vim.keymap.set({ 'n', 'v', }, '<leader>ttw', function() require 'config.editor_todo'.TodoTelescope(M.WARN) end, M.opt 'TodoTelescope WARN')
vim.keymap.set({ 'n', 'v', }, '<leader>ttp', function() require 'config.editor_todo'.TodoTelescope(M.PERF) end, M.opt 'TodoTelescope PERF')
vim.keymap.set({ 'n', 'v', }, '<leader>ttn', function() require 'config.editor_todo'.TodoTelescope(M.NOTE) end, M.opt 'TodoTelescope NOTE')
vim.keymap.set({ 'n', 'v', }, '<leader>tts', function() require 'config.editor_todo'.TodoTelescope(M.TEST) end, M.opt 'TodoTelescope TEST')

vim.keymap.set({ 'n', 'v', }, '<leader>tll', function() require 'config.editor_todo'.TodoLocList() end, M.opt 'TodoLocList ALL')
vim.keymap.set({ 'n', 'v', }, '<leader>tlf', function() require 'config.editor_todo'.TodoLocList(M.FIX ) end, M.opt 'TodoLocList FIX')
vim.keymap.set({ 'n', 'v', }, '<leader>tlt', function() require 'config.editor_todo'.TodoLocList('TODO') end, M.opt 'TodoLocList TODO')
vim.keymap.set({ 'n', 'v', }, '<leader>tlh', function() require 'config.editor_todo'.TodoLocList('HACK') end, M.opt 'TodoLocList HACK')
vim.keymap.set({ 'n', 'v', }, '<leader>tlw', function() require 'config.editor_todo'.TodoLocList(M.WARN) end, M.opt 'TodoLocList WARN')
vim.keymap.set({ 'n', 'v', }, '<leader>tlp', function() require 'config.editor_todo'.TodoLocList(M.PERF) end, M.opt 'TodoLocList PERF')
vim.keymap.set({ 'n', 'v', }, '<leader>tln', function() require 'config.editor_todo'.TodoLocList(M.NOTE) end, M.opt 'TodoLocList NOTE')
vim.keymap.set({ 'n', 'v', }, '<leader>tls', function() require 'config.editor_todo'.TodoLocList(M.TEST) end, M.opt 'TodoLocList TEST')

vim.keymap.set({ 'n', 'v', }, '<leader>te', function() require 'config.editor_todo'.open_todo_exclude_dirs_txt() end, M.opt 'open_todo_exclude_dirs_txt')

return M
