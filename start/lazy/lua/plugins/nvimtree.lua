return {
  'nvim-tree/nvim-tree.lua',
  commit = '00741206',
  lazy = true,
  cmd = {
    'NvimTreeFindFile',
    'NvimTreeOpen',
  },
  keys = {
    { '<leader>af',   function() require 'config.nvimtree'.findfile() end,                 mode = { 'n', 'v', }, silent = true, desc = 'NvimTree findfile', },
    { '<leader>ao',   function() require 'config.nvimtree'.open() end,                     mode = { 'n', 'v', }, silent = true, desc = 'NvimTree open', },
    { '<leader>aO',   function() require 'config.nvimtree'.restart() end,                  mode = { 'n', 'v', }, silent = true, desc = 'NvimTree restart', },
    { '<leader>ac',   function() require 'config.nvimtree'.close() end,                    mode = { 'n', 'v', }, silent = true, desc = 'NvimTree close', },
    { '<leader>aem',  function() require 'config.nvimtree_oftendirs'.open_mydirs() end,    mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_mydirs', },
    { '<leader>aerm', function() require 'config.nvimtree_oftendirs'.reopen_mydirs() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvimtree reopen_mydirs', },
    { '<leader>aep',  function() require 'config.nvimtree_oftendirs'.open_pathdirs() end,  mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_pathdirs', },
    { '<leader>aef',  function() require 'config.nvimtree_oftendirs'.open_pathfiles() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_pathfiles', },
    { '<leader>aeo',  function() require 'config.nvimtree_oftendirs'.open_oftendirs() end, mode = { 'n', 'v', }, silent = true, desc = 'nvimtree open_oftendirs', },
    { '<leader>aee',  function() require 'config.nvimtree_oftendirs'.explorer() end,       mode = { 'n', 'v', }, silent = true, desc = 'nvimtree explorer all dirs', },
  },
  dependencies = {
    require 'plugins.plenary',
    require 'plugins.whichkey',
  },
  init = function()
    require 'config.whichkey'.add { ['<leader>a'] = { name = 'Side Panel', }, }
  end,
  config = function()
    require 'config.nvimtree'
  end,
}
