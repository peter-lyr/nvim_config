return {
  'nvim-neo-tree/neo-tree.nvim',
  lazy = true,
  branch = 'v2.x',
  cmd = {
    'Neotree',
  },
  keys = {
    { '<leader>wf', '<cmd>Neotree filesystem toggle reveal_force_cwd<cr>', mode = { 'n', 'v' }, desc = 'NeoTree' },
    { '<leader>wg', '<cmd>Neotree git_status toggle reveal_force_cwd float<cr>', mode = { 'n', 'v' }, desc = 'NeoTree' },
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
