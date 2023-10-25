local S = require 'startup'

local plugin = 'tpope/vim-fugitive'
local map = 'Fugitive'

return {
  plugin,
  lazy = true,
  cmd = {
    'Git',
  },
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>a', plugin, map)
    end
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
