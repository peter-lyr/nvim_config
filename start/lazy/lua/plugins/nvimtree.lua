return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  event = { 'FocusLost', },
  cmd = {
    'Git', -- fugitive
    'NvimTreeFindFile',
    'NvimTreeOpen',
  },
  keys = {
    { '<leader><tab>', '<cmd>NvimTreeFindFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'NvimTreeFindFile' },
    { '<leader>q', '<cmd>Git<cr>', mode = { 'n', 'v' }, desc = 'Git' }, -- fugitive
    { '<leader>be', function() require('config.nvimtree-oftendirs').open() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree oftendirs open' },
  },
  dependencies = {
    require('myplugins.core'),   -- terminal
    require('wait.projectroot'),
    require('plugins.fugitive'),
    require('plugins.edgy'),
    require('wait.plenary'),
  },
  config = function()
    require('config.nvimtree')
  end,
}
