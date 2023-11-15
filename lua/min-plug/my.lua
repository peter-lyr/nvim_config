return {
  {
    name = 'my_drag',
    dir = '',
    event = { 'VeryLazy', },
    lazy = false,
    dependencies = {
      'dstein64/vim-startuptime',
      'navarasu/onedark.nvim',
      'nvim-lua/plenary.nvim',
      'dbakker/vim-projectroot',
      'peter-lyr/vim-bbye',
      'peter-lyr/sha2',
      'rcarriga/nvim-notify',
      'folke/which-key.nvim',
    },
    config = function()
      require 'min-map.my_drag'
    end,
  },
  {
    name = 'options',
    dir = '',
    event = { 'VeryLazy', },
    lazy = false,
    config = function()
      require 'core.options'
    end,
  },
}
