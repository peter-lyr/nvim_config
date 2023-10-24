local S = require 'my_simple'

local plugin = 'echasnovski/mini.map'
local map = 'minimap'

return {
  plugin,
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  -- config = function()
  --   S.load_require(plugin, map)
  -- end,
  init = function()
    S.wkey('<leader>', plugin, map)
  end,
}
