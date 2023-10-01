return {
  'hrsh7th/nvim-cmp',
  lazy = true,
  version = false, -- last release is way too old
  event = 'InsertEnter',
  dependencies = {
    'LazyVim/LazyVim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
      'saadparwaiz1/cmp_luasnip',
      dependencies = {
        -- snippets
        'L3MON4D3/LuaSnip',
        dependencies = {
          'rafamadriz/friendly-snippets',
          dependencies = {
            require 'plugins.plenary',
          },
          config = function()
            require 'luasnip.loaders.from_vscode'.lazy_load()
            require 'luasnip.loaders.from_snipmate'.lazy_load {
              paths = {
                require 'plenary.path':new(vim.g.pack_path):joinpath('nvim_config', 'opt', 'snippets').filename,
              },
            }
            require 'luasnip'.config.setup {}
          end,
        },
        opts = {
          history = true,
          delete_check_events = 'TextChanged',
        },
      },
    },
  },
  config = function()
    require 'config.cmp'
  end,
}
