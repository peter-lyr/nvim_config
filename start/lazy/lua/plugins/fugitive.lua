local S = require 'my_simple'

local plugin = 'tpope/vim-fugitive'
local map = 'fugitive'

return {
  plugin,
  lazy = true,
  cmd = {
    'Git',
  },
  init = function()
    S.wkey('<leader>a', plugin, map)
  end,
  config = function()
    S.load_require(plugin, 'map.' .. map)
  end,
}
