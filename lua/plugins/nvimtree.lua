local S = require 'startup'

local plugin = 'nvim-tree/nvim-tree.lua'
local map = 'Nvimtree'

return {
  'nvim-tree/nvim-tree.lua',
  commit = '00741206',
  lazy = true,
  init = function()
    if not S.enable then
      require 'my_simple'.add_whichkey('<leader>a', plugin, map)
    end
  end,
  config = function()
    require 'my_simple'.load_require(plugin, 'map.' .. map)
  end,
}
