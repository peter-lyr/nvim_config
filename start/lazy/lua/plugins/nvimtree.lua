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
    { '<leader>bt', function() require('config.nvimtree-oftendirs').explorer() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree oftendirs start' },
  },
  dependencies = {
    require('myplugins.core'),   -- terminal
    require('plugins.edgy'),
    require('plugins.fugitive'),
    require('wait.plenary'),
    require('wait.projectroot'),
  },
  config = function()
    require('config.nvimtree')
  end,
}
