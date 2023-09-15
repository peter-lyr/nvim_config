return {
  'nvim-treesitter/nvim-treesitter',
  lazy = true,
  tag = 'v0.9.1',
  commit = '63260da1',
  pin = true,
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile', },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    'p00f/nvim-ts-rainbow',
    'andymass/vim-matchup',
  },
  config = function()
    require 'config.treesitter'
  end,
}
