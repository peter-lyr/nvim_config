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

    -- FIX  = {
    -- TODO = { icon = " ", color = "info" },
    -- HACK = { icon = " ", color = "warning" },
    -- WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    -- PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    -- TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },

vim.keymap.set({ 'n', 'v', }, '<leader>tqf', function() require 'config.editor_todo'.TodoQuickFix('FIX' ) end, M.opt 'TodoQuickFix FIX')
vim.keymap.set({ 'n', 'v', }, '<leader>tqt', function() require 'config.editor_todo'.TodoQuickFix('TODO') end, M.opt 'TodoQuickFix TODO')
vim.keymap.set({ 'n', 'v', }, '<leader>tqh', function() require 'config.editor_todo'.TodoQuickFix('HACK') end, M.opt 'TodoQuickFix HACK')
vim.keymap.set({ 'n', 'v', }, '<leader>tqw', function() require 'config.editor_todo'.TodoQuickFix('WARN') end, M.opt 'TodoQuickFix WARN')
vim.keymap.set({ 'n', 'v', }, '<leader>tqp', function() require 'config.editor_todo'.TodoQuickFix('PERF') end, M.opt 'TodoQuickFix PERF')
vim.keymap.set({ 'n', 'v', }, '<leader>tqn', function() require 'config.editor_todo'.TodoQuickFix('NOTE') end, M.opt 'TodoQuickFix NOTE')
vim.keymap.set({ 'n', 'v', }, '<leader>tqs', function() require 'config.editor_todo'.TodoQuickFix('TEST') end, M.opt 'TodoQuickFix TEST')

vim.keymap.set({ 'n', 'v', }, '<leader>ttf', function() require 'config.editor_todo'.TodoTelescope('FIX' ) end, M.opt 'TodoTelescope FIX')
vim.keymap.set({ 'n', 'v', }, '<leader>ttt', function() require 'config.editor_todo'.TodoTelescope('TODO') end, M.opt 'TodoTelescope TODO')
vim.keymap.set({ 'n', 'v', }, '<leader>tth', function() require 'config.editor_todo'.TodoTelescope('HACK') end, M.opt 'TodoTelescope HACK')
vim.keymap.set({ 'n', 'v', }, '<leader>ttw', function() require 'config.editor_todo'.TodoTelescope('WARN') end, M.opt 'TodoTelescope WARN')
vim.keymap.set({ 'n', 'v', }, '<leader>ttp', function() require 'config.editor_todo'.TodoTelescope('PERF') end, M.opt 'TodoTelescope PERF')
vim.keymap.set({ 'n', 'v', }, '<leader>ttn', function() require 'config.editor_todo'.TodoTelescope('NOTE') end, M.opt 'TodoTelescope NOTE')
vim.keymap.set({ 'n', 'v', }, '<leader>tts', function() require 'config.editor_todo'.TodoTelescope('TEST') end, M.opt 'TodoTelescope TEST')

vim.keymap.set({ 'n', 'v', }, '<leader>tlf', function() require 'config.editor_todo'.TodoLocList('FIX' ) end, M.opt 'TodoLocList FIX')
vim.keymap.set({ 'n', 'v', }, '<leader>tlt', function() require 'config.editor_todo'.TodoLocList('TODO') end, M.opt 'TodoLocList TODO')
vim.keymap.set({ 'n', 'v', }, '<leader>tlh', function() require 'config.editor_todo'.TodoLocList('HACK') end, M.opt 'TodoLocList HACK')
vim.keymap.set({ 'n', 'v', }, '<leader>tlw', function() require 'config.editor_todo'.TodoLocList('WARN') end, M.opt 'TodoLocList WARN')
vim.keymap.set({ 'n', 'v', }, '<leader>tlp', function() require 'config.editor_todo'.TodoLocList('PERF') end, M.opt 'TodoLocList PERF')
vim.keymap.set({ 'n', 'v', }, '<leader>tln', function() require 'config.editor_todo'.TodoLocList('NOTE') end, M.opt 'TodoLocList NOTE')
vim.keymap.set({ 'n', 'v', }, '<leader>tls', function() require 'config.editor_todo'.TodoLocList('TEST') end, M.opt 'TodoLocList TEST')

vim.keymap.set({ 'n', 'v', }, '<leader>te', function() require 'config.editor_todo'.open_todo_exclude_dirs_txt() end, M.opt 'open_todo_exclude_dirs_txt')

return M
