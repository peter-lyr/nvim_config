local S = require 'startup'

return {
  {
    'stevearc/aerial.nvim',
    lazy = true,
    event = { 'LspAttach', },
    keys = {
      { ']a', '<cmd>AerialNext<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialNext', },
      { '[a', '<cmd>AerialPrev<cr>', mode = { 'n', 'v', }, silent = true, desc = 'AerialPrev', },
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>a', 'stevearc/aerial.nvim', 'Sidepanel_Aerial')
      end
    end,
    config = function()
      require 'map.sidepanel_aerial'
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    commit = '00741206',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>a', 'nvim-tree/nvim-tree.lua', 'Sidepanel_Nvimtree')
      end
    end,
    config = function()
      require 'map.sidepanel_nvimtree'
    end,
  },
  {
    'echasnovski/mini.map',
    version = '*',
    event = { 'BufReadPost', 'BufNewFile', },
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>a', 'echasnovski/mini.map', 'Sidepanel_Minimap')
      end
    end,
    config = function()
      require 'map.sidepanel_minimap'
    end,
  },
  {
    'kevinhwang91/nvim-bqf',
    lazy = true,
    event = { 'QuickFixCmdPre', 'BufReadPost', 'BufNewFile', },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>d', 'kevinhwang91/nvim-bqf', 'Sidepanel_QuickFix')
      end
    end,
    config = function()
      require 'map.sidepanel_quickfix'
    end,
  },
}
