return {
  'neovim/nvim-lspconfig',
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    {
      'williamboman/mason.nvim',
      opts = {
        install_root_dir = vim.fn.expand('$VIMRUNTIME') .. '\\pack\\data\\mason',
      },
    },
    {
      'williamboman/mason-lspconfig.nvim',
      opts = {
        ensure_installed = {
          'clangd',
          'pyright',
          'lua_ls',
          'marksman',
          'vimls'
        }
      },
    },
    require('plugins.cmp'),
    'folke/neodev.nvim',
    {
        "smjonas/inc-rename.nvim",
        config = function()
          require("inc_rename").setup()
        end,
    },
  },
  ft = {
    'c', 'cpp',
    'python',
    'md',
    'lua',
    'vim',
  },
  config = function()
    require('config.lsp')
  end,
}
