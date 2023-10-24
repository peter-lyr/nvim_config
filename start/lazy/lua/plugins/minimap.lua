local S = require 'my_simple'

local plugin = 'echasnovski/mini.map'
local map = 'minimap'

return {
  plugin,
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  keys = {
    S.gkey('<leader>', 'a', plugin, map),
  },
  -- config = function()
  --   S.load_require(plugin, map)
  -- end,
}
