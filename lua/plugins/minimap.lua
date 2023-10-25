local S = require 'startup'

local plugin = 'echasnovski/mini.map'
local map = 'Minimap'

return {
  plugin,
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  init = function()
    if not S.enable then
      require 'my_simple'.wkey('<leader>a', plugin, map)
    end
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
