local S = require 'startup'

local plugin = 'nvim-tree/nvim-tree.lua'

return {
  'nvim-tree/nvim-tree.lua',
  commit = '00741206',
  lazy = true,
  init = function()
    if not S.load_whichkeys_txt_enable then
      require 'my_simple'.add_whichkey('<leader>a', plugin, 'Nvimtree')
    end
  end,
  config = function()
    require 'map.nvimtree'
  end,
}
