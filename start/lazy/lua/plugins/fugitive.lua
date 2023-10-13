return {
  'tpope/vim-fugitive',
  lazy = true,
  cmd = { 'Git', },
  dependencies = {
    require 'plugins.whichkey',
  },
  keys = {
    { '<leader>ag', function() require 'config.fugitive'.toggle() end, mode = { 'n', 'v', }, silent = true, desc = 'Git toggle', },
  },
  init = function()
    require 'config.whichkey'.add { ['<leader>a'] = { name = 'Side Panel', }, }
  end,
  config = function()
    require 'config.fugitive'
  end,
}
