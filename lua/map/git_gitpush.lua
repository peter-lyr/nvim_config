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

-------

vim.keymap.set({ 'n', 'v', }, '<leader>g<c-l>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.curline) end, M.opt 'addcommitpush curline')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-\'>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.single_quote) end, M.opt 'addcommitpush single_quote')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-s-\'>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.double_quote) end, M.opt 'addcommitpush double_quote')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-0>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.parentheses) end, M.opt 'addcommitpush parentheses')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-]>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.bracket) end, M.opt 'addcommitpush bracket')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-s-]>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.brace) end, M.opt 'addcommitpush brace')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-`>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.back_quote) end, M.opt 'addcommitpush back_quote')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-s-.>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.angle_bracket) end, M.opt 'addcommitpush angle_bracket')
vim.keymap.set({ 'n', 'v', }, 'g<c-l>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.curline) end, M.opt 'addcommitpush curline')
vim.keymap.set({ 'n', 'v', }, 'g<c-\'>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.single_quote) end, M.opt 'addcommitpush single_quote')
vim.keymap.set({ 'n', 'v', }, 'g<c-s-\'>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.double_quote) end, M.opt 'addcommitpush double_quote')
vim.keymap.set({ 'n', 'v', }, 'g<c-0>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.parentheses) end, M.opt 'addcommitpush parentheses')
vim.keymap.set({ 'n', 'v', }, 'g<c-]>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.bracket) end, M.opt 'addcommitpush bracket')
vim.keymap.set({ 'n', 'v', }, 'g<c-s-]>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.brace) end, M.opt 'addcommitpush brace')
vim.keymap.set({ 'n', 'v', }, 'g<c-`>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.back_quote) end, M.opt 'addcommitpush back_quote')
vim.keymap.set({ 'n', 'v', }, 'g<c-s-.>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.g.angle_bracket) end, M.opt 'addcommitpush angle_bracket')

vim.keymap.set({ 'n', 'v', }, '<leader>g<c-e>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.fn.expand '<cword>') end, M.opt 'addcommitpush cword')
vim.keymap.set({ 'n', 'v', }, '<leader>g<c-3>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.fn.expand '<cWORD>') end, M.opt 'addcommitpush cWORD')
vim.keymap.set({ 'n', 'v', }, 'g<c-e>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.fn.expand '<cword>') end, M.opt 'addcommitpush cword')
vim.keymap.set({ 'n', 'v', }, 'g<c-3>', function() require 'event.insertenter'.setreg() require 'config.git_gitpush'.addcommitpush(vim.fn.expand '<cWORD>') end, M.opt 'addcommitpush cWORD')

vim.keymap.set({ 'n', 'v', }, '<leader>ga', function() require 'config.git_gitpush'.addcommitpush() end, M.opt 'addcommitpush')
vim.keymap.set({ 'n', 'v', }, 'ga', function() require 'config.git_gitpush'.addcommitpush() end, M.opt 'addcommitpush')
vim.keymap.set({ 'n', 'v', }, '<leader>gc', function() require 'config.git_gitpush'.commit_push() end, M.opt 'commit_push')
vim.keymap.set({ 'n', 'v', }, '<leader>ggc', function() require 'config.git_gitpush'.commit() end, M.opt 'commit')
vim.keymap.set({ 'n', 'v', }, '<leader>ggs', function() require 'config.git_gitpush'.push() end, M.opt 'push')
vim.keymap.set({ 'n', 'v', }, '<leader>ggg', function() require 'config.git_gitpush'.graph() end, M.opt 'graph')
vim.keymap.set({ 'n', 'v', }, '<leader>ggv', function() require 'config.git_gitpush'.init() end, M.opt 'init')
vim.keymap.set({ 'n', 'v', }, '<leader>ggf', function() require 'config.git_gitpush'.pull() end, M.opt 'pull')
vim.keymap.set({ 'n', 'v', }, '<leader>gga', function() require 'config.git_gitpush'.addall() end, M.opt 'addall')
vim.keymap.set({ 'n', 'v', }, '<leader>ggr', function() require 'config.git_gitpush'.reset_hard() end, M.opt 'reset_hard')
vim.keymap.set({ 'n', 'v', }, '<leader>ggd', function() require 'config.git_gitpush'.reset_hard_clean() end, M.opt 'reset_hard_clean')
vim.keymap.set({ 'n', 'v', }, '<leader>ggC', function() require 'config.git_gitpush'.clone() end, M.opt 'clone')

return M
