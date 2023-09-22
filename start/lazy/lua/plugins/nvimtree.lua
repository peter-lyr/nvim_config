return {
  'nvim-tree/nvim-tree.lua',
  lazy = true,
  cmd = {
    'NvimTreeFindFile',
    'NvimTreeOpen',
  },
  keys = {
    { '<leader>a<leader>', '<cmd>NvimTreeFindFile<cr>', mode = { 'n', 'v', }, silent = true, desc = 'NvimTreeFindFile', },
  },
  dependencies = {
    require 'plugins.treesitter',
    require 'plugins.plenary',
    require 'plugins.projectroot',
  },
  config = function()
    require 'config.nvimtree'
  end,
}
