return {
  'neovim/nvim-lspconfig',
  lazy = true,
  ft = {
    'c', 'cpp',
    'python',
    'md',
    'lua',
    'vim',
  },
  cmd = {
    'LspInfo', 'LspInstall', 'LspLog', 'LspRestart', 'LspStart', 'LspStop',
    'Mason',
  },
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = {
        install_root_dir = vim.fn.expand '$VIMRUNTIME' .. '\\pack\\data\\mason',
      },
    },
    {
      'jay-babu/mason-null-ls.nvim',
      config = function()
        require 'mason-null-ls'.setup {
          ensure_installed = {
            'black', 'isort',        -- python
            'markdownlint',
            'prettier', 'prettierd', -- html
            'clang_format',          -- clang_format
          },
          automatic_installation = false,
        }
      end,
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
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
      end,
    },
    {
      'williamboman/mason-lspconfig.nvim',
      opts = {
        ensure_installed = {
          'clangd',
          'pyright',
          'lua_ls',
          'marksman',
          'vimls',
        },
      },
    },
    require 'plugins.cmp',
    {
      'folke/neodev.nvim',
      config = function()
        require 'neodev'.setup()
      end,
    },
    {
      'smjonas/inc-rename.nvim',
      config = function()
        require 'inc_rename'.setup()
      end,
    },
  },
  init = function()
    require 'which-key'.register { ['<leader>f'] = { name = 'Lsp', }, }
  end,
  config = function()
    require 'config.lsp'
  end,
}
