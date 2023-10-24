local S = require 'my_simple'

local plugin = 'echasnovski/mini.map'
local map = 'Minimap'

return {
  plugin,
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  init = function()
    S.wkey('<leader>a', plugin, map)
  end,
  config = function()
    S.load_require(plugin, 'map.' .. map)
  end,
}
