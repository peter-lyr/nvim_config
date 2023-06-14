return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  branch = 'v2.x',
  cmd = {
    'Neotree',
  },
  keys = {
    { '<leader>wn', '<cmd>Neotree toggle<cr>', mode = { 'n', 'v' }, desc = 'NeoTree' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  config = function()
    require('config.neotree')
  end
}
