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
    { '<leader>1', '<cmd>NvimTreeFindFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'NvimTreeFindFile' },
    { '<leader>2', function() require('config.fugitive').open() end, mode = { 'n', 'v', }, silent = true, desc = 'Git' },
    { '<leader>sem',  function() require('config.nvimtree-oftendirs').open_mydirs() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_mydirs' },
    { '<leader>serm', function() require('config.nvimtree-oftendirs').reopen_mydirs() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree reopen_mydirs' },
    { '<leader>sep',  function() require('config.nvimtree-oftendirs').open_pathdirs() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_pathdirs' },
    { '<leader>se[', function() require('config.nvimtree-oftendirs').open_pathfiles() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_pathfiles' },
    { '<leader>seo', function() require('config.nvimtree-oftendirs').open_oftendirs() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_oftendirs' },
    { '<leader>see',  function() require('config.nvimtree-oftendirs').explorer() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree explorer all dirs' },
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
