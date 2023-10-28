local S = require 'startup'

local plugin = 'tpope/vim-fugitive'

return {
  plugin,
  lazy = true,
  cmd = {
    'Git',
  },
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>a', plugin, 'Fugitive')
    end
  end,
  config = function()
    require 'map.fugitive'
  end,
}
