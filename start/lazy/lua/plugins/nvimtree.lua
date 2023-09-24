return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  cmd = {
    'NvimTreeFindFile',
    'NvimTreeOpen',
  },
  keys = {
    { '<leader>af', '<cmd>NvimTreeFindFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'NvimTreeFindFile', },
    { '<leader>ao', '<cmd>NvimTreeOpen<cr>',     mode = { 'n', 'v', }, silent = true, desc = 'NvimTreeOpen', },
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
