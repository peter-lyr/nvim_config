local plugin = 'hrsh7th/nvim-cmp'

return {
  plugin,
  lazy = true,
  version = false, -- last release is way too old
  ft = {
    'c', 'cpp',
    'lua',
    'markdown',
    'python',
  },
  config = function()
    require 'map.cmp'
  end,
}
