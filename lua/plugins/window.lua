local S = require 'startup'

local plugin = 'window'

return {
  name = plugin,
  dir = '',
  lazy = true,
  keys = {
    { '<a-s-h>', function() require 'config.window'.height_less() end, mode = { 'n', 'v', }, silent = true, desc = 'Window height_less', },
    { '<a-s-l>', function() require 'config.window'.height_more() end, mode = { 'n', 'v', }, silent = true, desc = 'Window height_more', },
    { '<a-s-j>', function() require 'config.window'.width_less() end,  mode = { 'n', 'v', }, silent = true, desc = 'Window width_less', },
    { '<a-s-k>', function() require 'config.window'.width_more() end,  mode = { 'n', 'v', }, silent = true, desc = 'Window width_more', },
  },
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>w', plugin, 'Window')
    end
  end,
  config = function()
    require 'map.window'
  end,
}
