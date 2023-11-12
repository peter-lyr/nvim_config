local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
M.lua = string.match(M.config, '%.([^.]+)$')
--------------------------------------------

B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'nvim-tree/nvim-web-devicons'


function M.opt(desc)
  return { silent = true, desc = M.lua .. ' ' .. desc, }
end

vim.keymap.set({ 'n', 'v', }, '<leader>fl', function() require 'config.telescope'.lsp_document_symbols() end, M.opt 'lsp_document_symbols')
vim.keymap.set({ 'n', 'v', }, '<leader>fr', function() require 'config.telescope'.lsp_references() end, M.opt 'lsp_references')
vim.keymap.set({ 'n', 'v', }, '<leader>gf', function() require 'config.telescope'.git_status() end, M.opt 'git_status')
vim.keymap.set({ 'n', 'v', }, '<leader>gh', function() require 'config.telescope'.git_branches() end, M.opt 'git_branches')
vim.keymap.set({ 'n', 'v', }, '<leader>gtb', function() require 'config.telescope'.git_bcommits() end, M.opt 'git_bcommits')
vim.keymap.set({ 'n', 'v', }, '<leader>gtc', function() require 'config.telescope'.git_commits() end, M.opt 'git_commits')
vim.keymap.set({ 'n', 'v', }, '<leader>s<c-l>', function() require 'config.telescope'.live_grep_rg() end, M.opt 'live_grep_rg')
vim.keymap.set({ 'n', 'v', }, '<leader>s<leader>', function() require 'config.telescope'.find_files() end, M.opt 'find_files')
vim.keymap.set({ 'n', 'v', }, '<leader>sL', function() require 'config.telescope'.live_grep_def() end, M.opt 'live_grep_def')
vim.keymap.set({ 'n', 'v', }, '<leader>sO', function() require 'config.telescope'.open() end, M.opt 'open')
vim.keymap.set({ 'n', 'v', }, '<leader>sb', function() require 'config.telescope'.buffers() end, M.opt 'buffers')
vim.keymap.set({ 'n', 'v', }, '<leader>sc', function() require 'config.telescope'.command_history() end, M.opt 'command_history')
vim.keymap.set({ 'n', 'v', }, '<leader>sd', function() require 'config.telescope'.diagnostics() end, M.opt 'diagnostics')
vim.keymap.set({ 'n', 'v', }, '<leader>sf', function() require 'config.telescope'.filetypes() end, M.opt 'filetypes')
vim.keymap.set({ 'n', 'v', }, '<leader>sh', function() require 'config.telescope'.search_history() end, M.opt 'search_history')
vim.keymap.set({ 'n', 'v', }, '<leader>sj', function() require 'config.telescope'.jumplist() end, M.opt 'jumplist')
vim.keymap.set({ 'n', 'v', }, '<leader>sl', function() require 'config.telescope'.live_grep() end, M.opt 'live_grep')
vim.keymap.set({ 'n', 'v', }, '<leader>sm', function() require 'config.telescope'.keymaps() end, M.opt 'keymaps')
vim.keymap.set({ 'n', 'v', }, '<leader>sq', function() require 'config.telescope'.quickfix() end, M.opt 'quickfix')
vim.keymap.set({ 'n', 'v', }, '<leader>ss', function() require 'config.telescope'.grep_string() end, M.opt 'grep_string')
vim.keymap.set({ 'n', 'v', }, '<leader>sv<leader>', function() require 'config.telescope'.find_files_all() end, M.opt 'find_files_all')
vim.keymap.set({ 'n', 'v', }, '<leader>svb', function() require 'config.telescope'.buffers_cur() end, M.opt 'buffers_cur')
vim.keymap.set({ 'n', 'v', }, '<leader>svc', function() require 'config.telescope'.colorscheme() end, M.opt 'colorscheme')
vim.keymap.set({ 'n', 'v', }, '<leader>svc', function() require 'config.telescope'.commands() end, M.opt 'commands')
vim.keymap.set({ 'n', 'v', }, '<leader>svh', function() require 'config.telescope'.help_tags() end, M.opt 'help_tags')
vim.keymap.set({ 'n', 'v', }, '<leader>svl', function() require 'config.telescope'.live_grep_all() end, M.opt 'live_grep_all')
vim.keymap.set({ 'n', 'v', }, '<leader>svq', function() require 'config.telescope'.quickfixhistory() end, M.opt 'quickfixhistory')
vim.keymap.set({ 'n', 'v', }, '<leader>svva', function() require 'config.telescope'.builtin() end, M.opt 'builtin')
vim.keymap.set({ 'n', 'v', }, '<leader>svvo', function() require 'config.telescope'.vim_options() end, M.opt 'vim_options')
vim.keymap.set({ 'n', 'v', }, '<leader>svvp', function() require 'config.telescope'.planets() end, M.opt 'planets')
vim.keymap.set({ 'n', 'v', }, '<leader>sk', function() require 'config.telescope'.my_projects() end, M.opt 'my_projects')
vim.keymap.set({ 'n', 'v', }, '<leader>st', function() require 'config.telescope'.buffers_term() end, M.opt 'buffers_term')

-----------------------------------

vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f1>', function() require 'config.telescope'.git_status() end, M.opt 'git_status')
vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f2>', function() require 'config.telescope'.buffers_cur() end, M.opt 'buffers_cur')
vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f3>', function() require 'config.telescope'.find_files() end, M.opt 'find_files')
vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f4>', function() require 'config.telescope'.jumplist() end, M.opt 'jumplist')
vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f6>', function() require 'config.telescope'.command_history() end, M.opt 'command_history')
vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f7>', function() require 'config.telescope'.lsp_document_symbols() end, M.opt 'lsp_document_symbols')
vim.keymap.set({ 'n', 'v', }, '<c-s-f12><f8>', function() require 'config.telescope'.buffers() end, M.opt 'buffers')

vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f1>', function() require 'config.telescope'.nop() end, M.opt 'nop')
vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f2>', function() require 'config.telescope'.nop() end, M.opt 'nop')
vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f3>', function() require 'config.telescope'.nop() end, M.opt 'nop')
vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f4>', function() require 'config.telescope'.nop() end, M.opt 'nop')
vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f6>', function() require 'config.telescope'.nop() end, M.opt 'nop')
vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f7>', function() require 'config.telescope'.nop() end, M.opt 'nop')
vim.keymap.set_i({ 'n', 'v', }, '<c-s-f12><f8>', function() require 'config.telescope'.nop() end, M.opt 'nop')
-----------------------------------

B.register_whichkey('<leader>gt', 'Git more')
B.register_whichkey('<leader>sv', 'more')
B.register_whichkey('<leader>svv', 'more more')

B.merge_whichkeys()

return M
