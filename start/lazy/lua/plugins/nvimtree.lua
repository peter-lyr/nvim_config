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
  },
  dependencies = {
    require 'plugins.treesitter',
    require 'plugins.plenary',
    require 'plugins.projectroot',
    require 'plugins.whichkey',
  },
  init = function()
    require 'which-key'.register { ['<leader>a'] = { name = 'Side Panel', }, }
  end,
  config = function()
    require 'config.nvimtree'
  end,
}
