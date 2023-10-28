local M = {}
local B = require 'my_base'
M.source = B.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
-- package.loaded[M.loaded] = nil
--------------------------------------------

function M.ClangdSwitchSourceHeader()
  B.call_sub(M.loaded, 'funcs', 'ClangdSwitchSourceHeader')
end

function M.LspInfo()
  B.call_sub(M.loaded, 'funcs', 'LspInfo')
end

function M.LspRestart()
  B.call_sub(M.loaded, 'funcs', 'LspRestart')
end

function M.LspStart()
  B.call_sub(M.loaded, 'funcs', 'LspStart')
end

function M.code_action()
  B.call_sub(M.loaded, 'funcs', 'code_action')
end

function M.declaration()
  B.call_sub(M.loaded, 'funcs', 'declaration')
end

function M.definition()
  B.call_sub(M.loaded, 'funcs', 'definition')
end

function M.diagnostic_disable()
  B.call_sub(M.loaded, 'funcs', 'diagnostic_disable')
end

function M.diagnostic_enable()
  B.call_sub(M.loaded, 'funcs', 'diagnostic_enable')
end

function M.diagnostic_goto_next()
  B.call_sub(M.loaded, 'funcs', 'diagnostic_goto_next')
end

function M.diagnostic_goto_prev()
  B.call_sub(M.loaded, 'funcs', 'diagnostic_goto_prev')
end

function M.diagnostic_open_float()
  B.call_sub(M.loaded, 'funcs', 'diagnostic_open_float')
end

function M.diagnostic_setloclist()
  B.call_sub(M.loaded, 'funcs', 'diagnostic_setloclist')
end

function M.feedkeys_LspStop()
  B.call_sub(M.loaded, 'funcs', 'feedkeys_LspStop')
end

function M.format()
  B.call_sub(M.loaded, 'funcs', 'format')
end

function M.format_input()
  B.call_sub(M.loaded, 'funcs', 'format_input')
end

function M.format_paragraph()
  B.call_sub(M.loaded, 'funcs', 'format_paragraph')
end

function M.hover()
  B.call_sub(M.loaded, 'funcs', 'hover')
end

function M.implementation()
  B.call_sub(M.loaded, 'funcs', 'implementation')
end

function M.references()
  B.call_sub(M.loaded, 'funcs', 'references')
end

function M.rename()
  B.call_sub(M.loaded, 'funcs', 'rename')
end

function M.retab_erase_bad_white_space()
  B.call_sub(M.loaded, 'funcs', 'retab_erase_bad_white_space')
end

function M.signature_help()
  B.call_sub(M.loaded, 'funcs', 'signature_help')
end

function M.stop_all()
  B.call_sub(M.loaded, 'funcs', 'stop_all')
end

function M.type_definition()
  B.call_sub(M.loaded, 'funcs', 'type_definition')
end

--------------

function M.lua()
  B.call_sub(M.loaded, 'event', 'lua')
end

function M.python()
  B.call_sub(M.loaded, 'event', 'python')
end

function M.c()
  B.call_sub(M.loaded, 'event', 'c')
end

function M.markdown()
  B.call_sub(M.loaded, 'event', 'markdown')
end

-- function M.update_lua_libraries()
--   B.call_sub(M.loaded, 'event_lua', 'update_lua_libraries')
-- end

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

B.aucmd(M.source, 'LspAttach', { 'LspAttach', }, {
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
