local S = require 'startup'

local plugin = 'echasnovski/mini.map'

return {
  plugin,
  version = '*',
  event = { 'BufReadPost', 'BufNewFile', },
  lazy = true,
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>a', plugin, 'Minimap')
    end
  end,
  config = function()
    require 'map.minimap'
  end,
}
