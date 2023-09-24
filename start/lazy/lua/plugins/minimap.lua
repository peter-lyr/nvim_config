return {
  'echasnovski/mini.map',
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  keys = {
    { '<leader>am', function() MiniMap.toggle() end,       mode = { 'n', 'v', }, silent = true, desc = 'MiniMap toggle', },
    { '<leader>an', function() MiniMap.toggle_focus() end, mode = { 'n', 'v', }, silent = true, desc = 'MiniMap toggle_focus', },
  },
  init = function()
    require 'which-key'.register { ['<leader>a'] = { name = 'Side Panel', }, }
  end,
  config = function()
    require 'config.minimap'
  end,
}
