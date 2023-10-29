local S = require 'startup'

return {
  {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    commit = '79127db3b127f5d125f35e0d44ba60715edf2842',
    event = { 'BufReadPre', 'BufNewFile', },
    keys = {
      { 'ig',        ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x', }, silent = true, desc = 'Gitsigns select_hunk', },
      { 'ag',        ':<C-U>Gitsigns select_hunk<CR>', mode = { 'o', 'x', }, silent = true, desc = 'Gitsigns select_hunk', },
      { '<leader>j', desc = 'Gitsigns next_hunk', },
      { '<leader>k', desc = 'Gitsigns prev_hunk', },
    },
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>g', 'lewis6991/gitsigns.nvim', 'Gitsigns')
      end
    end,
    config = function()
      require 'map.gitsigns'
    end,
  },
  {
    name = 'gitpush',
    dir = '',
    lazy = true,
    init = function()
      if not S.load_whichkeys_txt_enable then
        require 'my_simple'.add_whichkey('<leader>g', 'gitpush', 'GitPush')
      end
    end,
    config = function()
      require 'map.gitpush'
    end,
  },
}
