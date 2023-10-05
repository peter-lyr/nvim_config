return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  cmd = {
    'NvimTreeFindFile',
    'NvimTreeOpen',
  },
  keys = {
    { '<leader>af', function() require 'config.nvimtree'.findfile() end, mode = { 'n', 'v', }, silent = true, desc = 'NvimTree findfile', },
    { '<leader>ao', function() require 'config.nvimtree'.open() end,     mode = { 'n', 'v', }, silent = true, desc = 'NvimTree open', },
    { '<leader>ac', function() require 'config.nvimtree'.close() end,    mode = { 'n', 'v', }, silent = true, desc = 'NvimTree close', },
    { '<leader>ap', function() require 'config.nvimtree'.path() end,     mode = { 'n', 'v', }, silent = true, desc = 'NvimTree open path', },
  },
  dependencies = {
    require 'plugins.plenary',
    require 'plugins.whichkey',
  },
  init = function()
    require 'which-key'.register { ['<leader>a'] = { name = 'Side Panel', }, }
  end,
  config = function()
    require 'config.nvimtree'
  end,
}
