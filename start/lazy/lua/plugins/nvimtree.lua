return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  event = { 'FocusLost', },
  keys = {
    { '<leader><tab>', '<cmd>NvimTreeFindFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'NvimTreeFindFile' },
  },
  dependencies = {
    require('myplugins.core'),   -- terminal
    require('wait.projectroot'),
    require('plugins.edgy'),
  },
  config = function()
    require('config.nvimtree')
  end,
}
