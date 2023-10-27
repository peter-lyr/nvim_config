local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.config = B.rep_map_to_config(M.loaded)
-- package.loaded[M.loaded] = nil
--------------------------------------------

B.load_require 'nvim-lua/plenary.nvim'
B.load_require 'williamboman/mason.nvim'
B.load_require 'jose-elias-alvarez/null-ls.nvim'
B.load_require 'jay-babu/mason-null-ls.nvim'
B.load_require 'williamboman/mason-lspconfig.nvim'
B.load_require 'folke/neodev.nvim'
B.load_require 'smjonas/inc-rename.nvim'
B.load_require 'LazyVim/LazyVim'
-- B.load_require 'cmp'

B.map_set_lua(M.config)

B.map('<leader>fC', 'format_input', {})
B.map('<leader>fD', 'feedkeys_LspStop', {})
B.map('<leader>fF', 'LspInfo', {})
B.map('<leader>fR', 'LspRestart', {})
B.map('<leader>fS', 'LspStart', {})
B.map('<leader>fW', 'stop_all', {})
B.map('<leader>fc', 'code_action', {})
B.map('<leader>ff', 'format', {})
B.map('<leader>fi', 'implementation', {})
B.map('<leader>fn', 'rename', {})
B.map('<leader>fp', 'format_paragraph', {})
B.map('<leader>fq', 'diagnostic_enable', {})
B.map('<leader>fs', 'signature_help', {})
B.map('<leader>fvd', 'type_definition', {})
B.map('<leader>fve', 'retab_erase_bad_white_space', {})
B.map('<leader>fvq', 'diagnostic_disable', {})

B.map('[d', 'diagnostic_goto_prev', {})
B.map('[f', 'diagnostic_open_float', {})
B.map(']d', 'diagnostic_goto_next', {})
B.map(']f', 'diagnostic_setloclist', {})

B.map('<A-F12>', 'hover', {})
B.map('<C-F12>', 'declaration', {})
B.map('<F11>', 'ClangdSwitchSourceHeader', {})
B.map('<F12>', 'definition', {})
B.map('<S-F12>', 'references', {})
B.map('<leader>fd', 'declaration', {})
B.map('<leader>fe', 'references', {})
B.map('<leader>fh', 'hover', {})
B.map('<leader>fo', 'definition', {})
B.map('<leader>fw', 'ClangdSwitchSourceHeader', {})

B.map_reset_opts()

-----------------

M.loaded_lua = nil
M.loaded_c = nil
M.loaded_python = nil
M.loaded_markdown = nil

M.au = B.aucmd(M.source, 'BufEnter', 'BufEnter', {
  callback = function(ev)
    local ext = vim.fn.tolower(string.match(ev.file, '%.([^.]+)$'))
    if ext == 'lua' and not M.loaded_lua then
      require(M.config).lua()
      M.loaded_lua = 1
    elseif ext == 'python' and not M.loaded_python then
      require(M.config).python()
      M.loaded_python = 1
    elseif ext == 'c' and not M.loaded_c then
      require(M.config).c()
      M.loaded_c = 1
    elseif ext == 'md' and not M.loaded_markdown then
      require(M.config).markdown()
      M.loaded_markdown = 1
    end
    if M.loaded_lua and M.loaded_c and M.loaded_python and M.loaded_markdown then
      pcall(vim.api.nvim_del_autocmd, M.au)
    end
  end,
})

return M
