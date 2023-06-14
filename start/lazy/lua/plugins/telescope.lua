return {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  lazy = true,
  cmd = {
    'Telescope',
  },
  keys = {
    '<leader>sh',
    '<leader>sc',
    '<leader>sC',

    '<leader>so',
    '<leader>sf',
    '<leader>sb',
    '<leader>sB',

    '<leader>sl',
    '<leader>ss',
    '<leader>sz',

    '<leader>sq',
    '<leader>sQ',

    '<leader><leader>sa',
    '<leader><leader>sc',
    '<leader><leader>sd',
    '<leader><leader>sf',
    '<leader><leader>sh',
    '<leader><leader>sj',
    '<leader><leader>sm',
    '<leader><leader>so',
    '<leader><leader>sp',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('config.telescope')
  end
}
