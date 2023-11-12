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

vim.keymap.set({ 'n', 'v', }, '<leader>fC', function() require 'config.nvim_lsp'.format_input() end, M.opt 'format_input')
vim.keymap.set({ 'n', 'v', }, '<leader>fD', function() require 'config.nvim_lsp'.feedkeys_LspStop() end, M.opt 'feedkeys_LspStop')
vim.keymap.set({ 'n', 'v', }, '<leader>fF', function() require 'config.nvim_lsp'.LspInfo() end, M.opt 'LspInfo')
vim.keymap.set({ 'n', 'v', }, '<leader>fR', function() require 'config.nvim_lsp'.LspRestart() end, M.opt 'LspRestart')
vim.keymap.set({ 'n', 'v', }, '<leader>fS', function() require 'config.nvim_lsp'.LspStart() end, M.opt 'LspStart')
vim.keymap.set({ 'n', 'v', }, '<leader>fW', function() require 'config.nvim_lsp'.stop_all() end, M.opt 'stop_all')
vim.keymap.set({ 'n', 'v', }, '<leader>fc', function() require 'config.nvim_lsp'.code_action() end, M.opt 'code_action')
vim.keymap.set({ 'n', 'v', }, '<leader>ff', function() require 'config.nvim_lsp'.format() end, M.opt 'format')
vim.keymap.set({ 'n', 'v', }, '<leader>fi', function() require 'config.nvim_lsp'.implementation() end, M.opt 'implementation')
vim.keymap.set({ 'n', 'v', }, '<leader>fn', function() require 'config.nvim_lsp'.rename() end, M.opt 'rename')
vim.keymap.set({ 'n', 'v', }, '<leader>fp', function() require 'config.nvim_lsp'.format_paragraph() end, M.opt 'format_paragraph')
vim.keymap.set({ 'n', 'v', }, '<leader>fq', function() require 'config.nvim_lsp'.diagnostic_enable() end, M.opt 'diagnostic_enable')
vim.keymap.set({ 'n', 'v', }, '<leader>fs', function() require 'config.nvim_lsp'.signature_help() end, M.opt 'signature_help')
vim.keymap.set({ 'n', 'v', }, '<leader>fvd', function() require 'config.nvim_lsp'.type_definition() end, M.opt 'type_definition')
vim.keymap.set({ 'n', 'v', }, '<leader>fve', function() require 'config.nvim_lsp'.retab_erase_bad_white_space() end, M.opt 'retab_erase_bad_white_space')
vim.keymap.set({ 'n', 'v', }, '<leader>fvq', function() require 'config.nvim_lsp'.diagnostic_disable() end, M.opt 'diagnostic_disable')

vim.keymap.set({ 'n', 'v', }, '[d', function() require 'config.nvim_lsp'.diagnostic_goto_prev() end, M.opt 'diagnostic_goto_prev')
vim.keymap.set({ 'n', 'v', }, '[f', function() require 'config.nvim_lsp'.diagnostic_open_float() end, M.opt 'diagnostic_open_float')
vim.keymap.set({ 'n', 'v', }, ']d', function() require 'config.nvim_lsp'.diagnostic_goto_next() end, M.opt 'iagnostic_goto_next')
vim.keymap.set({ 'n', 'v', }, ']f', function() require 'config.nvim_lsp'.diagnostic_setloclist() end, M.opt 'diagnostic_setloclist')

vim.keymap.set({ 'n', 'v', }, '<A-F12>', function() require 'config.nvim_lsp'.hover() end, M.opt 'hover')
vim.keymap.set({ 'n', 'v', }, '<C-F12>', function() require 'config.nvim_lsp'.declaration() end, M.opt 'declaration')
vim.keymap.set({ 'n', 'v', }, '<F11>', function() require 'config.nvim_lsp'.ClangdSwitchSourceHeader() end, M.opt 'ClangdSwitchSourceHeader')
vim.keymap.set({ 'n', 'v', }, '<F12>', function() require 'config.nvim_lsp'.definition() end, M.opt 'definition')
vim.keymap.set({ 'n', 'v', }, '<S-F12>', function() require 'config.nvim_lsp'.references() end, M.opt 'references')
vim.keymap.set({ 'n', 'v', }, '<leader>fd', function() require 'config.nvim_lsp'.declaration() end, M.opt 'declaration')
vim.keymap.set({ 'n', 'v', }, '<leader>fe', function() require 'config.nvim_lsp'.references() end, M.opt 'references')
vim.keymap.set({ 'n', 'v', }, '<leader>fh', function() require 'config.nvim_lsp'.hover() end, M.opt 'hover')
vim.keymap.set({ 'n', 'v', }, '<leader>fo', function() require 'config.nvim_lsp'.definition() end, M.opt 'definition')
vim.keymap.set({ 'n', 'v', }, '<leader>fw', function() require 'config.nvim_lsp'.ClangdSwitchSourceHeader() end, M.opt 'ClangdSwitchSourceHeader')

-----------------

B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'williamboman/mason.nvim'
B.load_require 'jose-elias-alvarez/null-ls.nvim'
B.load_require 'jay-babu/mason-null-ls.nvim'
B.load_require 'williamboman/mason-lspconfig.nvim'
B.load_require 'folke/neodev.nvim'
B.load_require 'smjonas/inc-rename.nvim'
B.load_require 'LazyVim/LazyVim'

-----------------

M.loaded_lua = nil
M.loaded_c = nil
M.loaded_python = nil
M.loaded_markdown = nil

M.au = B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    local ext = vim.fn.tolower(string.match(ev.file, '%.([^.]+)$'))
    if ext == 'lua' and not M.loaded_lua then
      require('config.nvim_lsp').lua()
      M.loaded_lua = 1
      vim.cmd 'e!'
    elseif ext == 'py' and not M.loaded_python then
      require('config.nvim_lsp').python()
      M.loaded_python = 1
      vim.cmd 'e!'
    elseif (ext == 'c' or ext == 'h') and not M.loaded_c then
      require('config.nvim_lsp').c()
      M.loaded_c = 1
      vim.cmd 'e!'
    elseif ext == 'md' and not M.loaded_markdown then
      require('config.nvim_lsp').markdown()
      M.loaded_markdown = 1
      vim.cmd 'e!'
    end
    if M.loaded_lua and M.loaded_c and M.loaded_python and M.loaded_markdown then
      pcall(vim.api.nvim_del_autocmd, M.au)
    end
  end,
})

return M
