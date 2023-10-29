local S = require 'startup'

local plugin = 'sindrets/diffview.nvim'

return {
  plugin,
  lazy = true,
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>g', plugin, 'Diffview')
    end
  end,
  config = function()
    require 'map.diffview'
  end,
}
