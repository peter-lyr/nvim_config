local S = require 'startup'

local plugin = 'nvim-treesitter/nvim-treesitter'
local map = 'Treesitter'

return {
  plugin,
  lazy = true,
  version = '*', -- last release
  build = ':TSUpdate',
  ft = {
    'c', 'cpp',
    'python',
    'lua',
    'markdown',
  },
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
