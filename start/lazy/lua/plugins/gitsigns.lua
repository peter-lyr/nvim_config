return {
  'lewis6991/gitsigns.nvim',
  lazy = true,
  cmd = {
    'Gitsigns',
  },
  keys = {
    '<leader>j',
    '<leader>k',
  },
  config = function()
    require('config.gitsigns')
  end
}
