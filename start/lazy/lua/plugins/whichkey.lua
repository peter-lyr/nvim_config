local S = require 'my_simple'

local plugin = 'folke/which-key.nvim'
local config = 'whichkey'

return {
  plugin,
  lazy = true,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  keys = {
    S.gkey('<leader>', plugin, config),
  },
  config = function()
    S.load_require(plugin, config)
  end,
}
