local S = require 'my_simple'

local plugin = 'folke/which-key.nvim'
local map = 'whichkey'

return {
  plugin,
  lazy = true,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    S.wkey('<leader>', plugin, map)
  end,
  -- config = function()
  --   S.load_require(plugin, map)
  -- end,
}
