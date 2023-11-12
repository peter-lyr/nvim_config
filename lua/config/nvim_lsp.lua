local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.ClangdSwitchSourceHeader()
  require 'config.nvim_lsp_funcs'.ClangdSwitchSourceHeader()
end

function M.LspInfo()
  require 'config.nvim_lsp_funcs'.LspInfo()
end

function M.LspRestart()
  require 'config.nvim_lsp_funcs'.LspRestart()
end

function M.LspStart()
  require 'config.nvim_lsp_funcs'.LspStart()
end

function M.code_action()
  require 'config.nvim_lsp_funcs'.code_action()
end

function M.declaration()
  require 'config.nvim_lsp_funcs'.declaration()
end

function M.definition()
  require 'config.nvim_lsp_funcs'.definition()
end

function M.diagnostic_disable()
  require 'config.nvim_lsp_funcs'.diagnostic_disable()
end

function M.diagnostic_enable()
  require 'config.nvim_lsp_funcs'.diagnostic_enable()
end

function M.diagnostic_goto_next()
  require 'config.nvim_lsp_funcs'.diagnostic_goto_next()
end

function M.diagnostic_goto_prev()
  require 'config.nvim_lsp_funcs'.diagnostic_goto_prev()
end

function M.diagnostic_open_float()
  require 'config.nvim_lsp_funcs'.diagnostic_open_float()
end

function M.diagnostic_setloclist()
  require 'config.nvim_lsp_funcs'.diagnostic_setloclist()
end

function M.feedkeys_LspStop()
  require 'config.nvim_lsp_funcs'.feedkeys_LspStop()
end

function M.format()
  require 'config.nvim_lsp_funcs'.format()
end

function M.format_input()
  require 'config.nvim_lsp_funcs'.format_input()
end

function M.format_paragraph()
  require 'config.nvim_lsp_funcs'.format_paragraph()
end

function M.hover()
  require 'config.nvim_lsp_funcs'.hover()
end

function M.implementation()
  require 'config.nvim_lsp_funcs'.implementation()
end

function M.references()
  require 'config.nvim_lsp_funcs'.references()
end

function M.rename()
  require 'config.nvim_lsp_funcs'.rename()
end

function M.retab_erase_bad_white_space()
  require 'config.nvim_lsp_funcs'.retab_erase_bad_white_space()
end

function M.signature_help()
  require 'config.nvim_lsp_funcs'.signature_help()
end

function M.stop_all()
  require 'config.nvim_lsp_funcs'.stop_all()
end

function M.type_definition()
  require 'config.nvim_lsp_funcs'.type_definition()
end

--------------

function M.lua()
  require 'config.nvim_lsp_event'.lua()
end

function M.python()
  require 'config.nvim_lsp_event'.python()
end

function M.c()
  require 'config.nvim_lsp_event'.c()
end

function M.markdown()
  require 'config.nvim_lsp_event'.markdown()
end

------------------

M.mason_dir_path = B.get_std_data_dir_path 'mason'

if not M.mason_dir_path:exists() then
  vim.fn.mkdir(M.mason_dir_path.filename)
end

require 'mason'.setup {
  install_root_dir = M.mason_dir_path.filename,
}

------------------

require 'mason-null-ls'.setup {
  ensure_installed = {
    'black', 'isort', -- python
    'markdownlint',
    'clang_format',   -- clang_format
    -- 'prettier', 'prettierd', -- html
  },
  automatic_installation = false,
}

local nls = require 'null-ls'

nls.setup {
  sources = {
    nls.builtins.formatting.black.with { extra_args = { '--fast', }, filetypes = { 'python', }, },
    nls.builtins.formatting.isort.with { extra_args = { '--profile', 'black', }, filetypes = { 'python', }, },
    nls.builtins.diagnostics.markdownlint.with { extra_args = { '-r', '~MD013', }, filetypes = { 'markdown', }, },
    nls.builtins.formatting.prettier.with {
      filetypes = { 'solidity', },
      timeout = 10000,
    },
    nls.builtins.formatting.prettierd.with {
      -- condition = function(utils)
      --   return not utils.root_has_file { ".eslintrc", ".eslintrc.js" }
      -- end,
      prefer_local = 'node_modules/.bin',
    },
    nls.builtins.formatting.clang_format.with {
      filetypes = {
        'c',
        'cpp',
        '*.h',
      },
      extra_args = {
        '--style',
        '{BasedOnStyle: llvm, IndentWidth: 4, SortIncludes: false, ColumnLimit: 200}',
      },
    },
  },
}

require 'mason-lspconfig'.setup {
  ensure_installed = {
    'clangd',
    'pyright',
    'lua_ls',
    'marksman',
  },
}

require 'inc_rename'.setup()

B.aucmd(M.lua, 'LspAttach', { 'LspAttach', }, {
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = function(desc)
      return { buffer = ev.buf, desc = desc, }
    end
    vim.keymap.set({ 'n', 'v', }, 'K', vim.lsp.buf.definition, opts 'vim.lsp.buf.definition')
  end,
})

for name, icon in pairs(require 'lazyvim.config'.icons.diagnostics) do
  name = 'DiagnosticSign' .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '', })
end

M.diagnostics = {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 0,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
}

vim.diagnostic.config(M.diagnostics)

return M
