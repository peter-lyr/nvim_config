local S = require 'my_simple'

local plugin = 'test'
local map = 'test'

return {
  name = plugin,
  dir = S.get_opt_dir(plugin),
  lazy = true,
  init = function()
    S.wkey('<c-s-f4>', plugin, map)
  end,
  config = function()
    S.load_require(plugin, 'map.' .. map)
  end,
}
