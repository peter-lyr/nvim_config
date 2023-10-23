local S = require 'my_simple'

local plugin = 'echasnovski/mini.map'
local config = 'minimap'

return {
  plugin,
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  keys = {
    S.gkey('<leader>a', plugin, config),
  },
  config = function()
    S.load_require(plugin, config)
  end,
}
