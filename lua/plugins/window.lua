local S = require 'startup'

local plugin = 'window'

return {
  name = plugin,
  dir = '',
  lazy = true,
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>w', plugin, 'Window')
    end
  end,
  config = function()
    require 'map.window'
  end,
}
