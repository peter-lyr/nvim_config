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
    { '<leader>bp', function() require('config.nvimtree-oftendirs').openpathdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree pathdirs open' },
    { '<leader>bt', function() require('config.nvimtree-oftendirs').explorer() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree oftendirs start' },
    { '<c-s-.>', function() require('config.nvimtree').nextdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree nextdir' },
    { '<c-s-,>', function() require('config.nvimtree').prevdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree prevdir' },
    { '<c-s-z>', function() require('config.nvimtree').lastdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree lastdir' },
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
