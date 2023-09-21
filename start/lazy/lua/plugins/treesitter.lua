return {
  'nvim-treesitter/nvim-treesitter',
  lazy = true,
  version = '*', -- last release
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile', },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
    'p00f/nvim-ts-rainbow',
    {
      'andymass/vim-matchup',
      config = function()
        vim.g.matchup_matchparen_offscreen = {}
      end,
    },
  },
  config = function()
    require 'config.treesitter'
  end,
}
