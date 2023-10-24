local S = require 'my_simple'

local plugin = 'tpope/vim-fugitive'
local map = 'fugitive'

return {
  plugin,
  lazy = true,
  -- cmd = {
  --   'Git',
  -- },
  -- config = function()
  --   S.load_require(plugin, map)
  -- end,
  init = function()
    S.wkey('<leader>', plugin, map)
  end
}
