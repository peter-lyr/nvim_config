local S = require 'startup'

return {
  {
    -- 'lewis6991/gitsigns.nvim',
    'peter-lyr/gitsigns.nvim',
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile', },
    keys = {
      { 'ig',        ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x', }, silent = true, desc = 'Gitsigns select_hunk', },
      { 'ag',        ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x', }, silent = true, desc = 'Gitsigns select_hunk', },
      { '<leader>j', desc = 'Gitsigns next_hunk', },
      { '<leader>k', desc = 'Gitsigns prev_hunk', },
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>g', 'lewis6991/gitsigns.nvim', 'Git_Gitsigns')
      end
    end,
    config = function()
      require 'map.git_gitsigns'
    end,
  },
  {
    name = 'gitpush',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>g', 'gitpush', 'Git_GitPush')
      end
    end,
    config = function()
      require 'map.git_gitpush'
    end,
  },
  {
    'tpope/vim-fugitive',
    lazy = true,
    cmd = {
      'Git',
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>a', 'tpope/vim-fugitive', 'Git_Fugitive')
      end
    end,
    config = function()
      require 'map.git_fugitive'
    end,
  },
  {
    'sindrets/diffview.nvim',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>g', 'sindrets/diffview.nvim', 'Git_Diffview')
      end
    end,
    config = function()
      require 'map.git_diffview'
    end,
  },
}
