local S = require 'startup'

local plugin = 'test'

return {
  name = plugin,
  dir = '',
  lazy = true,
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<c-s-f4>', plugin, 'Test')
    end
  end,
  config = function()
    require 'map.test'
  end,
}
