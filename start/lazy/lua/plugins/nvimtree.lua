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
    { '<leader>se', function() require('config.nvimtree-oftendirs').open() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree oftendirs open' },
    { '<leader>sp', function() require('config.nvimtree-oftendirs').openpathdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree pathdirs open' },
    { '<leader>st', function() require('config.nvimtree-oftendirs').explorer() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree oftendirs start' },
    { 'qj', function() require('config.nvimtree').nextdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree nextdir' },
    { 'qk', function() require('config.nvimtree').prevdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree prevdir' },
    { 'qq', function() require('config.nvimtree').lastdir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree lastdir' },
    { 'ql', function() require('config.nvimtree').seldir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree seldir' },
    { 'qh', function() require('config.nvimtree').selolddir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree selolddir' },
    { 'qH', function() require('config.nvimtree').delolddir() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree delolddir' },
  },
  dependencies = {
    require('myplugins.core'),   -- terminal
    require('plugins.edgy'),
    require('plugins.fugitive'),
    require('plugins.treesitter'),
    require('wait.plenary'),
    require('wait.projectroot'),
  },
  config = function()
    require('config.nvimtree')
  end,
}
