local S = require 'startup'

local plugin = 'sessions'

return {
  name = plugin,
  dir = '',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile', },
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>s', plugin, 'Sessions')
    end
  end,
  config = function()
    require 'map.sessions'
  end,
}
