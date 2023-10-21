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
        'L3MON4D3/LuaSnip',
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
        config = function()
          require 'config.cmp_snip'
        end,
      },
    },
  },
  config = function()
    require 'config.cmp'
  end,
}
