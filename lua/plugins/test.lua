local S = require 'startup'

local plugin = 'test'
local map = 'Test'

return {
  name = plugin,
  dir = '',
  lazy = true,
  init = function()
    if not S.enable then
      require 'my_simple'.wkey('<c-s-f4>', plugin, map)
    end
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
