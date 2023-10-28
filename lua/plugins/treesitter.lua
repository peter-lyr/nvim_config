local plugin = 'nvim-treesitter/nvim-treesitter'

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
    require 'map.treesitter'
  end,
}
