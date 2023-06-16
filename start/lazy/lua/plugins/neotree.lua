return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  branch = 'v2.x',
  event = {
    'CursorMoved'
  },
  cmd = {
    'Neotree',
  },
  keys = {
    { '<leader>q',             '<cmd>Neotree filesystem focus  reveal_force_cwd<cr>',       mode = { 'n', 'v' }, desc = 'NeoTree filesystem' },
    { '<leader><tab>',         '<cmd>Neotree buffers    toggle reveal_force_cwd right<cr>', mode = { 'n', 'v' }, desc = 'NeoTree buffers' },
    { '<leader><leader><tab>', '<cmd>Neotree git_status toggle reveal_force_cwd right<cr>', mode = { 'n', 'v' }, desc = 'NeoTree git_status' },
  },
  dependencies = {
    require('plugins.plenary'),
    require('plugins.web-devicons'),
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
  },
  config = function()
    require('config.neotree')
  end
}
