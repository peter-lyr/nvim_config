local M = {}
local B = require 'my_base'
B.load_require_common()
M.source = require 'my_base'.get_source(debug.getinfo(1)['source'])
M.loaded = B.get_loaded(M.source)
M.lua = string.match(M.loaded, '%.([^.]+)$')
--------------------------------------------

function M.stop_all()
  vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
end

function M.rename()
  vim.fn.feedkeys(':IncRename ' .. vim.fn.expand '<cword>')
end

-- clang-format nedd to check pyvenv.cfg

function M.format()
  vim.lsp.buf.format {
    async = true,
    filter = function(client)
      return client.name ~= 'clangd'
    end,
  }
end

function M.format_paragraph()
  local save_cursor = vim.fn.getpos '.'
  vim.cmd 'norm =ap'
  pcall(vim.fn.setpos, '.', save_cursor)
end

function M.format_input()
  local dirs = B.get_file_dirs_till_git()
  for _, dir in ipairs(dirs) do
    local _clang_format_path = require 'plenary.path':new(B.rep_slash_lower(dir)):joinpath('.clang-format')
    if _clang_format_path:exists() then
      B.cmd('e %s', _clang_format_path.filename)
      break
    end
  end
end

function M.diagnostic_open_float()
  vim.diagnostic.open_float()
end

function M.diagnostic_setloclist()
  vim.diagnostic.setloclist()
end

function M.diagnostic_goto_prev()
  vim.diagnostic.goto_prev()
end

function M.diagnostic_goto_next()
  vim.diagnostic.goto_next()
end

function M.diagnostic_enable()
  vim.diagnostic.enable()
end

function M.diagnostic_disable()
  vim.diagnostic.disable()
end

function M.definition()
  vim.lsp.buf.definition()
end

function M.declaration()
  vim.lsp.buf.declaration()
end

function M.hover()
  vim.lsp.buf.hover()
end

function M.implementation()
  vim.lsp.buf.implementation()
end

function M.signature_help()
  vim.lsp.buf.signature_help()
end

function M.references()
  vim.lsp.buf.references()
end

function M.type_definition()
  vim.lsp.buf.type_definition()
end

function M.code_action()
  vim.lsp.buf.code_action()
end

function M.LspStart()
  vim.cmd 'LspStart'
end

function M.LspRestart()
  vim.cmd 'LspRestart'
end

function M.LspInfo()
  vim.cmd 'LspInfo'
end

function M.feedkeys_LspStop()
  vim.fn.feedkeys ':LspStop '
end

function M.ClangdSwitchSourceHeader()
  vim.cmd 'ClangdSwitchSourceHeader'
end

function M.retab_erase_bad_white_space()
  vim.cmd 'retab'
  vim.cmd [[%s/\s\+$//]]
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
      -- extra_args = {
      --   '--style',
      --   '{BasedOnStyle: llvm, IndentWidth: 4, SortIncludes: false, ColumnLimit: 200}',
      -- },
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
