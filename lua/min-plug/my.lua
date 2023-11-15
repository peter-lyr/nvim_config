return {
  {
    name = 'my_drag',
    dir = '',
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
}
